//
//  XGSMarkdownTagBuilder.m
//  MarkdownEditor
//
//  Created by Julien Grimault on 16/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownTagBuilder.h"
#import "XGSMarkdownTagTrait.h"
#import "UIColor+AppColor.h"
#import "NSDictionary+XGSMerge.h"
#import "XGSMarkdownTag_Private.h"

NSString* MarkdownRegexItalic = @"\\*([^\\s].*?)\\*";
NSString* MarkdownNameItalic = @"Italic";

NSString* MarkdownRegexBold = @"\\*\\*([^\\s].*?)\\*\\*";
NSString* MarkdownNameBold = @"Bold";

NSString* MarkdownRegexUnderlined = @"_([^\\s].*?)_";
NSString* MarkdownNameUnderlined = @"Underlined";

NSString* MarkdownRegexHighlighted = @"=([^\\s].*?)=";
NSString* MarkdownNameHighlighted = @"Highlight";

NSString* MarkdownRegexLink = @"\\[([^\\]]+)\\]\\(([^\\)]+)\\)";
NSString* MarkdownNameLink = @"Link";

@interface XGSMarkdownTagBuilder()
@property (copy, nonatomic) NSMutableDictionary *tags;
@end

@implementation XGSMarkdownTagBuilder

- (instancetype)initWithBaseFont:(UIFont *)font
{
    self = [super init];
    if (self) {
        _baseFont = font;
        _tags = [NSMutableDictionary new];
    }
    return self;
}

// TODO: make this thread safe

- (XGSMarkdownTag *)mardownTagWithType:(XGSMarkdownTagType)type
{
    return [self mardownTagWithType:type attributes:nil];
}

- (XGSMarkdownTag *)mardownTagWithType:(XGSMarkdownTagType)type attributes:(NSDictionary *)attributes
{
    switch (type) {
        case XGSMarkdownTagBold:
            return [self bold:attributes];
            
        case XGSMarkdownTagItalic:
            return [self italic:attributes];
            
        case XGSMarkdownTagUnderlined:
            return [self underlined:attributes];
            
        case XGSMarkdownTagHighlighted:
            return [self highlighted:attributes];
            
        default:
            break;
    }
    return nil;
}

-(XGSMarkdownTag *)italic:(NSDictionary *)extraAttributes
{
    return [self lazyLoad:XGSMarkdownTagItalic
             builderBlock:^{
                 return [[XGSMarkdownTagTrait alloc] initWithName:NSLocalizedString(MarkdownNameItalic, nil)
                                                  partialPatterns:@[@"*", @"*"]
                                                            regex:MarkdownRegexItalic
                                                         baseFont:self.baseFont
                                                            trait:UIFontDescriptorTraitItalic];
             }];
}

-(XGSMarkdownTag *)bold:(NSDictionary *)extraAttributes
{
    return [self lazyLoad:XGSMarkdownTagBold
             builderBlock:^{
                 return [[XGSMarkdownTagTrait alloc] initWithName:NSLocalizedString(MarkdownNameBold, nil)
                                                  partialPatterns:@[@"**", @"**"]
                                                            regex:MarkdownRegexBold
                                                         baseFont:self.baseFont
                                                            trait:UIFontDescriptorTraitBold];
             }];
}

-(XGSMarkdownTag *)underlined:(NSDictionary *)extraAttributes
{
    return [self lazyLoad:XGSMarkdownTagUnderlined
             builderBlock:^{
                 NSDictionary *attributes = [@{ NSUnderlineStyleAttributeName: @1 } xgs_merge:extraAttributes];
                 return  [[XGSMarkdownTag alloc] initWithName:NSLocalizedString(MarkdownNameUnderlined, nil)
                                              partialPatterns:@[@"_", @"_"]
                                                        regex:MarkdownRegexUnderlined
                                                   attributes:attributes];
             }];
}

-(XGSMarkdownTag *)highlighted:(NSDictionary *)extraAttributes
{
    return [self lazyLoad:XGSMarkdownTagHighlighted
             builderBlock:^{
                 NSDictionary *attributes =[@{ NSBackgroundColorAttributeName: [self highlightColor] } xgs_merge:extraAttributes];
                 return  [[XGSMarkdownTag alloc] initWithName:NSLocalizedString(MarkdownNameHighlighted, nil)
                                              partialPatterns:@[@"=", @"="]
                                                        regex:MarkdownRegexHighlighted
                                                   attributes:attributes];
             }];
}

- (UIColor *)highlightColor
{
    return [UIColor colorWithRed:0.95 green:0.77 blue:0.06 alpha:.25];
}

-(XGSMarkdownTag *)lazyLoad:(XGSMarkdownTagType)type builderBlock:(XGSMarkdownTag *(^)(void))builderBlock
{
    XGSMarkdownTag *tag = self.tags[@(type)];
    if (tag == nil) {
        tag = builderBlock();
        self.tags[@(type)] = tag;
    }
    return tag;
}

//-(XGSMarkdownTag *)link
//{
//    return [self lazyLoad:MarkdownNameLink
//             builderBlock:^{
//                 return [[self alloc] initWithName:NSLocalizedString(MarkdownNameLink, nil)
//                                   partialPatterns:@[@"[", @"](", @")"]
//                                             regex:MarkdownRegexLink];
//             }];
//}

@end
