//
//  XGSTextViewController.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSTextViewController.h"
#import "XGSHighlightTextStorage.h"
#import "XGSMarkupDefinition.h"
#import "XGSPreviewViewController.h"

@interface XGSTextViewController ()
@property (weak, nonatomic) UITextView *textView;
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutConstraint *keyboardHeight;
@end

@implementation XGSTextViewController

- (id)initWithMarkupProcessor:(XGSMarkupDefinition *)markupProcessor
{
    self = [super init];
    if (self) {
        _markupProcessor = markupProcessor;
        self.title = NSLocalizedString(@"Edit", nil);
    }
    return self;
}

- (void)loadView
{
    self.view = [UIView new];

    [self setupTextView];
    [self setupNavigationBarButton];
}

    - (void)setupTextView
    {
        self.textStorage = [[XGSHighlightTextStorage alloc] initWithTagStyles:self.markupProcessor.tagStyles normalFont:self.markupProcessor.normalFont];
        
        NSLayoutManager *layoutManager = [NSLayoutManager new];
        [self.textStorage addLayoutManager: layoutManager];
        
        NSTextContainer *textContainer = [NSTextContainer new];
        [layoutManager addTextContainer: textContainer];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:textContainer];
        [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.textView = textView;
        [self.view addSubview:self.textView];
    }

    - (void)setupNavigationBarButton
    {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Render", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(renderPreview:)];
        self.navigationItem.rightBarButtonItem = button;
    }

        - (void)renderPreview:(id)sender
        {
            NSAttributedString *parsedText = [self.markupProcessor parseAttributedString:self.textStorage];
            XGSPreviewViewController *previewVC = [[XGSPreviewViewController alloc] initWithText:parsedText];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:previewVC];
            [self presentViewController:nav animated:YES completion:nil];
        }

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupConstraints];
    self.textView.text = NSLocalizedString(@"This is a demo of what you can do:\n1 * on each side of a word will make it *italic*.\n2 * on each side will make it **bold**.\n\nPretty cool no?",nil);
    [self startObservingKeyboardNotifications];
}

    - (void)setupConstraints
    {
        id editView = self.textView;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(editView);
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[editView]|"
                                                 options: 0
                                                 metrics: nil
                                                   views: viewsDictionary]];
        
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[editView]"
                                                 options: 0
                                                 metrics: nil
                                                   views: viewsDictionary]];
        
        self.keyboardHeight = [NSLayoutConstraint constraintWithItem:editView
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0f
                                                            constant:0];
        [self.view addConstraint:self.keyboardHeight];
    }

#pragma mark - Keyboard Notifications
- (void)startObservingKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

    - (void)keyboardWillShow:(NSNotification *)notification
    {
        NSDictionary *info = [notification userInfo];
        NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect keyboardFrame = [kbFrame CGRectValue];
        
        BOOL isPortrait = UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
        CGFloat height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;
        
        self.keyboardHeight.constant = -height;
        
        [UIView animateWithDuration:animationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }

    - (void)keyboardWillHide:(NSNotification *)notification
    {
        NSDictionary *info = [notification userInfo];
        NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        self.keyboardHeight.constant = 0;
        [UIView animateWithDuration:animationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }

- (void)dealloc
{
    [self stopObservingKeyboardNotifications];
}

    - (void)stopObservingKeyboardNotifications
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }

@end
