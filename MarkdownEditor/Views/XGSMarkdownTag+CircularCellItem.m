//
//  XGSMarkdownTag+CircularCellItem.m
//  MarkdownEditor
//
//  Created by Julien Grimault on 20/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownTag+CircularCellItem.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"
#import "XGSMarkdownTag.h"

@implementation XGSMarkdownTag(XGSCircularCellItem)

- (UIFont *)displayFont
{
    return [UIFont fontAwesomeFontOfSize:15.0];
}

- (NSString *)displayString
{
    FAIcon icon = [self iconForTagType:self.type];
    return [NSString fontAwesomeIconStringForEnum:icon];
}

    - (FAIcon)iconForTagType:(XGSMarkdownTagType)type
    {
        switch(type)
        {
            case XGSMarkdownTagBold:
                return FAIconBold;
                
            case XGSMarkdownTagItalic:
                return FAIconItalic;
                
            case XGSMarkdownTagUnderlined:
                return FAIconUnderline;
                
            case XGSMarkdownTagHighlighted:
                return FAIconPencil;
                
            default:
                return 0;//something went wrong!
                break;
        }
        return 0;
    }

@end


@implementation NSString(XGSCircularCellItem)

- (NSString *)displayString
{
    return self;
}

@end