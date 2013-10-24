//
//  WCLabel.h
//  WillCall
//
//  Created by Patrick Tescher on 5/7/13.
//  Copyright (c) 2013 WillCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCLabel : UILabel

@property (strong, nonatomic) NSString *kerning;

- (NSAttributedString*)applyKerningToText:(NSString*)text;

@end
