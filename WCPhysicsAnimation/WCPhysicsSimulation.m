//
//  WCPhysicsSimulation.m
//  WCKit
//
//  Created by Patrick Tescher on 12/13/12.
//
//

#import "WCPhysicsSimulation.h"
#import "WCPhysicsSimulationBody.h"

#import <UIKit/UIKit.h>
#import "chipmunk.h"

const float frameDuration = 1.0f / 60.0f;
const float maxFrames = 600.0f / frameDuration;
const float idleSpeedThreshold = 10.0f;
const float sleepTimeThreshold = 0.1f;

@implementation WCPhysicsSimulation

+ (WCPhysicsSimulation*)physicsSimulationWithBodies:(NSArray*)bodies {
    WCPhysicsSimulation *result = [[WCPhysicsSimulation alloc] init];
    result.bodies = bodies;
    return result;
}

- (NSDictionary*)currentFrameAnimationValue {
    NSMutableDictionary *animationValue = [NSMutableDictionary dictionaryWithCapacity:self.bodies.count];

    for (WCPhysicsSimulationBody *body in self.bodies) {
        animationValue[body.name] = body.animationValue;
    }
    
    return animationValue;
}

- (void)freeBodies {
    for (WCPhysicsSimulationBody *simulationBody in self.bodies) {
        cpConstraintFree(simulationBody.spring);
        cpBodyFree(simulationBody.cpBody);
    }
}

- (void)setAllBodiesToDestination {
    for (WCPhysicsSimulationBody *simulationBody in self.bodies) {
        simulationBody.cpBody->p.x = simulationBody.destination.CGPointValue.x;
        simulationBody.cpBody->p.y = simulationBody.destination.CGPointValue.y;
    }
}


- (NSTimeInterval)duration {
    if (_duration) {
        return _duration;
    }

    int frames = self.animationValues.count;
    if (frames < 1) {
        return 0;
    }

    _duration = frames * frameDuration;
    return _duration;
}

- (NSArray*)animationValues {
    if (_animationValues) {
        return _animationValues;
    }

    cpSpace *animationSpace = cpSpaceNew();
    animationSpace->idleSpeedThreshold = idleSpeedThreshold;
    animationSpace->sleepTimeThreshold = sleepTimeThreshold;

    cpBody *spaceBody = cpSpaceGetStaticBody(animationSpace);

    for (WCPhysicsSimulationBody *simulationBody in self.bodies) {
        simulationBody.cpBody = cpBodyNew(simulationBody.mass.floatValue, INFINITY);
        simulationBody.cpBody->p = simulationBody.origin.CGPointValue;
        cpSpaceAddBody(animationSpace, simulationBody.cpBody);
        simulationBody.spring = cpDampedSpringNew(spaceBody, simulationBody.cpBody, simulationBody.destination.CGPointValue, cpvzero, 0.0f, simulationBody.stiffness.integerValue, simulationBody.damping.integerValue);
        cpSpaceAddConstraint(animationSpace, simulationBody.spring);
    }


    NSMutableArray *animationValues = [[NSMutableArray alloc] init];
    [animationValues addObject:[self currentFrameAnimationValue]];

    __block bool simulationEnded = FALSE;
    while (simulationEnded == FALSE && animationValues.count < (maxFrames)) {
        cpSpaceStep(animationSpace, frameDuration);
        [animationValues addObject:[self currentFrameAnimationValue]];

        simulationEnded = TRUE;
        cpSpaceEachBody_b(animationSpace, ^(cpBody *body){
            if (!cpBodyIsSleeping(body)) {
                simulationEnded = FALSE;
            }
        });
    }
    
    [self setAllBodiesToDestination];
    [animationValues addObject:[self currentFrameAnimationValue]];
    [self freeBodies];
    self.animationValues = [NSArray arrayWithArray:animationValues];
    return _animationValues;
}

@end
