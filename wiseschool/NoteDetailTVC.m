//
//  NoteDetailTVC.m
//  wiseschool
//
//  Created by BlueWind on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "NoteDetailTVC.h"
#import "CommonConstants.h"

#import "HttpManager.h"

#define TITLE_CELL @"TitleCell"

#define IMAGE_CELL @"ImageCell"

#define CONTENT_CELL @"ContentCell"

#define AGREE_CELL @"AgreeCell"

#define READ_CELL @"ReadCell"

#define REPLY_CELL @"RelpyCell"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface NoteDetailTVC ()
@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@end

@implementation NoteDetailTVC


#pragma mark - lifecyle for view controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getDetailInfoForNoteRelease:@"40288dea4ed36b89014ed36ece0d0001"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

#pragma mark  API Remote service 
-(void)getDetailInfoForNoteRelease:(NSString*)parentNoticeId
{
    [ProgressHUD show:@"获取家长书详情....."];
    NSString *queryString = [NSString stringWithFormat:@"%@=%@&%@=%@",@"parentNoticeId",parentNoticeId,USER_ID_KEY,@"4028af814ed340b3014ed3509558000d"];
    
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CLASS_RELEASE_NOTICE_DETAIL portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
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
                 NSDictionary *dic = [jsonData objectForKey:@"data"][0];
                 self.noticieDetailsInfo = [[NoticeDetails alloc]initFromDictionary:dic];
                 
                 self.arrayForTabelCells = [[NSMutableArray alloc]init];
                 
                 [self.arrayForTabelCells addObject:@44.0];
                 [self.arrayForTabelCells addObject:@0];
                 
                 float contentHeight = [self heightFromString:self.noticieDetailsInfo.noticeDetailContent withFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
                 
                 [self.arrayForTabelCells addObject:@(contentHeight)];
                 
               
                 
                 [self.arrayForTabelCells addObject:@80];
                 
                 if(self.noticieDetailsInfo.noticeDetailStatisticsInfoList==nil||[self.noticieDetailsInfo.noticeDetailStatisticsInfoList count]==0)
                 {
                     [self.arrayForTabelCells addObject:@0];
                     
                     [self.arrayForTabelCells addObject:@0];
                 }else
                 {
                     int agree = 0;
                     int read  = 0;
                      for(ReplyInfo *info in self.noticieDetailsInfo.noticeDetailStatisticsInfoList)
                      {
                         if([info.replayIsAgree isEqualToString:@"1"])
                         {
                             agree++;
                             [self.agree appendString:info.replayStudentName];
                             [self.agree appendString:@","];
                         }
                         else
                         {
                             [self.noAgree appendString:info.replayStudentName];
                             [self.noAgree appendString:@","];
                         }
                          
                         if ([info.replayIsRead isEqualToString:@"1"])
                        {
                            read++;
                            
                            [self.reading appendString:info.replayStudentName];
                            [self.reading appendString:@","];
                            
                        }
                        else
                        {
                            [self.noReading appendString:info.replayStudentName];
                            [self.noReading appendString:@","];
                        }
                       
                      }
                     
                     if(self.agree.length>0)
                     {
                         self.agree = [[self.agree substringWithRange:NSMakeRange(0,[self.agree length]-1)] mutableCopy];
                         
                         [self.agree appendString:[NSString stringWithFormat:@"%d人已经回执",agree]];
                     }
                     if(self.noAgree.length>0)
                     {
                         self.noAgree = [[self.noAgree substringWithRange:NSMakeRange(0,[self.agree length]-1)] mutableCopy];
                         
                         [self.noAgree appendString:[NSString stringWithFormat:@"%d人未回执",(int)[self.noticieDetailsInfo.noticeDetailStatisticsInfoList count]-agree]];
                     }
                     if(self.reading.length>0)
                     {
                         self.reading = [[self.reading substringWithRange:NSMakeRange(0,[self.agree length]-1)] mutableCopy];
                         
                         [self.reading appendString:[NSString stringWithFormat:@"%d人已经阅读",read]];
                     }
                     if(self.noReading.length>0)
                     {
                         self.noReading = [[self.noReading substringWithRange:NSMakeRange(0,[self.agree length]-1)] mutableCopy];
                         
                         [self.noReading appendString:[NSString stringWithFormat:@"%d人未阅读",(int)[self.noticieDetailsInfo.noticeDetailStatisticsInfoList count]-read]];
                     }
                     
                     float agreeHeight = [self heightFromString:self.agree withFont:[UIFont fontWithName:@"HelveticaNeue" size:8]];
                     
                     float noAgreeHeight = [self heightFromString:self.noAgree withFont:[UIFont fontWithName:@"HelveticaNeue" size:8]];
                     [self.arrayForTabelCells addObject:@(agreeHeight+ noAgreeHeight)];
                     
                     float readHeight = [self heightFromString:self.reading withFont:[UIFont fontWithName:@"HelveticaNeue" size:8]];
                     
                     float noReadHeight = [self heightFromString:self.noReading withFont:[UIFont fontWithName:@"HelveticaNeue" size:8]];
                     [self.arrayForTabelCells addObject:@(readHeight+noReadHeight)];
                 }

           
                 [self.tabelView reloadData];
            
             }else{
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
             
             
         }
         
         
     }];

}

-(void)noticePardentReplay:(int)reply withPardentNoticeId:(NSString *)noticeId
{
    [ProgressHUD show:@"获取家长书详情....."];
    NSString *queryString = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%d",@"parentNoticeId",noticeId,USER_ID_KEY,@"4028af814ed340b3014ed3509558000d",@"isAgree",reply];
    
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CLASS_RELEASE_NOTICE_REPLY portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
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
             }else
             {
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
         }
     }];

}
#pragma mark  //根据字体 计算 内容高度

- (float)heightFromString:(NSString*)incomeStirng withFont :(UIFont*)font
{
    //[UIFont fontWithName:@"HelveticaNeue" size:14]
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGFloat width = Screen_Width - 16;//文本宽度
    CGRect rect = [incomeStirng boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
    return rect.size.height+20;
}

#pragma mark- Table view datasource and delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return  [self.arrayForTabelCells[indexPath.row] floatValue];
}

-(void)actionAgree:(id)sender
{
    [self noticePardentReplay:1 withPardentNoticeId:@"40288dea4ed36b89014ed36ece0d0001"];
}

-(void)actionNoAgree:(id)sender
{
    [self noticePardentReplay:0 withPardentNoticeId:@"40288dea4ed36b89014ed36ece0d0001"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        if (indexPath.row == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TITLE_CELL];
            
            UILabel * titleLabel = (UILabel*)[cell.contentView viewWithTag:2015];
            
            titleLabel.text = self.noticieDetailsInfo.noticeDetailTitle;

            return cell;
        }
        else if (indexPath.row == 1)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IMAGE_CELL];
            UIImageView *imageView = [cell.contentView.subviews lastObject];
            dispatch_async(kBgQueue, ^{
//                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.noticieDetailsInfo.noticeDetailImageUrl]];
//                UIImage *image = [UIImage imageWithData:imageData];
                UIImage *image = [UIImage imageNamed:@"AMeng"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    CGSize imageSize = image.size;
                    CGFloat newImageHeight = imageSize.height * (Screen_Width / imageSize.width);
                    if (image) {
                        self.arrayForTabelCells[1] = @(newImageHeight);
                    }
                    imageView.image = image;
                    [self.tabelView beginUpdates];
                    [self.tabelView endUpdates];
                
                });
                
            });
            
            return cell;
        }
        else if (indexPath.row ==2)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CONTENT_CELL];
            
            
            UITextView *contentTV = [cell.contentView.subviews lastObject];
            contentTV.text = self.noticieDetailsInfo.noticeDetailContent;
            return cell;
        }
        else if (indexPath.row == 3)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AGREE_CELL];
            
            UIButton *buttonAgree =(UIButton*)[cell.contentView viewWithTag:2015];
            
            [buttonAgree addTarget:self
                          action:@selector(actionAgree:)
                forControlEvents:UIControlEventTouchUpInside
             ];
            
            UIButton *buttonNoAgree =(UIButton*)[cell.contentView viewWithTag:2016];
            
            [buttonNoAgree addTarget:self
                            action:@selector(actionNoAgree:)
                  forControlEvents:UIControlEventTouchUpInside
             ];

            return cell;
        }
        else if (indexPath.row == 4)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:READ_CELL];
            
            UILabel * readLabel = (UILabel*)[cell.contentView viewWithTag:2015];
            
            [readLabel setText:self.reading];
            
            UILabel * noReadLabel = (UILabel*)[cell.contentView viewWithTag:2016];
            
            [noReadLabel setText:self.noReading];

            return cell;
        }
        else if (indexPath.row == 5)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REPLY_CELL];
            

            
            UILabel * agreeLabel = (UILabel*)[cell.contentView viewWithTag:2015];
            
            [agreeLabel setText:self.agree];
            
            UILabel * noAgreeLabel = (UILabel*)[cell.contentView viewWithTag:2016];
            
            [noAgreeLabel setText:self.noAgree];
            return cell;
        }
        return nil;
    
}


@end
