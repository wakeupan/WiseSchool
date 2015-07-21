//
//  LoginTwoVC.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "LoginTwoVC.h"
#import "LoginThreeVC.h"

@interface LoginTwoVC ()
@end

@implementation LoginTwoVC

- (void)actionSelectProvince:(id)sender
{
    
}

- (void)actionSelectCity:(id)sender
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.navigationController)
    {
        self.navigationController.navigationBarHidden =YES;
    }
   [self createCustomNavigationBar:NO withTitle:@"账号注册" withBackButton:YES];
    

     [self.selecteProvinceBtn setEnabled:NO];
     [self.selecteCityBtn setEnabled:NO];
     [self.selecteQuareBtn setEnabled:YES];

    
//    self.provinceDatas =@[@"湖北",@"湖南",@"河南",@"广东",@"贵州",@"新疆",@"山西"];
//     self.cityDatas =@[@"武汉",@"荆州",@"荆门",@"孝感",@"黄冈",@"黄石",@"襄阳"];
    
     self.quareDatas = [NSMutableArray arrayWithArray:@[@"青山",@"江汉",@"洪山",@"江夏",@"新洲",@"蔡甸",@"东湖高新"]];
//     self.schoolDatas =@[@"一中",@"二中",@"三中",@"四中",@"五中",@"六中",@"七中"];
//     self.classesDatas =@[@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级"];
    
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
        [bannerView setBackgroundColor:[UIColor colorWithRed:127/255.0 green:192/225.0 blue:224/255.0 alpha:1]];
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

    [self.view addSubview: bannerView];
    [self resetPickerView:YES];
    
    
}
-(void)resetPickerView :(BOOL)hidden
{
    if(self.picker !=nil);
    {
        [self.picker removeFromSuperview];
    }
    self.picker =nil;
    
    int width  =[UIScreen mainScreen].bounds.size.width;
    int height =[UIScreen mainScreen].bounds.size.height;
    CGRect pickerFrame = CGRectMake(0, height-216, width, 216);
    self.picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    self.picker.showsSelectionIndicator = YES;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    [self.picker setBackgroundColor:[UIColor grayColor]];
    
   [self.view addSubview:self.picker];
   
    [self.picker setHidden:hidden];

    [self.selectedView setHidden:hidden];

    
}
#pragma mark- UIPickerView delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataSet objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataSet count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//- (IBAction) actionSelectProvince:(id)sender
//{
//     [self.selecteCityBtn setEnabled:NO];
//     [self.selecteQuareBtn setEnabled:NO];
//     [self.selecteSchoolBtn setEnabled:NO];
//     [self.selecteClassesBtn setEnabled:NO];
//     self.dataSet =self.provinceDatas;
//     [self.picker reloadAllComponents];
////    self.picker.hidden = NO;
//    btnIndex =1;
//    [self resetPickerView:NO];
//}
//- (IBAction) actionSelectCity:(id)sender
//{
//    [self.selecteQuareBtn setEnabled:NO];
//    [self.selecteSchoolBtn setEnabled:NO];
//    [self.selecteClassesBtn setEnabled:NO];
//    self.dataSet =self.cityDatas;
//    [self.picker reloadAllComponents];
////    self.picker.hidden = NO;
//    btnIndex =2;
//    [self.picker selectRow:0 inComponent:0 animated:YES];
//    [self resetPickerView:NO];
//}
- (IBAction) actionSelectQuare:(id)sender
{

    self.dataSet =self.quareDatas;
    [self.picker reloadAllComponents];


     [self.picker selectRow:0 inComponent:0 animated:YES];
     [self resetPickerView:NO];
}


- (IBAction) actionSelected:(id)sender
{
    int pickerIndex = 0;
    [self.picker setHidden:YES];
    [self.selectedView setHidden:YES];
    
    pickerIndex = [self.picker selectedRowInComponent:0];
    
    [self.selecteQuareBtn setTitle:self.quareDatas[pickerIndex] forState:UIControlStateNormal];
}


- (IBAction) actionNext:(id)sender
{
    LoginThreeVC *login3= [[LoginThreeVC alloc ]initWithNibName:@"LoginThreeVC" bundle:nil];
    
    [self.navigationController pushViewController:login3 animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)pop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
