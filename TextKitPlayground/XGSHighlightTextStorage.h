//
//  XGSHighlightTextStorage.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGSHighlightTextStorage : NSTextStorage

- (id)initWithTagStyles:(NSDictionary *)tagStyles normalFont:(UIFont *)normalFont;

@end
