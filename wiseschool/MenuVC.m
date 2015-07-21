//
//  MenuVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "MenuVC.h"
#import "ContainerViewController.h"
#import "LoginOneVCViewController.h"
#import "AppDelegate.h"
@interface MenuVC ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation MenuVC
- (IBAction)login
{
    LoginOneVCViewController *loginVC= [[LoginOneVCViewController alloc ]initWithNibName:@"LoginOneVCViewController" bundle:nil];
   AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    delegate.window.rootViewController = nav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = 40.0;
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconImageView.layer.borderWidth = 2.0;
    
}



@end
