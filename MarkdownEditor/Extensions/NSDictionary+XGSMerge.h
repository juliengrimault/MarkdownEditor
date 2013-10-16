//
//  NSDictionary+XGSMerge.h
//  MarkdownEditor
//
//  Created by Julien Grimault on 16/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XGSMerge)

- (NSDictionary *)xgs_merge:(NSDictionary *)otherDict;

@end
