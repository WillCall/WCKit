//
//  WCScrollViewAnimation.m
//  WCKit
//
//  Created by Patrick Tescher on 3/31/13.
//
//

#import <UIKit/UIKit.h>

#import "WCScrollViewAnimation.h"
#import "WCPhysicsSimulationBody.h"

static float defaultMass      = 0.5f;
static int defaultStiffness   = 300;
static int defaultDamping     = 16;

@implementation WCScrollViewAnimation

- (id)init {
    self = [super init];
    if (self) {
        [self loadDefaults];
        self.removedOnCompletion = TRUE;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    WCScrollViewAnimation *copy = [[[self class] allocWithZone:zone] init];
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

    self.keyPath = @"contentOffset";
    self.calculationMode = kCAAnimationDiscrete;
    self.removedOnCompletion = TRUE;
}

- (WCPhysicsSimulation*)simulation {
    if (_simulation) {
        return _simulation;
    }

    CGPoint origin = self.fromValue;
    CGPoint destination = self.toValue;

    WCPhysicsSimulationBody *contentOffsetBody = [[WCPhysicsSimulationBody alloc] init];
    contentOffsetBody.name = @"contentOffset";
    contentOffsetBody.origin = [NSValue valueWithCGPoint:origin];
    contentOffsetBody.destination = [NSValue valueWithCGPoint: destination];
    contentOffsetBody.stiffness = self.stiffness;
    contentOffsetBody.damping = self.damping;
    contentOffsetBody.mass = self.mass;

    _simulation = [WCPhysicsSimulation physicsSimulationWithBodies:@[contentOffsetBody]];
    return _simulation;
}

- (NSTimeInterval)duration {
    return self.simulation.duration;
}

- (NSArray*)values {
    return [self.simulation.animationValues valueForKeyPath:@"@unionOfObjects.contentOffset"];
}

@end
