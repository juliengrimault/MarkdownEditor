//
//  XGSMarkupDefinition.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSAttributedString*(^TagProcessorBlockType)(NSAttributedString*, NSTextCheckingResult*);

@interface XGSMarkupDefinition : NSObject

+(instancetype)sharedInstance;

// keys are the regex for the tags and values are the NSAttributed string style
@property (nonatomic, strong, readonly) NSDictionary *tagStyles;

// keys are regex for the tags and values are
@property (nonatomic, strong, readonly) NSDictionary *tagProcessingBlocks;

@property (nonatomic, strong) UIFont *normalFont;

@end
