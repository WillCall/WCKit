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
    NSString *newText = [NSString stringWithString:text];
    NSDictionary *newAttributes = @{
                                    NSFontAttributeName: self.font,
                                    NSKernAttributeName: @(self.kerning.floatValue ?: 0.0)
                                    };
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:newText attributes:newAttributes];
    return string;
}

- (void)setText:(NSString *)text {
    if (self.kerning && text && [self respondsToSelector:@selector(setAttributedText:)]) {
        NSAttributedString *string = [self applyKerningToText:text];
        [self setAttributedText:string];
    } else {
        [super setText:text];
    }
}

- (void)setKerning:(NSString *)kerning {
    _kerning = [kerning copy];
    [self applyKerningToExistingText];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize];
    }
    return self;
}

@end
