//
//  NSDictionary+XGSMerge.m
//  MarkdownEditor
//
//  Created by Julien Grimault on 16/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "NSDictionary+XGSMerge.h"

@implementation NSDictionary (XGSMerge)

- (NSDictionary *)xgs_merge:(NSDictionary *)otherDict
{
    NSMutableDictionary *result = [self mutableCopy];
    [otherDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        result[key] = obj;
    }];
    return [result copy];
}

@end
