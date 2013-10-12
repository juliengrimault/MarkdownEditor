//
//  XGSTextViewController.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGSMarkupDefinition;

@interface XGSTextViewController : UIViewController

@property (strong, nonatomic) XGSMarkupDefinition *markupProcessor;

- (id)initWithMarkupProcessor:(XGSMarkupDefinition *)markupProcessor;
@end
