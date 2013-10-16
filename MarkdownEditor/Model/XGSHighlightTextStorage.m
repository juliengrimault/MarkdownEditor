//
//  XGSHighlightTextStorage.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSHighlightTextStorage.h"
#import "XGSMarkdownTag.h"

@interface XGSHighlightTextStorage()
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, strong) UIFont *normalFont;
@end

@implementation XGSHighlightTextStorage {
    NSMutableAttributedString *_backingStore;
}


#pragma mark - NSTextStorage implementation
- (id)initWithTagStyles:(NSArray *)tags normalFont:(UIFont *)normalFont
{
    self = [super init];
    if (self) {
        _tags = [tags copy];
        _backingStore = [NSMutableAttributedString new];
        _normalFont = normalFont;
        _textColor = [UIColor darkTextColor];
    }
    return self;
}

- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location
                             effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self  edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes
            range:range
   changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}


#pragma mark - Syntax highlighting
- (void)processEditing
{
    NSRange paragaphRange = [self.string paragraphRangeForRange:self.editedRange];
    [self processRange:paragaphRange];
    [super processEditing];
}

- (void)processRange:(NSRange)range
{
    [_backingStore setAttributes:[self normalAttributes] range:range];
    
    for (XGSMarkdownTag *tag in self.tags) {
        [self applyStyle:tag.attributes forRegex:tag.regex inRange:range];
    }
}

- (void)applyStyle:(NSDictionary *)attributes forRegex:(NSString *)pattern inRange:(NSRange)range
{
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:0
                                  error:nil];
    
    [regex enumerateMatchesInString:[_backingStore string]
                            options:0
                              range:range
                         usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                             
                             NSRange matchRange = [match rangeAtIndex:0];
                             [self addAttributes:attributes range:matchRange];
                             
                             // reset the style to the original
                             if (NSMaxRange(matchRange)+1 < self.length) {
                                 [self addAttributes:[self normalAttributes]
                                               range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
                             }
                         }];
}
     
- (NSDictionary *)normalAttributes
{
    return @{ NSFontAttributeName : self.normalFont,
              NSForegroundColorAttributeName : self.textColor };
}



@end
