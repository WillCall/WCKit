//
//  UIView+Physics.h
//  WCKit
//
//  Created by Patrick Tescher on 12/14/12.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Physics) <UIGestureRecognizerDelegate>

@property (nonatomic) CGRect originalFrame;
@property (nonatomic) CGRect alternateFrame;

- (void)snapToFrame:(CGRect)newFrame;
- (void)snapToOriginalFrame;
- (void)snapToAlternateFrame;

- (IBAction)viewMoved:(UIPanGestureRecognizer*)gesture;
- (IBAction)viewScaled:(UIPinchGestureRecognizer*)gesture;
- (IBAction)viewTapped:(UITapGestureRecognizer*)gesture;

@end
