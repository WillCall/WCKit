//
//  WCScrollViewAnimation.m
//  WCKit
//
//  Created by Patrick Tescher on 3/31/13.
//
//

#import <UIKit/UIKit.h>

#import "WCScrollViewPhysicsAnimation.h"
#import "WCPhysicsSimulationBody.h"

static float defaultMass      = 0.5f;
static int defaultStiffness   = 300;
static int defaultDamping     = 16;

@implementation WCScrollViewPhysicsAnimation

- (id)init {
    self = [super init];
    if (self) {
        [self loadDefaults];
        self.removedOnCompletion = TRUE;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    WCScrollViewPhysicsAnimation *copy = [[[self class] allocWithZone:zone] init];
    copy.fromValue = self.fromValue;
    copy.toValue = self.toValue;
    copy.mass = self.mass;
    copy.stiffness = self.stiffness;
    copy.damping = self.damping;
    copy.simulation = self.simulation;
    return copy;
}

- (void)loadDefaults {
    self.mass = [NSNumber numberWithFloat: defaultMass];
    self.stiffness = [NSNumber numberWithInt: defaultStiffness];
    self.damping = [NSNumber numberWithInt: defaultDamping];

    self.keyPath = @"bounds";
    self.calculationMode = kCAAnimationDiscrete;
    self.removedOnCompletion = TRUE;
}

- (WCPhysicsSimulation*)simulation {
    if (_simulation) {
        return _simulation;
    }

    CGPoint origin = self.fromValue.origin;
    CGPoint destination = self.toValue.origin;


    WCPhysicsSimulationBody *contentOffsetBody = [[WCPhysicsSimulationBody alloc] init];
    contentOffsetBody.name = @"bounds";
    contentOffsetBody.origin = [NSValue valueWithCGPoint:origin];
    contentOffsetBody.destination = [NSValue valueWithCGPoint: destination];
    contentOffsetBody.stiffness = self.stiffness;
    contentOffsetBody.damping = self.damping;
    contentOffsetBody.mass = self.mass;

    _simulation = [WCPhysicsSimulation physicsSimulationWithBodies:@[contentOffsetBody]];
    return _simulation;
}

- (NSTimeInterval)duration {
    return self.simulation.duration / self.speed;
}

- (NSArray*)values {
    if (self.simulation.animationValues.count > 0) {
        NSArray *points = [self.simulation.animationValues valueForKeyPath:@"@unionOfObjects.bounds"];
        NSMutableArray *rects = [[NSMutableArray alloc] initWithCapacity:points.count + 2];
        [rects addObject:[NSValue valueWithCGRect:self.fromValue]];
        for (NSValue *value in points) {
            CGPoint point = value.CGPointValue;
            CGRect rect = self.fromValue;
            rect.origin = point;
            [rects addObject:[NSValue valueWithCGRect:rect]];
        }
        [rects addObject:[NSValue valueWithCGRect:self.toValue]];
        return [NSArray arrayWithArray:rects];
    } else {
        return @[];
    }
}


@end
