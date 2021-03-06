//
//  LoginTwoVC.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "LoginTwoVC.h"
#import "LoginThreeVC.h"

#import "CommonConstants.h"

#import "HttpManager.h"

#import "AppDelegate.h" 

#define AREA_ID_KEY @"areaId"
#define AREA_NAME_KEY @"areaName"

#define SCHOOL_ID_KEY @"schoolId"
#define SCHOOL_NAME_KEY @"schoolName"

#define GRADE_ID_KEY @"gradeId"
#define GRADE_NAME_KEY @"gradeName"

@interface LoginTwoVC ()
{
    int btnIndex;
    int areaIndex;
    int schoolIndex;
}
@end

@implementation LoginTwoVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.navigationController)
    {
        self.navigationController.navigationBarHidden =YES;
    }
   [self createCustomNavigationBar:NO withTitle:@"账号注册" withBackButton:NO];
    

     [self.selectSchoolBtn setEnabled:NO];
     [self.selectSchoolBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
     [self.selectGardeBtn setEnabled:NO];
     [self.selectGardeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//     [self.selecteQuareBtn setEnabled:YES];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopEditing:)];
    
   self.quareDatas =[[NSMutableArray alloc]init];
    
   self.schoolDatas =[[NSMutableArray alloc]init];
    
   self.gradeDatas =[[NSMutableArray alloc]init];
    
   btnIndex = areaIndex = schoolIndex = -1;
    
   [self resetPickerView:YES];
    
    AppDelegate *delegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.user = delegate.user;
    


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.view removeGestureRecognizer:self.tap];
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
  //  self.inputViewBottomDistance.constant = 0;
    [UIView animateKeyframesWithDuration:animationDuration
                                   delay:0
                                 options:animationCurve
                              animations:^{
                                  [self.view layoutIfNeeded];
                              } completion:NULL];
}

- (void)stopEditing:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.view addGestureRecognizer:self.tap];
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];

    [UIView animateKeyframesWithDuration:animationDuration
                                   delay:0
                                 options:animationCurve
                              animations:^{
                                  [self.view layoutIfNeeded];
                              } completion:NULL];
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

- (IBAction) actionSelectQuare:(id)sender
{
    [self.selectSchoolBtn setEnabled:NO];
    [self.selectSchoolBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.selectGardeBtn setEnabled:NO];
    [self.selectGardeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [ProgressHUD show:@"获取区域信息..."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
   [httpManager jsonDataFromServerWithBaseUrl:API_NAME_LOGIN_GET_AREA_FOR_CITY portID:8080 queryString:@"" callBack:^(id jsonData,NSError *error)
    {
        [ProgressHUD dismiss];
        if(jsonData !=nil)
        {
            NSArray* arr = [jsonData allKeys];
            for(NSString* str in arr)
            {
                NSLog(@"%@=%@", str,[jsonData objectForKey:str]);
            }
            NSString * status =[jsonData objectForKey:@"status"];
            
            if([status compare:@"1"]==NSOrderedSame)
            {
                NSArray *data =[jsonData objectForKey:@"data"];
                NSMutableArray *tmpArray =[[NSMutableArray alloc]init];
                if(data!=nil&&data.count>0)
                {
                    for(NSDictionary * dic in data)
                    {
                        [self.quareDatas addObject:dic];
                        [tmpArray addObject:dic[AREA_NAME_KEY]];
                    }
                }
                self.dataSet = [NSArray arrayWithArray:tmpArray];
                
                btnIndex =0;
                [self.picker reloadAllComponents];
                
                [self.picker selectRow:0 inComponent:0 animated:YES];
                [self resetPickerView:NO];
                
            }else
            {
                [ProgressHUD showError:jsonData[@"errorMsg"]];
            }

        }
        
        
    }];
    

 

}

-(void)requestSchoolData:(int)index
{
    [ProgressHUD show:@"获取学校信息..."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];

    NSDictionary *areaData =[self.quareDatas objectAtIndex:index];
    
    NSString *queryString =[NSString stringWithFormat:@"%@=%@",AREA_ID_KEY,areaData[AREA_ID_KEY]];
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_LOGIN_GET_SCHOOL_FOR_AREA portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         [ProgressHUD dismiss];
         if(jsonData !=nil)
         {
             
             NSString * status =[jsonData objectForKey:@"status"];
             
             NSMutableArray * tmpSchools = [[NSMutableArray alloc]init];
             if([status compare:@"1"]==NSOrderedSame)
             {
                 NSArray *data =[jsonData objectForKey:@"data"];
                 if(data!=nil&&data.count>0)
                 {
                     for(NSDictionary * dic in data)
                     {
                         [self.schoolDatas addObject:dic];
                         
                         [tmpSchools addObject:dic[SCHOOL_NAME_KEY]];
                     }
                     
                     self.dataSet = [NSArray arrayWithArray:tmpSchools];
                     
                     btnIndex =1;
                     [self.picker reloadAllComponents];
                     
                     [self.picker selectRow:0 inComponent:0 animated:YES];
                     [self resetPickerView:NO];
                 }

                 
             }else
             {
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
         }
         
         
     }];
    

}

-(void)requestGradeData:(int)intdex
{
    [ProgressHUD show:@"获取年级信息..."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
 
    NSDictionary *areaData =[self.schoolDatas objectAtIndex:0];
    
    NSString *queryString =[NSString stringWithFormat:@"%@=%@",SCHOOL_ID_KEY,areaData[SCHOOL_ID_KEY]];
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_LOGIN_GET_GRADE_FOR_SCHOOL portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         [ProgressHUD dismiss];
         if(jsonData !=nil)
         {
             NSArray* arr = [jsonData allKeys];
             for(NSString* str in arr)
             {
                 NSLog(@"%@=%@", str,[jsonData objectForKey:str]);
             }
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 NSArray *data =[jsonData objectForKey:@"data"];
                 if(data!=nil&&data.count>0)
                 {
                     NSMutableArray *tmpGrade =[[NSMutableArray alloc]init];
                     for(NSDictionary * dic in data)
                     {
                         [self.gradeDatas addObject:dic];
                         
                         [tmpGrade addObject:dic[GRADE_NAME_KEY]];
                     }
                     self.dataSet = [NSArray arrayWithArray:tmpGrade];
                     
                     btnIndex =2;
                     [self.picker reloadAllComponents];
                     
                     [self.picker selectRow:0 inComponent:0 animated:YES];
                     [self resetPickerView:NO];
                 }
                 

                 
             }else
             {
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
         }
         
         
     }];
    
    
}


- (IBAction) actionSelected:(id)sender
{
    int pickerIndex = 0;
    [self.picker setHidden:YES];
    [self.selectedView setHidden:YES];
    
    pickerIndex = [self.picker selectedRowInComponent:0];
    
    if(btnIndex == 0)
    {
        [self.selecteQuareBtn setTitle:self.dataSet[pickerIndex] forState:UIControlStateNormal];
        
        [self.selectSchoolBtn setEnabled:YES];
        
        [self requestSchoolData:pickerIndex];
        
        areaIndex = pickerIndex;
    }
    else if (btnIndex == 1)
    {
        [self.selectSchoolBtn setTitle:self.dataSet[pickerIndex] forState:UIControlStateNormal];
        [self.selectSchoolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.selectGardeBtn setEnabled:YES];
        
        [self requestGradeData:pickerIndex];
        
        schoolIndex = pickerIndex;
    }
    else if (btnIndex == 2)
    {
        [self.selectGardeBtn setTitle:self.dataSet[pickerIndex] forState:UIControlStateNormal];
        [self.selectGardeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        appDelegate.user.gradeId = [self.gradeDatas objectAtIndex:pickerIndex][@"gradeId"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[self.gradeDatas objectAtIndex:pickerIndex][@"gradeId"]forKey:@"gradeId"];
    }
    
}


- (IBAction)actionSelectSchool:(id)sender
{
    [self.selectGardeBtn setEnabled:NO];
    [self.selectGardeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self requestSchoolData:areaIndex];
}

- (IBAction)actionSelectGarde:(id)sender
{
    [self requestGradeData:schoolIndex];
}

-(BOOL)invlidateUserData
{
    if(self.classTextField.text.length>0)
    {
        self.user.ClassNo = [self.classTextField.text intValue];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请完善信息"
                                                        message:@"请选择所在班级"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert setTag:7];
        [alert show];
        
        return NO;
        
    }
    return YES;
}



- (IBAction) actionNext:(id)sender
{
    if(![self invlidateUserData])
    {
        return;
    }
    
    LoginThreeVC *login3= [[LoginThreeVC alloc ]initWithNibName:@"LoginThreeVC" bundle:nil];
    
    [self.navigationController pushViewController:login3 animated:YES];

}

-(void)setUserData
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    delegate.user.ClassNo = [self.classTextField.text integerValue];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)pop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
