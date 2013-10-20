//
//  XGSMarkdownButton.m
//  MarkdownEditor
//
//  Created by Julien Grimault on 19/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSIconCircularButton.h"
#import "UIFont+FontAwesome.h"

@interface XGSIconCircularButton()
@property (readonly, nonatomic) CAShapeLayer *shapeLayer;
@end

@implementation XGSIconCircularButton

+ (Class) layerClass
{
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer
{
    return (CAShapeLayer *)self.layer;
}

+ (instancetype)buttonWithTitle:(NSString *)title
{
    XGSIconCircularButton *b = [[self alloc] initWithFrame:CGRectZero];
    [b setTitle:title forState:UIControlStateNormal];
    return b;
}

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
    [self configureCircleLayer];
}

- (void)tintColorDidChange
{
    [self configureCircleLayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
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
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        
        self.shapeLayer.lineWidth = 1;
    }

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self configureCircleLayer];
}

@end

@implementation XGSIconCircularButton(FAIcon)

+ (instancetype)buttonWithIcon:(FAIcon)icon
{
    XGSIconCircularButton *b = [self buttonWithTitle:[NSString fontAwesomeIconStringForEnum:icon]];
    [b.titleLabel setFont:[UIFont fontAwesomeFontOfSize:15.0]];
    return b;
}
@end
