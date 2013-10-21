//
//  XGSCircularCell.h
//  MarkdownEditor
//
//  Created by Julien Grimault on 19/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
@class XGSCircularView;

@protocol XGSCircularCellItem <NSObject>

- (NSString *)displayString;

@optional
// what font to use to display the string, if not implemented or returning nil - use the font of the label
- (UIFont *)displayFont;

@end

@interface XGSCircularCell : UICollectionViewCell
@property (nonatomic, strong, readonly) UILabel *titleLabel;

- (void)bindItem:(id<XGSCircularCellItem>)item;

@end



