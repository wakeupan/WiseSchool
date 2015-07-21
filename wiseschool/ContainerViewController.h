//
//  ContainerViewController.h
//  WiseSchool
//
//  Created by 张宝 on 15/7/3.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVC.h"
#import "MenuVC.h"

@interface ContainerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *menuContainerView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) MainVC *mainVC;
@property (nonatomic, strong) MenuVC *menuVC;

@property (nonatomic) BOOL isShowing;
- (void)toogleMenuVC:(BOOL)show with:(BOOL)animated;

@end
