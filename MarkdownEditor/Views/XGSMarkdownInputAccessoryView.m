//
//  XGSMarkdownInputView.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 12/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSMarkdownInputAccessoryView.h"
#import "XGSMarkdownTag.h"
#import "XGSCircularCell.h"
#import "XGSShortcut.h"

static const CGFloat kDistanceBetweenButtons = 8.0f;
static NSString *circularCellTagIdentifier = @"circularCellTagIdentifier";

@interface XGSMarkdownInputAccessoryView()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIToolbar *blurBar;//used only because it blurs stuff that is underneath
@property (nonatomic, strong) UICollectionView *actionsCollectionView;
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
    [self configureToolbar];
    [self configureDismissButton];
    [self configureCollectionView];
}

    - (void)configureToolbar
    {
        _blurBar = [[UIToolbar alloc] initWithFrame:self.frame];
        _blurBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_blurBar];
    }

    - (void)configureDismissButton
    {
        self.dismissKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.dismissKeyboardButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        [self.dismissKeyboardButton setTitle:NSLocalizedString(@"Dismiss", nil) forState:UIControlStateNormal];
        [self addSubview:self.dismissKeyboardButton];
    }

    - (void)configureCollectionView
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(30, 30);
        layout.sectionInset = UIEdgeInsetsMake(0, kDistanceBetweenButtons, 0, kDistanceBetweenButtons);
        
        self.actionsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.actionsCollectionView.backgroundColor = [UIColor clearColor];
        self.actionsCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.actionsCollectionView.collectionViewLayout = layout;
        self.actionsCollectionView.dataSource = self;
        self.actionsCollectionView.delegate = self;
        
        [self.actionsCollectionView registerClass:[XGSCircularCell class]
                       forCellWithReuseIdentifier:circularCellTagIdentifier];
        
        [self addSubview:self.actionsCollectionView];
    }

- (void)setShortcuts:(NSArray *)shortcuts
{
    if (_shortcuts == shortcuts) return;
    
    _shortcuts = [shortcuts copy];
    [self.actionsCollectionView reloadData];
}

- (void)dismissKeyboard:(id)sender
{
    [self.delegate markdownInputViewDidDismiss:self];
}

- (void)layoutSubviews
{
    CGFloat centerY = self.bounds.size.height * 0.5f;
    [self.dismissKeyboardButton sizeToFit];
    CGFloat centerDismissX = self.bounds.size.width - kDistanceBetweenButtons - self.dismissKeyboardButton.bounds.size.width * 0.5f;
    self.dismissKeyboardButton.center = CGPointMake(centerDismissX, centerY);
    
    CGFloat collectionViewWidth = self.bounds.size.width - self.dismissKeyboardButton.bounds.size.width - 2 * kDistanceBetweenButtons;
    self.actionsCollectionView.frame = CGRectMake(0, 0, collectionViewWidth, self.bounds.size.height);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shortcuts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<XGSCircularCellItem> shortcut = self.shortcuts[indexPath.row];

    XGSCircularCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:circularCellTagIdentifier
                                                                          forIndexPath:indexPath];
    [cell bindItem:shortcut];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id shortcut = self.shortcuts[indexPath.row];
    if ([shortcut isKindOfClass:[XGSMarkdownTag class]]) {
        [self.delegate markdownInputView:self didSelectMarkdownElement:shortcut];
    } else if ([shortcut isKindOfClass:[NSString class]]) {
        [self.delegate markdownInputView:self didSelectString:shortcut];
    } else if ([shortcut isKindOfClass:[XGSShortcut class]]) {
        [self.delegate markdownInputView:self didSelectString:[shortcut insertString]];
    }else {
        NSLog(@"Unsupported class for shortcut %@: %@", shortcut, [shortcut class]);
    }
}

@end
