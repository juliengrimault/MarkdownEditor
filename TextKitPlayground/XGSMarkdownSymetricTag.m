//
//  XGSMarkdownElement.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 13/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownSymetricTag.h"


@implementation XGSMarkdownSymetricTag

- (instancetype)initWithName:(NSString *)name pattern:(NSString *)pattern regexPattern:(NSString *)regexPattern
{
    self = [super init];
    if (self) {
        _name = [name copy];
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
    XGSMarkdownSymetricTag *element = [[XGSMarkdownSymetricTag allocWithZone:zone] initWithName:self.name
                                                                                        pattern:self.pattern
                                                                                   regexPattern:self.regexPattern];
    return element;
}

@end

NSString* MarkdownRegexItalic = @"\\*([^\\s].*?)\\*"; /* "*xxx*" = xxx in italics */
NSString* MarkdownRegexBold = @"\\*\\*([^\\s].*?)\\*\\*"; /* "**xxx**" = xxx in bold */

@implementation XGSMarkdownSymetricTag(Factory)
+(instancetype)italic
{
    return [[self alloc] initWithName:NSLocalizedString(@"Italic", nil) pattern:@"*" regexPattern:MarkdownRegexItalic];
}

+(instancetype)bold
{
    return [[self alloc] initWithName:NSLocalizedString(@"Bold", nil) pattern:@"**" regexPattern:MarkdownRegexBold];
}
@end
