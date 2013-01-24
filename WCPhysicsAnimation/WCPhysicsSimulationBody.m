//
//  WCPhysicsSimulationBody.m
//  WCKit
//
//  Created by Patrick Tescher on 12/13/12.
//
//

#import "WCPhysicsSimulationBody.h"
#import <UIKit/UIKit.h>

@implementation WCPhysicsSimulationBody

- (NSValue*)animationValue {
    if ([self.name isEqualToString:@"size"]) {
        CGSize size = CGSizeMake(self.cpBody->p.x, self.cpBody->p.y);
        return [NSValue valueWithCGSize:size];
    } else {
        CGPoint point = CGPointMake(self.cpBody->p.x, self.cpBody->p.y);
        return [NSValue valueWithCGPoint:point];
    }
}

@end
