//
//  WCPhysicsSimulation.h
//  WCKit
//
//  Created by Patrick Tescher on 12/13/12.
//
//

#import <Foundation/Foundation.h>

@interface WCPhysicsSimulation : NSObject

@property (strong, nonatomic) NSArray *bodies;
@property (strong, nonatomic) NSArray *animationValues;
@property (nonatomic) NSTimeInterval duration;

+ (WCPhysicsSimulation*)physicsSimulationWithBodies:(NSArray*)bodies;

@end
