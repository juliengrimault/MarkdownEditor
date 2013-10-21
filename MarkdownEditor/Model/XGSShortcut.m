//
//  XGSShortcut.m
//  MarkdownEditor
//
//  Created by Julien Grimault on 21/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSShortcut.h"
#import "UIFont+FontAwesome.h"

@implementation XGSShortcut

- (id)initWithString:(NSString *)insertString icon:(FAIcon)icon
{
    self = [super init];
    if (self) {
        _insertString = [insertString copy];
        _icon = icon;
    }
    return self;
}

- (NSString *)displayString
{
    return [NSString fontAwesomeIconStringForEnum:self.icon];
}

- (UIFont *)displayFont
{
    return [UIFont fontAwesomeFontOfSize:15.0f];
}

@end
