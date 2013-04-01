//
//  UIScrollView+Physics.m
//  WCKit
//
//  Created by Patrick Tescher on 4/1/13.
//
//

#import "UIScrollView+Physics.h"
#import "WCScrollViewPhysicsAnimation.h"

@implementation UIScrollView (Physics)

- (void)snapToOffset:(CGPoint)offset {
    WCScrollViewPhysicsAnimation *animation = [WCScrollViewPhysicsAnimation new];
    animation.fromValue = self.layer.bounds;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(offset.x - self.contentOffset.x, offset.y - self.contentOffset.y);
    animation.toValue = CGRectApplyAffineTransform(self.layer.bounds, transform);
    [self.layer addAnimation:animation forKey:@"bounds.center"];
}

@end
