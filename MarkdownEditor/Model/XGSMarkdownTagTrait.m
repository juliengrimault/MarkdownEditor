//
//  XGSMarkdownTagTrait.m
//  MarkdownEditor
//
//  Created by Julien Grimault on 16/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownTagTrait.h"
#import "XGSMarkdownTag_Private.h"

@implementation XGSMarkdownTagTrait {
    NSDictionary *_attributes;
}

- (instancetype)initWithName:(NSString *)name
             partialPatterns:(NSArray *)patterns
                       regex:(NSString *)regexPattern
                    baseFont:(UIFont *)font
                       trait:(UIFontDescriptorSymbolicTraits)trait
{
    return [self initWithName:name partialPatterns:patterns regex:regexPattern baseFont:font trait:trait extraAttributes:nil];
}

- (instancetype)initWithName:(NSString *)name
             partialPatterns:(NSArray *)patterns
                       regex:(NSString *)regexPattern
                    baseFont:(UIFont *)font
                       trait:(UIFontDescriptorSymbolicTraits)trait
             extraAttributes:(NSDictionary *)extraAttributes
{
    self = [super initWithName:name partialPatterns:patterns regex:regexPattern attributes:extraAttributes];
    if (self) {
        _baseFont = font;
        _trait = trait;
    }
    return self;
}

- (NSDictionary *)attributes
{
    if (_attributes == nil) {
        [self computeAttributes];
    }
    return _attributes;
}

    - (void)computeAttributes
    {
        NSDictionary *fontAttributes = [self computeFontAttributes];
        _attributes = [[self mergeAttributes:fontAttributes] copy];
    }

        -(NSDictionary *)computeFontAttributes
        {
            UIFontDescriptor *normalFontDescriptor = [self.baseFont fontDescriptor];
            // derive the bold font
            UIFontDescriptor *fd = [normalFontDescriptor fontDescriptorWithSymbolicTraits:self.trait];
            UIFont *f = [UIFont fontWithDescriptor:fd size:0.0];
            return @{ NSFontAttributeName : f };
        }

        - (NSDictionary *)mergeAttributes:(NSDictionary *)attr
        {
            NSMutableDictionary *result = [attr mutableCopy];
            [self.extraAttributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                result[key] = obj;
            }];
            return result;
        }

@end
