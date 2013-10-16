//
//  XGSMarkdownTagTrait.h
//  MarkdownEditor
//
//  Created by Julien Grimault on 16/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGSMarkdownTag.h"

@interface XGSMarkdownTagTrait : XGSMarkdownTag

@property (nonatomic, readonly) UIFont *baseFont;
@property (nonatomic, readonly) UIFontDescriptorSymbolicTraits trait;

- (instancetype)initWithName:(NSString *)name
             partialPatterns:(NSArray *)patterns
                       regex:(NSString *)regexPattern
                    baseFont:(UIFont *)font
                       trait:(UIFontDescriptorSymbolicTraits)trait;

- (instancetype)initWithName:(NSString *)name
             partialPatterns:(NSArray *)patterns
                       regex:(NSString *)regexPattern
                    baseFont:(UIFont *)font
                       trait:(UIFontDescriptorSymbolicTraits)trait
             extraAttributes:(NSDictionary *)extraAttributes;
@end
