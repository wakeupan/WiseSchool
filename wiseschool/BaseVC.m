//
//  BaseVC.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BaseVC.h"

#import "CommonConstants.h"
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
    
    UIView * bannerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 50)];
    
    if(background)
    {
        UIImageView *bannerBackground =[[UIImageView alloc]initWithFrame:bannerView.bounds];
        [bannerBackground setImage:[UIImage imageNamed:@""]];
        [bannerView addSubview:bannerBackground];
    }
    else
    {
        [bannerView setBackgroundColor:DEFINE_BLUE];
    }
    
    if([title length])
    {
        int titleWidth =100;
        UILabel *titleView =[[UILabel alloc] initWithFrame:CGRectMake(width/2-titleWidth/2, 20, titleWidth, 30)];
        titleView.numberOfLines=0;
        titleView.textAlignment =NSTextAlignmentCenter;
        [titleView setText:title];
        [titleView setTextColor:[UIColor whiteColor]];
        
        [titleView setBackgroundColor:[UIColor clearColor]];
        
        [bannerView addSubview:titleView];
        
    }
    
    if(back)
    {
        UIButton *btnNewBack = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btnNewBack.frame = CGRectMake(8.0, 20.0, 40.0, 30.0);
        
        
        [btnNewBack.imageView setContentMode:UIViewContentModeCenter];
        [btnNewBack setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
        [btnNewBack setImage:[UIImage imageNamed:@"btn_back_pressed"] forState:UIControlStateHighlighted];
        [btnNewBack addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
        [bannerView addSubview:btnNewBack];
    }
    
    [self.view addSubview: bannerView];
    
}

-(void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}





@end
