//
//  XGSCircularCell.m
//  MarkdownEditor
//
//  Created by Julien Grimault on 19/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSCircularCell.h"

@interface XGSCircularCell()
@property (readonly, nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation XGSCircularCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self addTitleLabel];
    [self addCircleShape];
    [self configureCircleLayer];
}

    - (void)addTitleLabel
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_titleLabel];
    }

    - (void)addCircleShape
    {
        _shapeLayer = [CAShapeLayer layer];
        [self.contentView.layer addSublayer:_shapeLayer];
    }

- (void)tintColorDidChange
{
    [self configureCircleLayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.contentView.bounds.size.width * 0.5f, self.contentView.bounds.size.height * 0.5f);
    [self configureCircleLayer];
}

- (void)configureCircleLayer
{
    [self configureCircleShape];
    [self configureCircleColor];
}

    - (void)configureCircleShape
    {
        CGFloat diameter = MIN(self.bounds.size.width, self.bounds.size.width);
        self.shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, diameter, diameter)
                                                 cornerRadius:diameter * 0.5f].CGPath;
    }

    - (void)configureCircleColor
    {
        self.shapeLayer.fillColor = self.highlighted ? [self.tintColor colorWithAlphaComponent:0.2].CGColor : [UIColor clearColor].CGColor;
        
        self.shapeLayer.strokeColor = self.tintColor.CGColor;
        self.titleLabel.textColor = self.tintColor;
        
        self.shapeLayer.lineWidth = 1;
    }

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self configureCircleLayer];
}

- (void)bindItem:(id<XGSCircularCellItem>)item
{
    if ([item respondsToSelector:@selector(displayFont)] && [item displayFont] != nil) {
        self.titleLabel.font = [item displayFont];
    } else {
        self.titleLabel.font = [UIFont systemFontOfSize:17];
    }

    self.titleLabel.text = [item displayString];
}

@end