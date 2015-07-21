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
   
   
}
#pragma  mark ACTIONS
- (IBAction)toMainVC
{

    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    UIViewController *enteranceVC = VCFromStoryboard(@"Main", @"EntranceVC");
    delegate.window.rootViewController = enteranceVC;
}

- (IBAction) actionJoinClasses:(id)sender
{
   if (self.codeTXT.text.length != 4)
   {
       UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"notice"
                                                     message:@"verifycodeformaterror"
                                                    delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil, nil];
       [alert show];
   }
   else
   {
//       HttpManager *httpManager = [HttpManager sharedHttpManager];
//
//       
//       NSString *queryString =[NSString stringWithFormat:@"mobile=%@&smsCode=%@",self.phoneTXT.text,@""];
//       
//       [httpManager jsonDataFromServerWithBaseUrl:API_NAME_LOGIN_VALIDATE_MOBILE portID:8090 queryString:queryString callBack:^(id jsonData,NSError *error)
//        {
//            if(jsonData !=nil)
//            {
//                NSArray* arr = [jsonData allKeys];
//                for(NSString* str in arr)
//                {
//                    NSLog(@"%@=%@", str,[jsonData objectForKey:str]);
//                    if([str compare:@"data"]==NSOrderedSame)
//                    {
//                        NSDictionary *data =[jsonData objectForKey:str];
//                        
//                        NSString * userID = [data objectForKey:@"userID"];
//                        
//                        
//                        NSInteger isEntry = [data objectForKey:@"isEntryIndex"];
//                        
//                        if(isEntry == 0)
//                        {
//                            
//                        }
//                        else if (isEntry ==1)
//                        {
//                            
//                        }
//                    }
//                }
//                
//            }
//            
//        }];
//
//       [SMS_SDK commitVerifyCode:self.codeTXT.text result:^(enum SMS_ResponseState state)
//       {
//           if (1==state)
//           {
//
//               LoginTwoVC *login2= [[LoginTwoVC alloc ]initWithNibName:@"LoginTwoVC" bundle:nil];
//               
//               [self.navigationController pushViewController:login2 animated:YES];
//           }
//           else if (0==state)
//           {
//               NSLog(@"验证失败");
//               NSString* str=[NSString stringWithFormat:NSLocalizedString(@"verifycodeerrormsg", nil)];
//               UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"verifycodeerrortitle", nil)
//                                                             message:str
//                                                            delegate:self
//                                                   cancelButtonTitle:NSLocalizedString(@"sure", nil)
//                                                   otherButtonTitles:nil, nil];
//               [alert show];
//           }
//       }];
   }


    
    LoginTwoVC *login2= [[LoginTwoVC alloc ]initWithNibName:@"LoginTwoVC" bundle:nil];
    
    [self.navigationController pushViewController:login2 animated:YES];
}

- (IBAction) actionGetCode:(id)sender
{
   if([self validatePhoneNumber:self.phoneTXT.text])
   {
       [SMS_SDK getVerificationCodeBySMSWithPhone:self.phoneTXT.text
                                             zone:CHINA_AREA_ZONE
                                           result:^(SMS_SDKError *error)
        {
            if (!error)
            {
//                [self presentViewController:verify animated:YES completion:^{
//                    ;
//                }];
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
}

- (IBAction) actionClear:(id)sender
{
    [self.errorLabel setHidden:YES];
    [self.phoneTXT setText:@""];
    [self.clearBtn  setHidden:YES];
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

//-(void) createCustomNavigationBar:(BOOL)background withTitle:(NSString*)title withBackButton:(BOOL)back
//{
//    
//    
//    int width =[UIScreen mainScreen].bounds.size.width;
//    
//    UIView * bannerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 50)];
//    
//    if(background)
//    {
//        UIImageView *bannerBackground =[[UIImageView alloc]initWithFrame:bannerView.bounds];
//        [bannerBackground setImage:[UIImage imageNamed:@""]];
//        [bannerView addSubview:bannerBackground];
//    }
//    else
//    {
//        [bannerView setBackgroundColor:[UIColor colorWithRed:127/255.0 green:192/225.0 blue:224/255.0 alpha:1]];
//    }
//    
//    if([title length])
//    {
//        int titleWidth =100;
//        UILabel *titleView =[[UILabel alloc] initWithFrame:CGRectMake(width/2-titleWidth/2, 20, titleWidth, 30)];
//        titleView.numberOfLines=0;
//        titleView.textAlignment =NSTextAlignmentCenter;
//        [titleView setText:title];
//        [titleView setTextColor:[UIColor whiteColor]];
//        
//        [titleView setBackgroundColor:[UIColor clearColor]];
//        
//        [bannerView addSubview:titleView];
//        
//    }
//    [self.view addSubview: bannerView];
//    
//    
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}




@end
