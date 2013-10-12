//
//  XGSPreviewViewController.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 12/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSPreviewViewController.h"

@interface XGSPreviewViewController ()

@end

@implementation XGSPreviewViewController

- (void)loadView
{
    self.view = [UIView new];
    [self setupNavigationBarButton];
}

    - (void)setupNavigationBarButton
    {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(done:)];
        self.navigationItem.rightBarButtonItem = button;
    }

        - (void)done:(id)sender
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
