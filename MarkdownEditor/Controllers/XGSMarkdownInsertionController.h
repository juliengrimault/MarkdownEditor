//
//  XGSMarkdownInsertionController.h
//  MarkdownEditor
//
//  Created by Julien Grimault on 20/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGSMarkdownInputAccessoryView.h"

@interface XGSMarkdownInsertionController : NSObject <XGSMarkdownInputViewDelegate>


- (id)initWithTextStorage:(NSTextStorage *)textStorage textView:(UITextView *)textView;

- (void)insertMarkdownTag:(XGSMarkdownTag *)tag;
@end
