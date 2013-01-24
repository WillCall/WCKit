//
//  WCPhysicsAnimation.h
//  WCPhysicsAnimation
//
//  Created by Patrick Tescher on 12/12/12.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface WCPhysicsViewAnimation : CAAnimationGroup

@property (nonatomic) CGRect fromValue;
@property (nonatomic) CGRect toValue;
@property (nonatomic, strong) NSNumber *stiffness;
@property (nonatomic, strong) NSNumber *mass;
@property (nonatomic, strong) NSNumber *damping;

+ (WCPhysicsViewAnimation*)animationFrom:(CGRect)fromValue to:(CGRect)toValue;
+ (WCPhysicsViewAnimation*)animationFrom:(CGRect)fromValue to:(CGRect)toValue withStiffness:(NSNumber*)stiffness mass:(NSNumber*)mass damping:(NSNumber*)damping;

@end
