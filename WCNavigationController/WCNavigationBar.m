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
- (UINavigationItem*)popNavigationItem;
@end

@implementation WCNavigationBar

- (UINavigationItem *)popNavigationItem {
    if (self.popAnimationBlock) {
        UINavigationItem* destinationItem = [self.items objectAtIndex:self.items.count - 2];
        self.popAnimationBlock(self.topItem, destinationItem, ^(BOOL finished){
            [super popNavigationItem];
        });
        return destinationItem;
    } else {
        return [super popNavigationItem];
    }
}

- (void)pushNavigationItem:(UINavigationItem*)item {
    if (self.pushAnimationBlock) {
        self.pushAnimationBlock(self.topItem, item, ^(BOOL finished){
            [super pushNavigationItem:item];
        });
    } else {
        [super pushNavigationItem:item];
    }
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated {
    [super setItems:items animated:animated];
}

@end
