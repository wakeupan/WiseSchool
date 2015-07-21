//
//  BaseVC.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self )
    {
        
    }
    
    return  self;
}

-(void) createCustomNavigationBar:(BOOL)background withTitle:(NSString*)title withBackButton:(BOOL)back
{
    int width =[UIScreen mainScreen].bounds.size.width;
    
    UIView * bannerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    
    if(background)
    {
        UIImageView *bannerBackground =[[UIImageView alloc]initWithFrame:bannerView.bounds];
        [bannerBackground setImage:[UIImage imageNamed:@""]];
        [bannerView addSubview:bannerBackground];
    }
    else
    {
        [bannerView setBackgroundColor:[UIColor greenColor]];
    }
    
    if([title length])
    {
        int titleWidth =100;
        UILabel *titleView =[[UILabel alloc] initWithFrame:CGRectMake((width-titleWidth)/2+titleWidth/2, 0, titleWidth, 30)];
        titleView.numberOfLines=0;
        titleView.lineBreakMode=UILineBreakModeCharacterWrap;
        [titleView setText:title];
        [titleView setTextColor:[UIColor blackColor]];
        
        [titleView setBackgroundColor:[UIColor clearColor]];
        
        [bannerView addSubview:titleView];
        
    }
//    _bg =[[UIImageView alloc]initWithFrame:self.view.bounds];
//    [ _bg setImage:[UIImage imageNamed:@"bk"]];
//    [self.view addSubview:self.bg];
//    [self.view sendSubviewToBack:self.bg];
      UIImageView *bg=[[UIImageView alloc]initWithFrame:self.view.bounds];
      [ bg setImage:[UIImage imageNamed:@"bk"]];
    
     [self.view addSubview:bg];
     [self.view sendSubviewToBack:bg];
     [self.view addSubview: bannerView];
    

}



@end
