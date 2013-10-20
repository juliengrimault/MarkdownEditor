//
//  XGSTextViewController.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGSMarkdownDefinition;
@class XGSMarkdownInsertionController;
@interface XGSTextViewController : UIViewController

@property (strong, nonatomic, readonly) XGSMarkdownDefinition *markupProcessor;
@property (strong, nonatomic) XGSMarkdownInsertionController *markdownInsertionController;

- (id)initWithMarkupProcessor:(XGSMarkdownDefinition *)markupProcessor;
@end
