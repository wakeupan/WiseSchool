//
//  BaseVC.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController
//@property(nonatomic,weak)UIView *bannerView;
//@property(nonatomic,weak)UIImageView *bg;

-(void) createCustomNavigationBar:(BOOL)background withTitle:(NSString*)title withBackButton:(BOOL)back;
@end
