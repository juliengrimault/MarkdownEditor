//
//  XGSTextViewController.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSTextViewController.h"
#import "XGSHighlightTextStorage.h"
#import "XGSMarkdownDefinition.h"
#import "XGSMarkdownInputAccessoryView.h"
#import "UIColor+AppColor.h"
#import "XGSMarkdownTag.h"
#import "PSMenuItem.h"
#import "XGSMarkdownInsertionController.h"
@interface XGSTextViewController ()
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

- (id)initWithMarkupProcessor:(XGSMarkdownDefinition *)markdownDefinition
{
    self = [super init];
    if (self) {
        _markdownDefinition = markdownDefinition;
        self.title = NSLocalizedString(@"Edit", nil);
    }
    return self;
}

- (void)loadView
{
    self.view = [UIView new];

    [self setupTextView];
    [self addCustomMenuItems];
}

    - (void)setupTextView
    {
        self.textStorage = [[XGSHighlightTextStorage alloc] initWithTagStyles:self.markdownDefinition.markdownTags normalFont:self.markdownDefinition.normalFont];
        
        NSLayoutManager *layoutManager = [NSLayoutManager new];
        [self.textStorage addLayoutManager: layoutManager];
        
        NSTextContainer *textContainer = [NSTextContainer new];
        [layoutManager addTextContainer: textContainer];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:textContainer];
        [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.textView = textView;
        [self.view addSubview:self.textView];
        
        XGSMarkdownInputAccessoryView *inputAccessoryView = [[XGSMarkdownInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        inputAccessoryView.shortcuts = [self.markdownDefinition.markdownTags arrayByAddingObjectsFromArray:self.markdownDefinition.additionalShortcuts];
        inputAccessoryView.tintColor = [UIColor xgs_greenColor];
        inputAccessoryView.delegate = self.markdownInsertionController;
        textView.inputAccessoryView = inputAccessoryView;
    }

    - (void)addCustomMenuItems
    {
        NSMutableArray *items = [NSMutableArray new];
        for(XGSMarkdownTag *tag in self.markdownDefinition.markdownTags) {
            [items addObject:[self menuItemForMarkdownTag:tag]];
        }
        [UIMenuController sharedMenuController].menuItems = items;
    }

        - (UIMenuItem *)menuItemForMarkdownTag:(XGSMarkdownTag *)tag
        {
            return [[PSMenuItem alloc] initWithTitle:tag.name block:^{
                [self.markdownInsertionController insertMarkdownTag:tag];
            }];
        }

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupConstraints];
    self.textView.text = NSLocalizedString(@"This is a demo of what you can do:\n1 * on each side of a word will make it *italic*.\n2 * on each side will make it **bold**.\n\n1 _ on each side of a word will _underline_ it\nYou can also =highlight stuff= by putting words between =.\n\nPretty cool no?",nil);
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

- (XGSMarkdownInsertionController *)markdownInsertionController
{
    if (_markdownInsertionController == nil) {
        _markdownInsertionController = [[XGSMarkdownInsertionController alloc] initWithTextStorage:self.textStorage textView:self.textView];
    }
    return _markdownInsertionController;
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
