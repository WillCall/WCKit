//
//  WCPhysicsAnimation.m
//  WCPhysicsAnimation
//
//  Created by Patrick Tescher on 12/12/12.
//
//

#import <UIKit/UIKit.h>

#import "WCPhysicsViewAnimation.h"
#import "WCPhysicsSimulation.h"
#import "WCPhysicsSimulationBody.h"
#import "chipmunk.h"

static float defaultMass      = 0.5f;
static int defaultStiffness   = 300;
static int defaultDamping     = 16;

@interface WCPhysicsViewAnimation ()

@property (strong, nonatomic) WCPhysicsSimulation *simulation;
@property (strong, nonatomic) NSArray *sizeValues;
@property (strong, nonatomic) NSArray *positionValues;

@property (strong, nonatomic) CAKeyframeAnimation *sizeAnimation;
@property (strong, nonatomic) CAKeyframeAnimation *positionAnimation;
@property (strong, nonatomic) CAKeyframeAnimation *shadowAnimation;
@property (strong, nonatomic) CAKeyframeAnimation *shadowOffsetAnimation;

@end

@implementation WCPhysicsViewAnimation

+ (WCPhysicsViewAnimation*)animationFrom:(CGRect)fromValue to:(CGRect)toValue {
    WCPhysicsViewAnimation *newPhysicsAnimation = [[WCPhysicsViewAnimation alloc] init];
    newPhysicsAnimation.fromValue = fromValue;
    newPhysicsAnimation.toValue = toValue;
    return newPhysicsAnimation;
}

+ (WCPhysicsViewAnimation*)animationFrom:(CGRect)fromValue to:(CGRect)toValue withStiffness:(NSNumber*)stiffness mass:(NSNumber*)mass damping:(NSNumber*)damping {
    WCPhysicsViewAnimation *newPhysicsAnimation = [WCPhysicsViewAnimation animationFrom:fromValue to:toValue];
    newPhysicsAnimation.stiffness = stiffness;
    newPhysicsAnimation.mass = mass;
    newPhysicsAnimation.damping = damping;
    return newPhysicsAnimation;
}

- (id)copyWithZone:(NSZone *)zone {
    WCPhysicsViewAnimation *copy = [[[self class] allocWithZone:zone] init];
    copy.fromValue = self.fromValue;
    copy.toValue = self.toValue;
    copy.mass = self.mass;
    copy.stiffness = self.stiffness;
    copy.damping = self.damping;
    copy.simulation = self.simulation;
    return copy;
}

- (id)init {
    self = [super init];
    if (self) {
        [self loadDefaults];
        self.removedOnCompletion = TRUE;
    }
    return self;
}

- (void)loadDefaults {
    self.mass = [NSNumber numberWithFloat: defaultMass];
    self.stiffness = [NSNumber numberWithInt: defaultStiffness];
    self.damping = [NSNumber numberWithInt: defaultDamping];
}

- (NSTimeInterval)duration {
    return self.simulation.duration;
}

- (WCPhysicsSimulation*)simulation {
    if (_simulation) {
        return _simulation;
    }
    
    CGRect origin = self.fromValue;
    CGRect destination = self.toValue;

    WCPhysicsSimulationBody *centerBody = [[WCPhysicsSimulationBody alloc] init];
    centerBody.name = @"position";
    centerBody.origin = [NSValue valueWithCGPoint:centerOfRect(origin)];
    centerBody.destination = [NSValue valueWithCGPoint: centerOfRect(destination)];
    centerBody.stiffness = self.stiffness;
    centerBody.damping = self.damping;
    centerBody.mass = self.mass;

    WCPhysicsSimulationBody *sizeBody = [[WCPhysicsSimulationBody alloc] init];
    sizeBody.name = @"size";
    sizeBody.origin = [NSValue valueWithCGPoint:CGPointMake(origin.size.width, origin.size.height)];
    sizeBody.destination = [NSValue valueWithCGPoint: CGPointMake(destination.size.width, destination.size.height)];
    sizeBody.stiffness = self.stiffness;
    sizeBody.damping = self.damping;
    sizeBody.mass = self.mass;

    WCPhysicsSimulation *simulation = [WCPhysicsSimulation physicsSimulationWithBodies:@[centerBody, sizeBody]];

    return simulation;
}

- (NSArray*)sizeValues {
    NSArray *sizeValues = [self.simulation.animationValues valueForKeyPath:@"@unionOfObjects.size"];
    return sizeValues;;
}

- (NSArray*)positionValues {
    NSArray *positionValues = [self.simulation.animationValues valueForKeyPath:@"@unionOfObjects.position"];
    return positionValues;
}

- (CAKeyframeAnimation*)sizeAnimation {
    if (_sizeAnimation) {
        return _sizeAnimation;
    }

    _sizeAnimation = [[CAKeyframeAnimation alloc] init];
    _sizeAnimation.keyPath = @"bounds.size";
    _sizeAnimation.calculationMode = kCAAnimationDiscrete;
    [_sizeAnimation setValues:self.sizeValues];
    [_sizeAnimation setDuration:self.duration];
    _sizeAnimation.removedOnCompletion = TRUE;
    return _sizeAnimation;
}

- (CAKeyframeAnimation*)positionAnimation {
    if (_positionAnimation) {
        return _positionAnimation;
    }

    _positionAnimation = [[CAKeyframeAnimation alloc] init];
    _positionAnimation.keyPath = @"position";
    _positionAnimation.calculationMode = kCAAnimationDiscrete;
    [_positionAnimation setDuration:self.duration];
    [_positionAnimation setValues:self.positionValues];
    _positionAnimation.removedOnCompletion = TRUE;
    return _positionAnimation;
}

- (NSArray*)animations {
    return @[self.sizeAnimation, self.positionAnimation];
}

#pragma mark - Utilities
CGPoint centerOfRect(CGRect rect) {
    return CGPointMake(rect.origin.x + (rect.size.width / 2), rect.origin.y + (rect.size.height / 2));
}


@end
