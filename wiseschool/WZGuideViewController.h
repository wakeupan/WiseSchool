//
//  WZGuideViewController.h
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZGuideViewController : UIViewController<UIScrollViewDelegate>
{
    BOOL _animating;
    
    UIScrollView *_pageScroll;
    
    UIPageControl *_pageControl;
}

@property (nonatomic, assign) BOOL animating;

@property (nonatomic, strong) UIScrollView *pageScroll;

@property (nonatomic, strong) UIPageControl *pageControl;

+ (WZGuideViewController *)sharedGuide;

+ (void)show;
+ (void)hide;

@end
