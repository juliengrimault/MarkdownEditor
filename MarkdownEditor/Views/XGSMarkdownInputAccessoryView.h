//
//  XGSMarkdownInputView.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 12/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XGSMarkdownTag;
@class XGSMarkdownInputAccessoryView;
@class XGSIconCircularButton;

@protocol XGSMarkdownInputViewDelegate
- (void)markdownInputViewDidDismiss:(XGSMarkdownInputAccessoryView *)inputView;
- (void)markdownInputView:(XGSMarkdownInputAccessoryView *)inputView didSelectMarkdownElement:(XGSMarkdownTag *)element;
- (void)markdownInputView:(XGSMarkdownInputAccessoryView *)inputView didSelectString:(NSString *)element;
@end

@interface XGSMarkdownInputAccessoryView : UIView

@property (weak, nonatomic) id<XGSMarkdownInputViewDelegate> delegate;

// shortcut buttons, either XGSMarkdownTag instances or NSString *
@property (nonatomic) NSArray *shortcuts;

@end



