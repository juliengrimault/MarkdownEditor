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
    XGSMarkdownTag *element = [[XGSMarkdownTag allocWithZone:zone] initWithName:self.name
                                                                partialPatterns:self.partialPatterns
                                                                          regex:self.regex];
    return element;
}

@end

NSString* MarkdownRegexItalic = @"\\*([^\\s].*?)\\*";
NSString* MarkdownRegexBold = @"\\*\\*([^\\s].*?)\\*\\*";
NSString* MarkdownRegexUnderlined = @"_([^\\s].*?)_";
NSString* MarkdownRegexLink = @"\\[([^\\]]+)\\]\\(([^\\)]+)\\)";

@implementation XGSMarkdownTag(Factory)
+(instancetype)italic
{
    return [[self alloc] initWithName:NSLocalizedString(@"Italic", nil)
                      partialPatterns:@[@"*", @"*"]
                                regex:MarkdownRegexItalic];
}

+(instancetype)bold
{
    return [[self alloc] initWithName:NSLocalizedString(@"Bold", nil)
                      partialPatterns:@[@"**", @"**"]
                                regex:MarkdownRegexBold];
}

+(instancetype)underlined
{
    return [[self alloc] initWithName:NSLocalizedString(@"Underlined", nil)
                      partialPatterns:@[@"_", @"_"]
                                regex:MarkdownRegexUnderlined];
}

+(instancetype)link
{
    return [[self alloc] initWithName:NSLocalizedString(@"Link", nil)
                      partialPatterns:@[@"[", @"](", @")"]
                                regex:MarkdownRegexLink];
}
@end
