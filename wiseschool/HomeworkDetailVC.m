//
//  HomeworkDetailVC.m
//  wiseschool
//
//  Created by 张宝 on 15/7/25.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "HomeworkDetailVC.h"
#import "HttpManager.h"
#import "CommonConstants.h"

@interface HomeworkDetailVC ()
<UITableViewDataSource,
UIAccelerometerDelegate>
@property (weak, nonatomic) IBOutlet UIView *tableHeader;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation HomeworkDetailVC

#define CommentsCellID @"CommentCell"

- (void)viewDidLoad{
    [super viewDidLoad];
    [self fetchHomeworkDetail];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:CommentsCellID];
}

- (IBAction)grow:(id)sender {
    CGRect orignalRect = self.tableHeader.frame;
    CGRect newRect = CGRectMake(orignalRect.origin.x, orignalRect.origin.y, orignalRect.size.width, orignalRect.size.height + 100);
    self.tableHeader.frame = newRect;
    [self.view layoutSubviews];
    [self.tableView reloadData];
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define testImage @"http://pic1a.nipic.com/2008-12-04/2008124215522671_2.jpg"
- (void)fetchHomeworkDetail
{
    [ProgressHUD show:@"获取家庭作业详情中..."];
    NSString *param = [NSString stringWithFormat:@"homeworkId=%@",self.homeworkID];
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:@"zhxy_v3_java/app/homework/homeworkDetail.app" portID:8080 queryString:param callBack:^(NSDictionary* jsonData, NSError *error) {
        [ProgressHUD dismiss];
        NSArray *array = jsonData[@"data"];
        NSDictionary *dicionary = [array lastObject];
        
        self.titleLabel.text = dicionary[@"title"];
        self.contentTextView.text = dicionary[@"content"];
        dispatch_async(kBgQueue, ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:testImage]];
            UIImage *image = [UIImage imageWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
            
        });
    }];
}

@end
