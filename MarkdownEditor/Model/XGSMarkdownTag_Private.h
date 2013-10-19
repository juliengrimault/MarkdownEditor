//
//  XGSMarkdownTag_Private.h
//  MarkdownEditor
//
//  Created by Julien Grimault on 16/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownTag.h"

@interface XGSMarkdownTag ()

@property (strong, nonatomic, readonly) NSDictionary *extraAttributes;

- (instancetype)initWithType:(XGSMarkdownTagType)type
                        name:(NSString *)name
             partialPatterns:(NSArray *)patterns
                       regex:(NSString *)regexPattern
                  attributes:(NSDictionary *)attributes;
@end
