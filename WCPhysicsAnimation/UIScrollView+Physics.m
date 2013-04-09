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
    [self snapToOffset:offset completion:nil];
}

- (void)snapToOffset:(CGPoint)offset completion:(void (^)())completion; {
    WCScrollViewPhysicsAnimation *animation = [WCScrollViewPhysicsAnimation new];
    animation.fromValue = self.bounds;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(offset.x - self.contentOffset.x, offset.y - self.contentOffset.y);
    animation.toValue = CGRectApplyAffineTransform(self.bounds, transform);
    NSLog(@"Snaping from %@ to %@", NSStringFromCGRect(animation.fromValue), NSStringFromCGRect(animation.toValue));
    [self.layer addAnimation:animation forKey:@"bounds"];
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, animation.duration * NSEC_PER_SEC), dispatch_get_main_queue(), completion);
    }
    self.bounds = animation.toValue;
}

@end
