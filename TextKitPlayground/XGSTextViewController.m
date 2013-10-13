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
#import "XGSMarkdownInputAccessoryView.h"
#import "UIColor+AppColor.h"
#import "XGSMarkdownSymetricTag.h"
#import "PSMenuItem.h"

@interface XGSTextViewController ()<XGSMarkdownInputViewDelegate>
@property (weak, nonatomic) UITextView *textView;
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutConstraint *keyboardHeight;
@end

@implementation XGSTextViewController

+ (void)load {
    [PSMenuItem installMenuHandlerForObject:self];
}

+ (void)initialize {
    [PSMenuItem installMenuHandlerForObject:self];
}

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
    [self addCustomMenuItems];
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
        
        XGSMarkdownInputAccessoryView *inputAccessoryView = [[XGSMarkdownInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        inputAccessoryView.tintColor = [UIColor xgs_greenColor];
        inputAccessoryView.delegate = self;
        textView.inputAccessoryView = inputAccessoryView;
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

    - (void)addCustomMenuItems
    {
        NSMutableArray *items = [NSMutableArray new];
        for(XGSMarkdownSymetricTag *tag in self.markupProcessor.markdownTags) {
            [items addObject:[self menuItemForMarkdownTag:tag]];
        }
        [UIMenuController sharedMenuController].menuItems = items;
    }

        - (UIMenuItem *)menuItemForMarkdownTag:(XGSMarkdownSymetricTag *)tag
        {
            return [[PSMenuItem alloc] initWithTitle:tag.name block:^{
                [self insertMarkdownTag:tag];
            }];
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
        id inputAccessoryView = self.textView.inputAccessoryView;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(editView, inputAccessoryView);
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

#pragma mark - XGSMarkdownInputViewDelegate
- (void)markdownInputViewDidDismiss:(XGSMarkdownInputAccessoryView *)inputView
{
    [self.textView resignFirstResponder];
}

- (void)markdownInputView:(XGSMarkdownInputAccessoryView *)inputView didSelectMarkdownElement:(XGSMarkdownSymetricTag *)element
{
    [self insertMarkdownTag:element];
}

- (void)insertMarkdownTag:(XGSMarkdownSymetricTag *)tag
{
    NSRange selectedRange = self.textView.selectedRange;
    NSAttributedString *insertBefore = [[NSAttributedString alloc] initWithString:tag.pattern];
    NSAttributedString *insertAfter = [[NSAttributedString alloc] initWithString:tag.pattern];
    
    // the order in which we insert the 2 segments of the pattern is important - we must insert right part of the pattern first
    // in order to not shift the letters
    NSUInteger insertionEnd = NSMaxRange(self.textView.selectedRange);
    if (insertionEnd == self.textStorage.string.length)
    {
        [self.textStorage appendAttributedString:insertAfter];
    } else {
        [self.textStorage insertAttributedString:insertAfter
                                         atIndex:insertionEnd];
    }
    
    [self.textStorage insertAttributedString:insertBefore
                                     atIndex:selectedRange.location];
    
    self.textView.selectedRange = NSMakeRange(selectedRange.location + insertBefore.string.length, 0);
}

@end
