//
//  WCNavigationController.m
//  WCNavigationController
//
//  Created by Patrick Tescher on 9/13/12.
//
//

#import "WCNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@implementation WCNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        if (self.pushAnimationBlock) {
            self.pushAnimationBlock(self.topViewController, viewController, ^(BOOL finished){
                [super pushViewController:viewController animated:FALSE];
            });
        } else {
            [super pushViewController:viewController animated:TRUE];
        }
    } else {
        [super pushViewController:viewController animated:FALSE];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (animated && self.viewControllers.count > 1) {
        UIViewController* destinationViewController = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
        if (self.popAnimatiobBlock) {
            self.popAnimatiobBlock(self.topViewController, destinationViewController, ^(BOOL finished){
                [super popViewControllerAnimated:FALSE]; // Temp
            });
        } else {
            [super popViewControllerAnimated:TRUE];
        }
        return destinationViewController;
    } else {
        return [super popViewControllerAnimated:FALSE];
    }
}

#pragma mark - Debug

- (void)printSubviewStackForView:(UIView*)aView tabCount:(NSInteger)count {
    NSString *output = @"                                                                                                              ";
    output = [output substringToIndex:count];
    output = [output stringByAppendingString:[NSString stringWithFormat:@"%@, ->", [aView class]]];
    NSLog(@"%@", output);
    [self printAnimationsForView:aView];
    for (UIView *subview in aView.subviews) {
        [self printSubviewStackForView:subview tabCount:count + 1];
    }
}

- (void)printAnimationsForView:(UIView*)view {
    for (NSString *animationKey in view.layer.animationKeys) {
        CAAnimation *animation = [view.layer animationForKey:animationKey];
        if ([animation isKindOfClass:[CABasicAnimation class]]) {
            CABasicAnimation *basicAnimation = (CABasicAnimation*)animation;
            NSLog(@"%@: %@%@%@", [basicAnimation class],
                  basicAnimation.keyPath == nil ? @"" : [NSString stringWithFormat:@"keyPath: %@, ", basicAnimation.keyPath],
                  basicAnimation.fromValue == nil ? @"" : [NSString stringWithFormat:@"from: %@, ", basicAnimation.fromValue],
                  basicAnimation.toValue == nil ? @"" : [NSString stringWithFormat:@"to: %@, ", basicAnimation.toValue]
                  );
        }
    }
}

@end
