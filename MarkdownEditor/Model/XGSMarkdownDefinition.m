//
//  XGSMarkupDefinition.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownDefinition.h"
#import "XGSMarkdownTag.h"
#import "XGSMarkdownTagBuilder.h"
#import "UIColor+AppColor.h"
#import "XGSShortcut.h"

@implementation XGSMarkdownDefinition

+ (instancetype)defaultInstance
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self computeTags];
        [self computeAdditionalShortcuts];
    }
    return self;
}

- (UIFont *)normalFont
{
    if(!_normalFont) {
        UIFontDescriptor *fd = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
        _normalFont = [UIFont fontWithDescriptor:fd size:fd.pointSize];
    }
    return _normalFont;
}

- (void)computeTags
{
    XGSMarkdownTagBuilder *builder = [[XGSMarkdownTagBuilder alloc] initWithBaseFont:self.normalFont];
    _markdownTags = @[[builder mardownTagWithType:XGSMarkdownTagItalic],
                      [builder mardownTagWithType:XGSMarkdownTagBold],
                      [builder mardownTagWithType:XGSMarkdownTagUnderlined],
                      [builder mardownTagWithType:XGSMarkdownTagHighlighted
                                       attributes:@{NSBackgroundColorAttributeName : [UIColor xgs_highlightColor]}]];
}

- (void)computeAdditionalShortcuts
{
    _additionalShortcuts = @[
                             @"#", [[XGSShortcut alloc] initWithString:@"*" icon:FAIconAsterisk]
                             ];
}

@end

