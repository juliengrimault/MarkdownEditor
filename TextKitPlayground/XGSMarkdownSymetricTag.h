//
//  XGSMarkdownElement.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 13/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGSMarkdownSymetricTag : NSObject<NSCopying>

/// the pattern delimiting the tag on the left and right.
@property (nonatomic, readonly, copy) NSString *pattern;

/// the regex used to match this markdown element
@property (nonatomic, readonly, copy) NSString *regexPattern;

- (BOOL)isEqualToMarkdownTag:(XGSMarkdownSymetricTag *)tag;
@end



@interface XGSMarkdownSymetricTag(Factory)

+(instancetype)italic;
+(instancetype)bold;

@end
