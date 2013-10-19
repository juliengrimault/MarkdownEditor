//
//  XGSMarkdownInputView.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 12/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownInputAccessoryView.h"
#import "XGSMarkdownTag.h"
#import "XGSIconCircularButton.h"
#import "XGSMarkdownIcon.h"

static const CGFloat kDistanceBetweenButtons = 8.0f;

@interface XGSMarkdownInputAccessoryView()
@property (nonatomic, strong) UIToolbar *blurBar;//used only because it blurs stuff that is underneath
@property (nonatomic, strong) NSMutableDictionary *buttons;
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
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _blurBar = [[UIToolbar alloc] initWithFrame:self.frame];
    _blurBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_blurBar];
    _buttons = [NSMutableDictionary new];
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

- (void)setMarkdownTags:(NSArray *)markdownTags
{
    [self removeAllButtons];
    
    for(XGSMarkdownTag *tag in markdownTags) {
        UIButton *b = [self createMarkdownButtonForTag:tag];
        _buttons[tag] = b;
    }
}

    - (XGSIconCircularButton *)createMarkdownButtonForTag:(XGSMarkdownTag *)tag
    {
        FAIcon tagIcon = iconForMarkdownTag(tag.type);
        XGSIconCircularButton *markdownButton = [XGSIconCircularButton buttonWithIcon:tagIcon];
        [markdownButton addTarget:self
                           action:@selector(insertMarkdown:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:markdownButton];
        return markdownButton;
    }

    - (void)removeAllButtons
    {
        [_buttons enumerateKeysAndObjectsUsingBlock:^(id key, UIButton *b, BOOL *stop) {
            [b removeFromSuperview];
        }];
        [_buttons removeAllObjects];
    }

- (NSArray *)markdownTags
{
    return [_buttons allKeys];
}

- (void)insertMarkdown:(id)sender
{
    NSArray *tags = [_buttons allKeysForObject:sender];
    if (tags != nil && tags.count > 0)
    {
        [self.delegate markdownInputView:self didSelectMarkdownElement:tags.firstObject];
    }
}

- (void)dismissKeyboard:(id)sender
{
    [self.delegate markdownInputViewDidDismiss:self];
}

- (void)layoutSubviews
{
    CGFloat centerY = self.bounds.size.height * 0.5f;
    
    __block NSUInteger i = 0;
    __block CGFloat centerX = 0;
    [self.buttons enumerateKeysAndObjectsUsingBlock:^(XGSMarkdownTag *tag, UIButton *b, BOOL *stop) {
        CGSize suggestedSize = [b sizeThatFits:CGSizeZero];
        CGFloat side = MAX(suggestedSize.width, suggestedSize.height);
        [b setBounds:CGRectMake(0, 0, side, side)];
        centerX +=  kDistanceBetweenButtons + b.bounds.size.width * 0.5f;
        b.center = CGPointMake(centerX, centerY);
        centerX += b.bounds.size.width * 0.5f;
        ++i;
    }];
    
    [self.dismissKeyboardButton sizeToFit];
    CGFloat centerDismissX = self.bounds.size.width - kDistanceBetweenButtons - self.dismissKeyboardButton.bounds.size.width * 0.5f;
    self.dismissKeyboardButton.center = CGPointMake(centerDismissX, centerY);
    
}



@end
