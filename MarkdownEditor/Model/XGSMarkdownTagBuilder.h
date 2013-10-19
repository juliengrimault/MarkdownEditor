//
//  XGSMarkdownTagBuilder.h
//  MarkdownEditor
//
//  Created by Julien Grimault on 16/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGSMarkdownTagType.h"
#import "XGSMarkdownTag.h"


@interface XGSMarkdownTagBuilder : NSObject

@property (strong, nonatomic) UIFont *baseFont;

- (instancetype)initWithBaseFont:(UIFont *)font;

- (XGSMarkdownTag *)mardownTagWithType:(XGSMarkdownTagType)type;

- (XGSMarkdownTag *)mardownTagWithType:(XGSMarkdownTagType)type attributes:(NSDictionary *)attributes;
@end

