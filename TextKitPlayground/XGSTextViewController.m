//
//  XGSTextViewController.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSTextViewController.h"

@interface XGSTextViewController ()

@end

@implementation XGSTextViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor purpleColor];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];

    UITextView *textView = [UITextView new];
    [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    textView.backgroundColor = [self.view backgroundColor];
    self.textView = textView;
    
    [self.view addSubview:self.textView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id topGuide = self.topLayoutGuide;
    id textView = self.textView;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(textView, topGuide);
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topGuide]-0-[textView]"
                                             options: 0
                                             metrics: nil
                                               views: viewsDictionary]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[textView]-0-|"
                                             options: 0
                                             metrics: nil
                                               views: viewsDictionary]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat: @"V:[textView]-0-|"
                                             options: 0
                                             metrics: nil
                                               views: viewsDictionary]];
    
    self.textView.text = @"hello world";
}


@end
