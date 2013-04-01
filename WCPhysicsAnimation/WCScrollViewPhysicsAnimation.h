//
//  WCScrollViewAnimation.h
//  WCKit
//
//  Created by Patrick Tescher on 3/31/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "WCPhysicsSimulation.h"

@interface WCScrollViewPhysicsAnimation : CAKeyframeAnimation

@property (strong, nonatomic) WCPhysicsSimulation *simulation;
@property (nonatomic) CGRect fromValue;
@property (nonatomic) CGRect toValue;

@property (nonatomic, strong) NSNumber *stiffness;
@property (nonatomic, strong) NSNumber *mass;
@property (nonatomic, strong) NSNumber *damping;

@end
