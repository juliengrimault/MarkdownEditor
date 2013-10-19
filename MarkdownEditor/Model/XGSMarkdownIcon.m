//
//  XGSMarkdownIcon.m
//  MarkdownEditor
//
//  Created by Julien Grimault on 20/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownIcon.h"

FAIcon iconForMarkdownTag(XGSMarkdownTagType type)
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
            return FAIconRocket;//something went wrong!
            break;
    }
}