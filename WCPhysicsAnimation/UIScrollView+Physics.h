//
//  UIScrollView+Physics.h
//  WCKit
//
//  Created by Patrick Tescher on 4/1/13.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Physics)

- (void)snapToOffset:(CGPoint)offset;
- (void)snapToOffset:(CGPoint)offset completion:(void (^)())completion;

@end
