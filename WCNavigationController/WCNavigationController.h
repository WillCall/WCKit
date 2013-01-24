//
//  WCNavigationController.h
//  WCNavigationController
//
//  Created by Patrick Tescher on 9/13/12.
//
//

#import <UIKit/UIKit.h>

typedef void (^WCViewControllerAnimationCompletionBlock)(BOOL finished);
typedef void (^WCViewControllerAnimationBlock)(UIViewController *sourceViewController, UIViewController *destinationViewController, WCViewControllerAnimationCompletionBlock completion);

@interface WCNavigationController : UINavigationController

@property (strong, nonatomic) WCViewControllerAnimationBlock pushAnimationBlock;
@property (strong, nonatomic) WCViewControllerAnimationBlock popAnimatiobBlock;

@end
