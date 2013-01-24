//
//  WCNavigationBar.m
//  WCKit
//
//  Created by Patrick Tescher on 9/14/12.
//
//

#import "WCNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@interface UINavigationBar (PrivateStuff)
- (void)pushNavigationItem:(UINavigationItem*)item;
@end

@implementation WCNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.backgroundColor != [UIColor clearColor]) {
        [super drawRect:rect];
    }
}


- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated {
    if (animated && self.items.count > 1) {
        UINavigationItem* destinationItem = [self.items objectAtIndex:self.items.count - 2];
        if (self.popAnimationBlock) {
            self.popAnimationBlock(self.topItem, destinationItem, ^(BOOL finished){
                [super popNavigationItemAnimated:FALSE];
            });
        } else {
            [super popNavigationItemAnimated:TRUE];
        }
        return destinationItem;
    } else {
        return [super popNavigationItemAnimated:FALSE];
    }
}

- (void)pushNavigationItem:(UINavigationItem *)item animated:(BOOL)animated {
    if (animated) {
        if (self.pushAnimationBlock) {
            self.pushAnimationBlock(self.topItem, item, ^(BOOL finished){
                @try {
                    [super pushNavigationItem:item animated:FALSE];
                }
                @catch (NSException *exception) {
                    NSLog(@"Got a %@ exception", [exception class]);
                }
            });
        } else {
            [super pushNavigationItem:item animated:TRUE];
        }
    } else {
        [super pushNavigationItem:item animated:FALSE];
    }
}

- (void)pushNavigationItem:(UINavigationItem*)item {
    [super pushNavigationItem:item];
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated {
    [super setItems:items animated:animated];
}

@end
