//
//  WCLabel.m
//  WillCall
//
//  Created by Patrick Tescher on 5/7/13.
//  Copyright (c) 2013 WillCall. All rights reserved.
//

#import "WCLabel.h"

@implementation WCLabel

- (void)applyKerningToExistingText {
    if ([self respondsToSelector:@selector(setAttributedText:)]) {
        NSAttributedString *string = [self applyKerningToText:self.text];
        [self setAttributedText:string];
    }
}

- (NSAttributedString*)applyKerningToText:(NSString*)text {
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{
                                                        NSKernAttributeName: @(self.kerning.floatValue)
                                  }];
    return string;
}

- (void)setText:(NSString *)text {
    if ([self respondsToSelector:@selector(setAttributedText:)]) {
        NSAttributedString *string = [self applyKerningToText:text];
        [self setAttributedText:string];
    } else {
        [super setText:text];
    }
}

- (void)setKerning:(NSString *)kerning {
    _kerning = kerning;
    [self applyKerningToExistingText];
}

@end
