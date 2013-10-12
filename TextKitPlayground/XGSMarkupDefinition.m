//
//  XGSMarkupDefinition.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkupDefinition.h"

NSString* THMarkdownURegexItalic = @"\\*(.+?)\\*"; /* "*xxx*" = xxx in italics */
NSString* THMarkdownURegexBold = @"\\*\\*(.+?)\\*\\*"; /* "**xxx**" = xxx in bold */


@interface XGSMarkupDefinition()

@property (nonatomic, strong) UIFont *italicFont;
@property (nonatomic, strong) UIFont *boldFont;
@end

@implementation XGSMarkupDefinition


+(instancetype)sharedInstance
{
    static XGSMarkupDefinition *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[XGSMarkupDefinition alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self computeFonts];
        [self computeTags];
    }
    return self;
}

- (void)setNormalFont:(UIFont *)normalFont
{
    if (_normalFont == normalFont) return;
    
    _normalFont = normalFont;
    [self computeFonts];
    [self computeTags];
}

- (void)computeFonts
{
    // get the body font descriptor + the size
    UIFontDescriptor *bodyFontDescriptor = [UIFontDescriptor
                                        preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    NSNumber *bodyFontSize = bodyFontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    
    //get the normal font
    _normalFont = [UIFont fontWithDescriptor:bodyFontDescriptor size:[bodyFontSize floatValue]];
    
    // derive the bold font
    UIFontDescriptor *boldFontDescriptor = [bodyFontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    _boldFont = [UIFont fontWithDescriptor:boldFontDescriptor size:0.0];
    
    //derive the italic font
    UIFontDescriptor *italicFontDescriptor = [bodyFontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    _italicFont = [UIFont fontWithDescriptor:italicFontDescriptor size:0.0];
}

- (void)computeTags
{
    _tagStyles =  @{ THMarkdownURegexItalic : @{NSFontAttributeName : _italicFont},
                     THMarkdownURegexBold : @{NSFontAttributeName : _boldFont} };
    
    _tagProcessingBlocks = @{
       THMarkdownURegexBold : [self tagProcessorForAttribute:@{NSFontAttributeName : _boldFont}],
       THMarkdownURegexItalic : [self tagProcessorForAttribute:@{NSFontAttributeName : _italicFont}],
    };
}

- (TagProcessorBlockType)tagProcessorForAttribute:(NSDictionary *)attributes
{
    return ^NSAttributedString*(NSAttributedString* str, NSTextCheckingResult* match)
    {
        NSRange textRange = [match rangeAtIndex:1];
        if (textRange.length>0)
        {
            NSMutableAttributedString* foundString = [[str attributedSubstringFromRange:textRange] mutableCopy];
            [foundString setAttributes:attributes range:NSMakeRange(0,textRange.length)];
            return foundString;
        } else {
            return nil;
        }
    };
}


@end
