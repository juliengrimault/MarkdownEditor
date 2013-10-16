//
//  XGSMarkdownElement.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 13/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This is the base class providing common data for all MarkdownTag implementation.
 Subclass can add extra property and should override `attributes` to suit their needs.
 */
@interface XGSMarkdownTag : NSObject<NSCopying>

@property (nonatomic, readonly, copy) NSString *name;

//the pattern of the tag-  all the partial patterns put together
@property (nonatomic, readonly) NSString *pattern;

//array of NSNumber indicating where the text should be inserted in the pattern
@property (nonatomic, readonly, copy) NSArray *partialPatterns;

/// the regex used to match this markdown element
@property (nonatomic, readonly, copy) NSString *regex;

// /!\ abstract property, subclass must implement this
@property (nonatomic, readonly) NSDictionary *attributes;


@end
