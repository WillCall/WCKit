//
//  WCPhysicsSimulationBody.h
//  WCKit
//
//  Created by Patrick Tescher on 12/13/12.
//
//

#import <Foundation/Foundation.h>
#import "chipmunk.h"

@interface WCPhysicsSimulationBody : NSObject

@property (nonatomic, strong) NSString *name;
@property (readonly) NSValue *animationValue;
//@property (readonly) NSNumber *shadowValue;
//@property (readonly) NSValue *shadowOffset;

@property (nonatomic, strong) NSValue *origin;
@property (nonatomic, strong) NSValue *destination;
@property (nonatomic, strong) NSNumber *stiffness;
@property (nonatomic, strong) NSNumber *mass;
@property (nonatomic, strong) NSNumber *damping;

@property (nonatomic) cpBody *cpBody;
@property (nonatomic) cpConstraint *spring;

@end
