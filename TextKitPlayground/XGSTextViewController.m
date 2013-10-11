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

@interface XGSTextViewController ()
@property (nonatomic, strong) NSTextStorage *textStorage;
@end

@implementation XGSTextViewController

- (void)loadView
{
    self.view = [UIView new];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self setupTextView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.readonlyView];
}

- (void)setupTextView
{
    XGSMarkupDefinition *markupDef = [XGSMarkupDefinition sharedInstance];
    self.textStorage = [[XGSHighlightTextStorage alloc] initWithTagStyles:markupDef.tagStyles normalFont:markupDef.normalFont];
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [self.textStorage addLayoutManager: layoutManager];
    
    NSTextContainer *textContainer = [NSTextContainer new];
    [layoutManager addTextContainer: textContainer];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:textContainer];
    [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    textView.backgroundColor = [UIColor purpleColor];
    self.textView = textView;
    
    UITextView *readonlyView = [UITextView new];
    [readonlyView setTranslatesAutoresizingMaskIntoConstraints:NO];
    readonlyView.editable = NO;
    readonlyView.backgroundColor = [UIColor lightGrayColor];
    self.readonlyView = readonlyView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id topGuide = self.topLayoutGuide;
    id editView = self.textView;
    id readonlyView = self.readonlyView;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(editView, readonlyView, topGuide);
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topGuide]-0-[editView]"
                                             options: 0
                                             metrics: nil
                                               views: viewsDictionary]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-[editView]-|"
                                             options: 0
                                             metrics: nil
                                               views: viewsDictionary]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-[readonlyView]-|"
                                             options: 0
                                             metrics: nil
                                               views: viewsDictionary]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat: @"V:[editView]-[readonlyView(==editView)]-|"
                                             options: 0
                                             metrics: nil
                                               views: viewsDictionary]];
    
    self.textView.text = @"Hello world. *Hellow world* **Hello world**";
}


@end
