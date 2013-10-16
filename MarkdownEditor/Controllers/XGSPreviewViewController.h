//
//  XGSPreviewViewController.h
//  TextKitPlayground
//
//  Created by Julien Grimault on 12/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGSPreviewViewController : UIViewController


@property (strong, nonatomic) NSAttributedString *text;

- (instancetype)initWithText:(NSAttributedString *)text;
@end
