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

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor redColor];

    [self setupTextView];
    [self.view addSubview:self.textView];
    
    [self setupNavigationBarButton];
}

    - (void)setupTextView
    {
        XGSMarkupDefinition *markupDef = [XGSMarkupDefinition sharedInstance];
        self.textStorage = [[XGSHighlightTextStorage alloc] initWithTagStyles:markupDef.tagStyles normalFont:markupDef.normalFont];
        
        NSLayoutManager *layoutManager = [NSLayoutManager new];
        [self.textStorage addLayoutManager: layoutManager];
        
        NSTextContainer *textContainer = [NSTextContainer new];
        [layoutManager addTextContainer: textContainer];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:textContainer];
        [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
        textView.backgroundColor = [UIColor purpleColor];
        self.textView = textView;
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
            XGSPreviewViewController *previewVC = [[XGSPreviewViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:previewVC];
            [self presentViewController:nav animated:YES completion:nil];
        }

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupConstraints];
    self.textView.text = NSLocalizedString(@"type something here",nil);
    [self startObservingKeyboardNotifications];
}

    - (void)setupConstraints
    {
        id topGuide = self.topLayoutGuide;
        id editView = self.textView;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(editView, topGuide);
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-[editView]-|"
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
