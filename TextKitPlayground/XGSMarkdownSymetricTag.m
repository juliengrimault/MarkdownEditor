//
//  XGSMarkdownElement.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 13/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownSymetricTag.h"

@interface XGSMarkdownSymetricTag()
// private constructor, clients should use the class method provided
- (instancetype)initWithPattern:(NSString *)pattern regexPattern:(NSString *)regexPattern;
@end

@implementation XGSMarkdownSymetricTag

- (instancetype)initWithPattern:(NSString *)pattern regexPattern:(NSString *)regexPattern
{
    self = [super init];
    if (self) {
        _pattern = [pattern copy];
        _regexPattern = [regexPattern copy];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[XGSMarkdownSymetricTag class]]) return NO;
    
    return [self isEqualToMarkdownTag:(XGSMarkdownSymetricTag *)object];
}

- (BOOL)isEqualToMarkdownTag:(XGSMarkdownSymetricTag *)tag
{
    return [_pattern isEqualToString:tag.pattern] && [_regexPattern isEqualToString:tag.regexPattern];
}

- (NSUInteger)hash
{
    return [_pattern hash] + 7 * [_regexPattern hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    XGSMarkdownSymetricTag *element = [[XGSMarkdownSymetricTag allocWithZone:zone] initWithPattern:self.pattern regexPattern:self.regexPattern];
    return element;
}

@end

NSString* MarkdownRegexItalic = @"\\*([^\\s].*?)\\*"; /* "*xxx*" = xxx in italics */
NSString* MarkdownRegexBold = @"\\*\\*([^\\s].*?)\\*\\*"; /* "**xxx**" = xxx in bold */

@implementation XGSMarkdownSymetricTag(Factory)
+(instancetype)italic
{
    return [[self alloc] initWithPattern:@"*" regexPattern:MarkdownRegexItalic];
}

+(instancetype)bold
{
    return [[self alloc] initWithPattern:@"**" regexPattern:MarkdownRegexBold];
}
@end
