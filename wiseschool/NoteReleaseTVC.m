//
//  NoteReleaseTVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "NoteReleaseTVC.h"

@interface NoteReleaseTVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NoteReleaseTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.clipsToBounds = YES;
    self.textView.layer.cornerRadius = 4.0;
    self.textView.layer.borderColor = [UIColor colorWithRed:230/255.0
                                                      green:230/255.0
                                                       blue:230/255.0
                                                      alpha:1].CGColor;
    self.textView.layer.borderWidth = 1.0;
}

@end
