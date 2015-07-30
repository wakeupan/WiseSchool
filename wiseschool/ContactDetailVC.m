//
//  ContactDetailVC.m
//  wiseschool
//
//  Created by BlueWind on 15/7/30.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "ContactDetailVC.h"

#import "CommonConstants.h"

#import "HttpManager.h"

#define IMAGE_CELL @"Image_Cell"

#define INFO_CELL @"Info_Cell"

#define FUCTION_CELL @"Fuction_Cell"

@interface ContactDetailVC ()


@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) UIImageView *iconImage;

@property (weak, nonatomic) UITextField *nameTxt;
@property (weak, nonatomic) UITextField *typeTxt;
@property (weak, nonatomic) UIButton *timeLineBtn;
@property (weak, nonatomic) UIButton *phoneBtn;
@property (weak, nonatomic) UIButton *messageBtn;

@property (nonatomic, strong) NSString *studentID;


@end

@implementation ContactDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getAddressDetailsInfo:@"4028af814ed340b3014ed3482d650003" withContactID:@"4028af814ed340b3014ed34a60880008" withContactType:@"3"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Table view datasource and delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IMAGE_CELL];
        
        self.iconImage = (UIImageView*)[cell.contentView.subviews lastObject ];
        
        self.iconImage.clipsToBounds = YES;
        self.iconImage.layer.cornerRadius = 48.0;
        
       // titleLabel.text = self.noticieDetailsInfo.noticeDetailTitle;
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:INFO_CELL];
        
        self.nameTxt = (UITextField*)[cell.contentView viewWithTag:2015];
        
        self.typeTxt = (UITextField*)[cell.contentView viewWithTag:2016];
        return cell;
    }
    else if (indexPath.row ==2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FUCTION_CELL];
        
        self.timeLineBtn = (UIButton*)[cell.contentView viewWithTag:2015];
        self.messageBtn  = (UIButton*)[cell.contentView viewWithTag:2016];
        self.phoneBtn    = (UIButton*)[cell.contentView viewWithTag:2017];
        
        
        [self.timeLineBtn setBackgroundColor:DEFINE_ORGANG];
        [self.messageBtn setBackgroundColor:DEFINE_ORGANG];
        [self.phoneBtn setBackgroundColor:DEFINE_ORGANG];
        
        
        [self.timeLineBtn addTarget:self
                          action:@selector(actionTimeLine:)
                forControlEvents:UIControlEventTouchUpInside
         ];
        
        [self.messageBtn addTarget:self
                             action:@selector(actionMessage:)
                   forControlEvents:UIControlEventTouchUpInside
         ];
        
        [self.phoneBtn addTarget:self
                             action:@selector(actionPhone:)
                   forControlEvents:UIControlEventTouchUpInside
         ];
        


        return cell;
    }
    return nil;
    
}
-(void)actionTimeLine:(id)sender
{
    
}

-(void)actionMessage:(id)sender
{
    
}
-(void)actionPhone:(id)sender
{
    
}

#pragma mark - API Remote - Service
-(void)getAddressDetailsInfo:(NSString*)classID withContactID:(NSString*)contactID withContactType:(NSString*)contactType
{
    [ProgressHUD show:@"获取通讯录详情....."];
    NSString *queryString = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",CLASS_ID_KEY,classID,@"contactId",contactID,@"contactType",contactType,USER_ID_KEY,@"40288dea4ed761b7014ed77b75c10000"];
    
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CLASS_ADDRESS_DETAIL portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
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


             }else{
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
             
             
         }
         
         
     }];

}





@end
