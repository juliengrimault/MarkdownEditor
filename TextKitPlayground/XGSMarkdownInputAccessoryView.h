//
//  XGSMarkdownInputView.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 12/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XGSMarkdownInputAccessoryView;

@protocol XGSMarkdownInputViewDelegate
- (void)markdownInputViewDidDismiss:(XGSMarkdownInputAccessoryView *)inputView;
- (void)markdownInputView:(XGSMarkdownInputAccessoryView *)inputView didSelectPattern:(NSString *)pattern insertionIndex:(NSUInteger)insertionIndex;
@end

@interface XGSMarkdownInputAccessoryView : UIView

@property (weak, nonatomic) id<XGSMarkdownInputViewDelegate> delegate;

@end



