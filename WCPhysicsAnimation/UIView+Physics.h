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


- (void)snapToFrame:(CGRect)newFrame __attribute__((deprecated));
- (void)snapToOriginalFrame __attribute__((deprecated));
- (void)snapToAlternateFrame __attribute__((deprecated));

- (void)snapToFrame:(CGRect)newFrame completion:(void (^)())completion __attribute__((deprecated));
- (void)snapToFrame:(CGRect)newFrame withMass:(NSNumber*)mass stiffness:(NSNumber*)stiffness damping:(NSNumber*)damping completion:(void (^)())completion __attribute__((deprecated));
- (void)snapToOriginalFrameWithCompletion:(void (^)())completion __attribute__((deprecated));
- (void)snapToAlternateFrameWithCompletion:(void (^)())completion __attribute__((deprecated));


- (IBAction)viewMoved:(UIPanGestureRecognizer*)gesture;
- (IBAction)viewScaled:(UIPinchGestureRecognizer*)gesture;
- (IBAction)viewTapped:(UITapGestureRecognizer*)gesture;

@end
