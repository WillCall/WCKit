//
//  UIView+Physics.m
//  WCKit
//
//  Created by Patrick Tescher on 12/14/12.
//
//

#import "UIView+Physics.h"
#import "WCPhysicsViewAnimation.h"
#import <objc/runtime.h>

static void *OriginalFrameKey;
static void *AlternateFrameKey;

@implementation UIView (Physics)

@dynamic originalFrame;
@dynamic alternateFrame;

#pragma mark - Positioning

- (void)setOriginalFrame:(CGRect)originalFrame {
    objc_setAssociatedObject(self, &OriginalFrameKey, [NSValue valueWithCGRect: originalFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)originalFrame {
    NSValue *result = objc_getAssociatedObject(self, &OriginalFrameKey) ?: [NSValue valueWithCGRect:self.frame];
    return result.CGRectValue;
}

- (void)setAlternateFrame:(CGRect)alternateFrame {
    objc_setAssociatedObject(self, &AlternateFrameKey, [NSValue valueWithCGRect: alternateFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)alternateFrame {
    NSValue *result = objc_getAssociatedObject(self, &AlternateFrameKey) ?: [NSValue valueWithCGRect:self.superview.bounds];
    return result.CGRectValue;
}

CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};

CGFloat DistanceBetweenTwoRects(CGRect firstRect, CGRect secondRect) {
    float topLeftDistance = DistanceBetweenTwoPoints(firstRect.origin, secondRect.origin);
    float bottomRightDistance = DistanceBetweenTwoPoints(CGPointMake(CGRectGetMaxX(firstRect), CGRectGetMaxY(firstRect)), CGPointMake(CGRectGetMaxX(secondRect), CGRectGetMaxY(secondRect)));
    return topLeftDistance + bottomRightDistance;
}

- (BOOL)rect:(CGRect)rect isCloserTo:(CGRect)firstRect than:(CGRect)secondRect {
    float firstRectDistance = DistanceBetweenTwoRects(rect, firstRect);
    float secontRectDistance = DistanceBetweenTwoRects(rect, secondRect);
    if (firstRectDistance < secontRectDistance) {
        return TRUE;
    } else {
        return FALSE;
    }
}

#pragma mark - Physics

- (void)snapToClosestFrame {
    if ([self rect:self.frame isCloserTo:self.originalFrame than:self.alternateFrame]) {
        [self snapToFrame:self.originalFrame];
    } else {
        [self snapToFrame:self.alternateFrame];
    }
}

- (void)snapToFrame:(CGRect)newFrame {
    CAAnimation *animation = [WCPhysicsViewAnimation animationFrom:self.frame to:newFrame];
    [self.layer addAnimation:animation forKey:@"physics"];
    self.frame = newFrame;
}

- (void)snapToOriginalFrame {
    [self snapToFrame:self.originalFrame];
}

- (void)snapToAlternateFrame {
    [self snapToFrame:self.alternateFrame];
}


#pragma mark - Actions

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.view == self && otherGestureRecognizer.view == self) {
        return TRUE;
    }
    return FALSE;
}

- (void)startGesture {
    if (CGRectIsEmpty(self.originalFrame)) {
        self.originalFrame = self.frame;
    }
}

- (NSArray*)endedGestureRecognizers {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.gestureRecognizers.count];
    for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [result addObject:gestureRecognizer];
        }
    }
    return [NSArray arrayWithArray:result];
}

- (IBAction)gestureEnded:(UIGestureRecognizer*)recognizer {
    if ([[self endedGestureRecognizers] lastObject] == recognizer) {
        [self snapToClosestFrame];
    }
}

- (IBAction)viewMoved:(UIPanGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self startGesture];
    }

    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self.superview];
        [self setCenter:CGPointMake(self.center.x + translation.x, self.center.y + translation.y)];
        [gesture setTranslation:CGPointZero inView:self.superview];
    }

    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        [self gestureEnded:gesture];
    }
}

- (IBAction)viewScaled:(UIPinchGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self startGesture];
    }

    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint originalCenter = self.center;
        CGAffineTransform transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
        self.frame = CGRectApplyAffineTransform(self.frame, transform);
        self.center = originalCenter;
        gesture.scale = 1;
    }

    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        [self gestureEnded:gesture];
    }
}

- (IBAction)viewTapped:(UITapGestureRecognizer*)gesture {
    if ([self rect:self.frame isCloserTo:self.originalFrame than:self.alternateFrame]) {
        [self snapToAlternateFrame];
    } else {
        [self snapToOriginalFrame];
    }
}

- (IBAction)viewPressed:(UIPanGestureRecognizer*)gesture {
    
}

#pragma mark - Gesture Recognizers

- (UIGestureRecognizer*)associagedGestureRecognizerForKey:(void *)key {
    UIGestureRecognizer *result = objc_getAssociatedObject(self, &key);
    return result;
}

- (void)setAssociatedGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer forKey:(void*)key {
    objc_setAssociatedObject(self, &key, gestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
