//
//  LoginOneVCViewController.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "LoginOneVCViewController.h"
#import "LoginTwoVC.h"
#import "BorderBtn.h"
#import "AppDelegate.h" 

#import "CommonConstants.h"

#import "HttpManager.h"

#import <SMS_SDK/SMS_SDK.h>

#define   CHINA_AREA_ZONE @"86"

@interface LoginOneVCViewController ()
@property (weak, nonatomic) IBOutlet BorderBtn *toMain;

@end

@implementation LoginOneVCViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.toMain.layer.cornerRadius = 15.0;
    
    [self.errorLabel setHidden:YES];
    [self.clearBtn setHidden:YES];
    
    if(self.navigationController)
    {
        self.navigationController.navigationBarHidden =YES;
    }
    
   [self createCustomNavigationBar:NO withTitle:@"账号注册" withBackButton:NO];
    
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopEditing:)];
    self.phoneTXT.delegate =self;
   
    AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if(appDelegate.user==nil)
    {
        appDelegate.user =[[User alloc]init];
    }
    
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
   // self.inputViewBottomDistance.constant = 0;
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
   // NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
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
    
    [self.errorLabel setHidden:YES];

    [self.clearBtn  setHidden:YES];
}
#pragma  mark ACTIONS
- (IBAction)toMainVC
{

    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    UIViewController *enteranceVC = VCFromStoryboard(@"Main", @"EntranceVC");
    delegate.window.rootViewController = enteranceVC;
}
-(void)verifyCode
{
           [ProgressHUD show:@"正在验证中......"];
           [SMS_SDK commitVerifyCode:self.codeTXT.text result:^(enum SMS_ResponseState state)
           {
               [ProgressHUD dismiss];
               if (1==state)
               {
    
                   LoginTwoVC *login2= [[LoginTwoVC alloc ]initWithNibName:@"LoginTwoVC" bundle:nil];
    
                   [self.navigationController pushViewController:login2 animated:YES];
               }
               else if (0==state)
               {
                   NSLog(@"验证失败");
                   NSString* str=[NSString stringWithFormat:@"验证失败"];
                   UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"验证码不匹配，输入正确的验证码"
                                                                 message:str
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil];
                   [alert show];
               }
           }];
}
- (IBAction) actionJoinClasses:(id)sender
{
   if (!self.phoneTXT.text.length>0)
   {
       UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请输入手机号码"
                                                     message:@"清输入您的手机号码，通过验证后再加入"
                                                    delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil, nil];
       [alert show];
       return ;
   }
   if(self.codeTXT.text.length>0)
   {
       if (self.codeTXT.text.length != 4)
       {
           UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"验证码出错"
                                                         message:@"请输入手机收到的正确验证码"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
           [alert show];
       }
       else
       {
           [self verifyCode];
           
       }

   }else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"验证码出错"
                                                      message:@"验证码不能为空，请先获取验证码"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }


   // [self actionToNext];
  
}
-(void)actionToNext
{
    
    LoginTwoVC *login2= [[LoginTwoVC alloc ]initWithNibName:@"LoginTwoVC" bundle:nil];
    
    [self.navigationController pushViewController:login2 animated:YES];
}
-(void)requestUserId
{
           [ProgressHUD show:@"正在验证中......"];
           HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    
           NSString *queryString =[NSString stringWithFormat:@"mobile=%@&smsCode=%@",self.phoneTXT.text,@""];
    
           [httpManager jsonDataFromServerWithBaseUrl:API_NAME_LOGIN_VALIDATE_MOBILE portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
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
                            AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];
                            appDelegate.user.userID = [data objectAtIndex:0][@"userId"];
                            [[NSUserDefaults standardUserDefaults] setObject:appDelegate.user.userID forKey:USER_ID_KEY];//;
                            NSString *isEntryIndex =[NSString stringWithFormat:@"%ld",[[data objectAtIndex:0][@"isEntityIndex"]integerValue]];
                            
                            if([isEntryIndex isEqualToString:@"1"])
                            {
                            
                                [self toMainVC];
                            }
                            else
                            {
                                
                                //[self actionToNext];
                                [self getValidateCodebySMS];
                            }
                           
                        }
                        
                    }else
                    {
                        [ProgressHUD showError:jsonData[@"errorMsg"]];
                    }

                    
                    
                    
                }
                
            }];
}
-(void)getValidateCodebySMS
{
           [ProgressHUD show:@"正在验证中......"];
    
    
           [SMS_SDK getVerificationCodeBySMSWithPhone:self.phoneTXT.text
                                                 zone:CHINA_AREA_ZONE
                                               result:^(SMS_SDKError *error)
            {
                [ProgressHUD dismiss];
                if (!error)
                {
                    
                }
                else
                {
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"codesenderrtitle"
                                                                  message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
                                                                 delegate:self
                                                        cancelButtonTitle:@"sure"
                                                        otherButtonTitles:nil, nil];
                    [alert show];
    
                }
                
            }];
}
- (IBAction) actionGetCode:(id)sender
{
    
   [self.phoneTXT resignFirstResponder];
   if([self validatePhoneNumber:self.phoneTXT.text])
   {
      
       
       [self requestUserId];


   }
}

- (IBAction) actionClear:(id)sender
{
    [self.errorLabel setHidden:YES];
    [self.phoneTXT setText:@""];
    [self.clearBtn  setHidden:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [self.clearBtn setHidden:NO];
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self.clearBtn setHidden:NO];
    
    return YES;
}
-(BOOL)validatePhoneNumber:(NSString*)phoneNumber
{

    BOOL isMatch =[self isMobileNumber:phoneNumber];
    if(phoneNumber.length !=11|| !isMatch)
    {
        [self.errorLabel setHidden:NO];
        [self.clearBtn setHidden:NO];
        return NO;
   }
   return YES;
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}

@end
