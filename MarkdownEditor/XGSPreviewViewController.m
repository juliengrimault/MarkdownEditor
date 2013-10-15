//
//  XGSPreviewViewController.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 12/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSPreviewViewController.h"

@interface XGSPreviewViewController ()
@property (weak, nonatomic) UITextView *textView;
@end

@implementation XGSPreviewViewController

- (instancetype)initWithText:(NSAttributedString *)text
{
    self = [super init];
    if (self) {
        _text = [text copy];
        self.title = NSLocalizedString(@"Preview", nil);
    }
    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor blueColor];
    [self setupNavigationBarButton];
    [self setupTextView];
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

    - (void)setupTextView
    {
        UITextView *textView = [UITextView new];
        [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
        textView.editable = NO;
        self.textView = textView;
        [self.view addSubview:textView];
    }

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupConstraints];
    self.textView.attributedText = self.text;
}
    - (void)setupConstraints
    {
        id textView = self.textView;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(textView);
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[textView]|"
                                                 options: 0
                                                 metrics: nil
                                                   views: viewsDictionary]];
        
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[textView]|"
                                                 options: 0
                                                 metrics: nil
                                                   views: viewsDictionary]];
    }


#pragma mark - Properties
- (void)setText:(NSAttributedString *)text
{
    if (_text == text) return;
    _text = [text copy];
    self.textView.attributedText = _text;
}

@end
