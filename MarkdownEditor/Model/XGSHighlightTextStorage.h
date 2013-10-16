//
//  XGSHighlightTextStorage.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderedDictionary;
@interface XGSHighlightTextStorage : NSTextStorage

@property (strong, nonatomic) UIColor *textColor;

- (id)initWithTagStyles:(OrderedDictionary *)tagStyles normalFont:(UIFont *)normalFont;

@end
