//
//  XGSTextViewController.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGSMarkdownDefinition;

@interface XGSTextViewController : UIViewController

@property (strong, nonatomic, readonly) XGSMarkdownDefinition *markupProcessor;

- (id)initWithMarkupProcessor:(XGSMarkdownDefinition *)markupProcessor;
@end
