//
//  XGSShortcut.h
//  MarkdownEditor
//
//  Created by Julien Grimault on 21/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+FontAwesome.h"
#import "XGSMarkdownTag+CircularCellItem.h"

@interface XGSShortcut : NSObject <XGSCircularCellItem>

@property (nonatomic, readonly, copy) NSString *insertString;
@property (nonatomic, readonly) FAIcon icon;

- (id)initWithString:(NSString *)insertString icon:(FAIcon)icon;

@end
