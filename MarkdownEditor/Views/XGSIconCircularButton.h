//
//  XGSMarkdownButton.h
//  MarkdownEditor
//
//  Created by Julien Grimault on 19/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"

@interface XGSIconCircularButton : UIButton
+ (instancetype)buttonWithTitle:(NSString *)title;
@end

@interface XGSIconCircularButton(FAIcon)
+ (instancetype)buttonWithIcon:(FAIcon)icon;
@end

