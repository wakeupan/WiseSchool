//
//  CommentTableViewCell.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "CommentTableViewCell.h"

#import "UIImageView+EMWebCache.h"

#import "CommonConstants.h"

#import "CommentItemCellTableViewCell.h"

#import "CommentItemDTO.h"

#import "CommentsData.h"

@implementation CommentTableViewCell

- (void)awakeFromNib
{
    UINib *commentCellnib  = [UINib nibWithNibName:@"CommentItemCellTableViewCell" bundle:nil];
    [self.contentTB  registerNib:commentCellnib forCellReuseIdentifier:@"commentItemCell"];
    self.icon.layer.cornerRadius = 30.0;
    self.icon.clipsToBounds = YES;
    self.icon.layer.borderColor = [UIColor whiteColor].CGColor;
    self.icon.layer.borderWidth = 3.0;
    
    self.contentTB.delegate   =self;
    
    self.contentTB.dataSource =self;
}

- (IBAction)actionAddComment:(id)sender
{
    [self.delegate delegateAddComment:self.indexPath];
    
    
}

-(void)loadDataFromNib:(CommentDTO *)data
{
    
    self.titleLabel.text = data.content;
    if(data.homeVisitImages.count>0)
    {
        NSString *url =data.homeVisitImages[0][@"sourceUrl"];
        [self.icon sd_setImageWithURL:URL(url) placeholderImage:[UIImage imageNamed:@"AMeng"]];
    }
    if(data.commentInfos.count>0)
    {
      self.souceData = data.commentInfos;
      self.titleContent = data.content;
      [self.contentTB reloadData];
    }else
    {
       // [self.contentTB setHidden:YES];
    }
    
}
-(int)getHeightForFont:(UIFont*)font withContent:(NSString*)content withWidth:(int)width
{
    NSDictionary *dicMessage=@{NSFontAttributeName :font};
    CGSize size =[content  boundingRectWithSize:CGSizeMake(width,MAXFLOAT ) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicMessage context:nil].size;
    
    return size.height;
}
-(int)heightForCell:(CommentDTO *)data
{
    int height = 0;
    if(data!=nil)
    {
        CommentItemCellTableViewCell *cell =[[CommentItemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"commentItemCell"];
        for(CommentItemDTO *item in data.commentInfos)
        {
            height +=[item heightForCellwithWidth:Screen_Width-120 withFont:cell.commentContentLabel.font];
        }
    }
    return height;
}

#pragma mark- UITableView delegate methods
//一共有多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//第section分区一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.souceData.count;
    
    return 3;
}

//创建第section分区第row行的UITableViewCell对象(indexPath包含了section和row)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentItemCellTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"commentItemCell"];

    //CommentItemDTO *dto =[self.souceData objectAtIndex:indexPath.row];
    
    CommentItemDTO *dto =[[CommentItemDTO alloc]init];
    dto.commentName = @"wakeup";
    dto.commentConten= @"xafasfasfhoifaixafasfasfhoifaixafasfasfhoifai";
    dto.whetherHaveImage= YES;
    
    [cell setData:dto];
    return cell;
}

//第section分区的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    UIView *v_headerView = [[[UINib nibWithNibName:@"CommentItemHeadView" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
//    
//    UILabel *titleLb =(UILabel*)[v_headerView viewWithTag:100];
//   //CommentsData *dataSource = [dataForComments objectAtIndex:section];
//    [titleLb setText:self.titleContent];
//    
//    
//    //    UIButton *btnPlus = (UIButton*)[v_headerView viewWithTag:20001];
//    
//    return v_headerView;
//}
//第section分区的底部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

//选中了UITableView的某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//某一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentItemCellTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"commentItemCell"];
//

////    CommentItemDTO *dto =[self.souceData objectAtIndex:indexPath.row];
//    
    CommentItemDTO *dto =[[CommentItemDTO alloc]init];
    dto.commentName = @"wakeup";
    dto.commentConten= @"xafasfasfhoifaixafasfasfhoifaixafasfasfhoifai";
    dto.whetherHaveImage= YES;
    
    [cell setData:dto];
    
    return [dto heightForCellwithWidth:Screen_Width-120 withFont:cell.commentContentLabel.font];


}

@end
