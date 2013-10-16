//
//  XGSMarkdownElement.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 13/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownTag.h"


@implementation XGSMarkdownTag

- (instancetype)initWithName:(NSString *)name
             partialPatterns:(NSArray *)patterns
                       regex:(NSString *)regexPattern
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _partialPatterns = [patterns copy];
        _regex = [regexPattern copy];
    }
    return self;
}

- (NSString *)pattern
{
    return [self.partialPatterns componentsJoinedByString:@""];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[XGSMarkdownTag class]]) return NO;
    
    return [self isEqualToMarkdownTag:(XGSMarkdownTag *)object];
}

- (BOOL)isEqualToMarkdownTag:(XGSMarkdownTag *)tag
{
    return [_partialPatterns isEqualToArray:tag.partialPatterns] && [_regex isEqualToString:tag.regex];
}

- (NSUInteger)hash
{
    return [_partialPatterns hash] + 7 * [_regex hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end

NSString* MarkdownRegexItalic = @"\\*([^\\s].*?)\\*";
NSString* MarkdownNameItalic = @"Italic";

NSString* MarkdownRegexBold = @"\\*\\*([^\\s].*?)\\*\\*";
NSString* MarkdownNameBold = @"Bold";

NSString* MarkdownRegexUnderlined = @"_([^\\s].*?)_";
NSString* MarkdownNameUnderlined = @"Underlined";

NSString* MarkdownRegexLink = @"\\[([^\\]]+)\\]\\(([^\\)]+)\\)";
NSString* MarkdownNameLink = @"Link";

static NSMutableDictionary *_tags;

@implementation XGSMarkdownTag(Factory)

+ (void)load
{
    _tags = [NSMutableDictionary new];
}

+ (instancetype)lazyLoad:(NSString *)name builderBlock:(XGSMarkdownTag *(^)(void))builderBlock
{
    XGSMarkdownTag *tag = _tags[name];
    if (tag == nil) {
        tag = builderBlock();
        _tags[name] = tag;
    }
    return tag;
}

+(instancetype)italic
{
    return [self lazyLoad:MarkdownNameItalic
             builderBlock:^{
                 return [[self alloc] initWithName:NSLocalizedString(MarkdownNameItalic, nil)
                                   partialPatterns:@[@"*", @"*"]
                                             regex:MarkdownRegexItalic];
             }];
}

+(instancetype)bold
{
    return [self lazyLoad:MarkdownNameBold
             builderBlock:^{
                 return [[self alloc] initWithName:NSLocalizedString(MarkdownNameBold, nil)
                                   partialPatterns:@[@"**", @"**"]
                                             regex:MarkdownRegexBold];
             }];
}

+(instancetype)underlined
{
    return [self lazyLoad:MarkdownNameUnderlined
             builderBlock:^{
                 return  [[self alloc] initWithName:NSLocalizedString(MarkdownNameUnderlined, nil)
                                    partialPatterns:@[@"_", @"_"]
                                              regex:MarkdownRegexUnderlined];
             }];
}

+(instancetype)link
{
    return [self lazyLoad:MarkdownNameLink
             builderBlock:^{
                 return [[self alloc] initWithName:NSLocalizedString(MarkdownNameLink, nil)
                                   partialPatterns:@[@"[", @"](", @")"]
                                             regex:MarkdownRegexLink];
             }];
}
@end
