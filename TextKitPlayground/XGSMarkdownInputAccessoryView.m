//
//  XGSMarkdownInputView.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 12/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownInputAccessoryView.h"

static const CGFloat kDistanceBetweenButtons = 8.0f;

@interface XGSMarkdownInputAccessoryView()
@property (strong, nonatomic) UIButton *boldButton;
@property (strong, nonatomic) UIButton *italicButton;
@property (strong, nonatomic) UIButton *dismissKeyboardButton;
@end

@implementation XGSMarkdownInputAccessoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.boldButton = [self createButtonWithTitle:NSLocalizedString(@"Bold", nil) target:@selector(makeBold:)];
    self.italicButton = [self createButtonWithTitle:NSLocalizedString(@"Italic", nil) target:@selector(makeItalic:)];
    self.dismissKeyboardButton = [self createButtonWithTitle:NSLocalizedString(@"Dismiss", nil) target:@selector(dismissKeyboard:)];
}

    - (UIButton *)createButtonWithTitle:(NSString *)title target:(SEL)selector
    {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        [b addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [b setTitle:title forState:UIControlStateNormal];
        [self addSubview:b];
        return b;
    }

- (void)makeBold:(id)sender
{
    [self.delegate markdownInputView:self didSelectPattern:@"****" insertionIndex:2];
}

- (void)makeItalic:(id)sender
{
    [self.delegate markdownInputView:self didSelectPattern:@"**" insertionIndex:1];
}

- (void)dismissKeyboard:(id)sender
{
    [self.delegate markdownInputViewDidDismiss:self];
}

- (void)layoutSubviews
{
    CGFloat centerY = self.bounds.size.height * 0.5f;
    
    [self.italicButton sizeToFit];
    CGFloat centerItalicX = kDistanceBetweenButtons + self.italicButton.bounds.size.width * 0.5f;
    self.italicButton.center = CGPointMake(centerItalicX, centerY);

    [self.boldButton sizeToFit];
    CGFloat centerBoldX = kDistanceBetweenButtons * 2 + self.italicButton.bounds.size.width + self.boldButton.bounds.size.width * 0.5f;
    self.boldButton.center = CGPointMake(centerBoldX, centerY);
    
    [self.dismissKeyboardButton sizeToFit];
    CGFloat centerDismissX = self.bounds.size.width - kDistanceBetweenButtons - self.dismissKeyboardButton.bounds.size.width * 0.5f;
    self.dismissKeyboardButton.center = CGPointMake(centerDismissX, centerY);
    
}



@end
