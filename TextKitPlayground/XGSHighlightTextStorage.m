//
//  XGSHighlightTextStorage.m
//  TextKitPlayground
//
//  Created by Julien Grimault on 11/10/13.
//  Copyright (c) 2013 XiaoGouSoftware. All rights reserved.
//

#import "XGSHighlightTextStorage.h"

@interface XGSHighlightTextStorage()
@property (nonatomic, strong) NSDictionary *tagStyles;
@property (nonatomic, strong) UIFont *normalFont;
@end

@implementation XGSHighlightTextStorage {
    NSMutableAttributedString *_backingStore;
}


#pragma mark - NSTextStorage implementation
- (id)initWithTagStyles:(NSDictionary *)tagStyles normalFont:(UIFont *)normalFont
{
    self = [super init];
    if (self) {
        _tagStyles = [tagStyles copy];
        _backingStore = [NSMutableAttributedString new];
        _normalFont = normalFont;
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
    [self.tagStyles enumerateKeysAndObjectsUsingBlock:^(NSString *pattern, NSDictionary *attributes, BOOL *stop) {
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:pattern
                                      options:0
                                      error:nil];
        
        [regex enumerateMatchesInString:[_backingStore string]
                                options:0
                                  range:range
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){

                                 NSRange matchRange = [match rangeAtIndex:1];
                                 [self addAttributes:attributes range:matchRange];
                                 
                                 // reset the style to the original
                                 if (NSMaxRange(matchRange)+1 < self.length) {
                                     [self addAttributes:@{ NSFontAttributeName : self.normalFont }
                                                   range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
                                 }
                             }];
    }];
}



@end
