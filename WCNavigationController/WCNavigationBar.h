//
//  WCNavigationBar.h
//  WCKit
//
//  Created by Patrick Tescher on 9/14/12.
//
//

#import <UIKit/UIKit.h>

typedef void (^WCNavigationBarAnimationCompletionBlock)(BOOL finished);
typedef void (^WCNavigationBarAnimationBlock)(UINavigationItem *sourceNavigationItem, UINavigationItem *destinationAnimationItem, WCNavigationBarAnimationCompletionBlock completion);

@interface WCNavigationBar : UINavigationBar

@property (strong, nonatomic) WCNavigationBarAnimationBlock pushAnimationBlock;
@property (strong, nonatomic) WCNavigationBarAnimationBlock popAnimationBlock;

@end
