//
//  XGSMarkupDefinition.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGSMarkdownDefinition : NSObject

// the markdown tags that are recognized
@property (nonatomic, strong, readonly) NSArray *markdownTags;

//additional shortcuts to display on top of the markdown tags
// default to @[@"#", @"*"]
@property (nonatomic, strong, readonly) NSArray *additionalShortcuts;

// default is based on the user preference
@property (nonatomic, strong) UIFont *normalFont;

+(instancetype)defaultInstance;


@end
