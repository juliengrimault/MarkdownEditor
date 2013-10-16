//
//  XGSMarkdownElement.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 13/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownTag.h"
#import "XGSMarkdownTag_Private.h"

#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))

@implementation XGSMarkdownTag

- (instancetype)initWithName:(NSString *)name
             partialPatterns:(NSArray *)patterns
                       regex:(NSString *)regexPattern
                  attributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _partialPatterns = [patterns copy];
        _regex = [regexPattern copy];
        _extraAttributes = [attributes copy];
    }
    return self;
}

- (NSString *)pattern
{
    return [self.partialPatterns componentsJoinedByString:@""];
}

- (BOOL)isEqual:(id)object
{
    if (object == self) return YES;
    
    if (!object || ![object isKindOfClass:[XGSMarkdownTag class]]) return NO;
    
    return [self isEqualToMarkdownTag:(XGSMarkdownTag *)object];
}

- (BOOL)isEqualToMarkdownTag:(XGSMarkdownTag *)tag
{
    if (tag == self) return YES;
    
    return [_name isEqualToString:tag.name] &&
           [_partialPatterns isEqualToArray:tag.partialPatterns] &&
           [_regex isEqualToString:tag.regex] &&
           [self.attributes isEqualToDictionary:tag.attributes];
}

- (NSUInteger)hash
{
    return NSUINTROTATE([_partialPatterns hash], NSUINT_BIT / 2) ^
    NSUINTROTATE([_regex hash], NSUINT_BIT / 4) ^
    NSUINTROTATE([_name hash], NSUINT_BIT / 8) ^
    NSUINTROTATE([self.attributes hash], NSUINT_BIT / 16);
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (NSDictionary *)attributes
{
    return _extraAttributes;
}

@end
