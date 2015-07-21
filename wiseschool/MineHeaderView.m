//
//  MineHeaderView.m
//  WiseSchool
//
//  Created by itours on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "MineHeaderView.h"

@implementation MineHeaderView

- (IBAction)openMenu:(UIButton *)sender
{
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat newOffesetX = offsetX == 0 ? 80 : 0;
    [self.scrollView setContentOffset:CGPointMake(newOffesetX, 0) animated:YES];
}

- (void)tapedAt:(UITapGestureRecognizer *)sender
{
    CGFloat yLocation = [sender locationInView:self].y;
    if (yLocation > 0 && yLocation < 45) {
        [self openMenu:nil];
    }
}


- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuOpend) name:@"MenuOpend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuClosed) name:@"MenuClosed" object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedAt:)];
    
    [self addGestureRecognizer:tap];
    
}

- (void)menuOpend
{
    self.scrollView.scrollEnabled = NO;
    
}

- (void)menuClosed
{
    self.scrollView.scrollEnabled = YES;
}


@end
