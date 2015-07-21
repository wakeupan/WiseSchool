//
//  TimeLineVC.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "TimeLineVC.h"
#import "CommentDTO.h"
#import "CommentsData.h"
#import "CommentTableViewCell.h"
#import "CommonConstants.h"

@implementation TimeLineVC


@synthesize lbClass;
@synthesize lbName;
@synthesize cvChirdens;
@synthesize tvComments;
@synthesize dataForComments;
@synthesize prototypeCell;

#pragma mark -lifecyle for controller
-(void)viewDidLoad
{
    [super viewDidLoad];
    dataForComments          =   [[NSMutableArray alloc]init];
    tvComments.delegate     =  self;
    dataForComments = [[NSMutableArray alloc]init];
    CommentDTO *data1= [[CommentDTO alloc]init];
    
    self.nameViewHeight.constant    = 0;
    self.classViewHeight.constant    = 0;
    
    self.classView.hidden=YES;
    self.nameView.hidden  =YES;
    data1.content =@"Jannina W也很想讓大家聽到自己的歌聲，因此都會在Youtube上和網友分享自己的歌唱影片，她翻唱很多不同語言的歌曲，英文、泰文、越南文甚至中文都有，她的夢想是成為一個著名的歌手。原文網址: 德泰混血雪精靈JannineW　翻唱See You Again超催淚 | ETtoday網搜新聞 | ETtoday 新聞雲 http://www.ettoday.net/news/20150706/530824.htm#ixzz3fMd4KMH5Follow us: @ETtodaynet on Twitter | ETtoday on Facebook";
    
    CommentDTO *data2= [[CommentDTO alloc]init];
    data2.content =@"翻唱See You Again超催淚 | ETtoday網搜新聞 | ETtoday 新聞雲 http://www.ettoday.net/news/20150706/530824.htm#ixzz3fMd4KMH5Follow us: @ETtodaynet on Twitter";
    
    CommentDTO *data3= [[CommentDTO alloc]init];
    data3.content =@"翻唱See You Again超催淚 | ETtoday網搜新聞 | ETtoday 新聞雲 http://www.ettoday.net/news/20150706/530824.htm#ixzz3fMd4KMH5Follow us: @ETtodaynet on Twitter";
    NSMutableArray *dtoData =[[NSMutableArray alloc]init];
    [dtoData addObject:data1];
    [dtoData addObject:data2];
    [dtoData addObject:data3];
    
    CommentsData *dataSource1= [[CommentsData alloc]init];
    dataSource1.commentArray =dtoData;
    dataSource1.commentsHead =@"2015年下学期";
    
    CommentsData *dataSource2= [[CommentsData alloc]init];
    dataSource2.commentArray =dtoData;
    dataSource2.commentsHead =@"2015年上学期";
    
    [dataForComments addObject:dataSource1];
    [dataForComments addObject:dataSource2];
    
    tvComments.dataSource  =self;
    tvComments.delegate      = self;
    
    cvChirdens.dataSource = self ;
    cvChirdens.delegate     =  self ;
    
    UINib *commentCellnib  = [UINib nibWithNibName:@"Comments" bundle:nil];
    [tvComments registerNib:commentCellnib forCellReuseIdentifier:@"commentCell"];
    
    prototypeCell  = [tvComments dequeueReusableCellWithIdentifier:@"commentCell"];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

#pragma mark- UITableView delegate methods
//一共有多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataForComments.count;
}

//第section分区一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CommentsData *dataSource = [dataForComments objectAtIndex:section];
    return dataSource.commentArray.count;
}

//创建第section分区第row行的UITableViewCell对象(indexPath包含了section和row)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell =[tvComments dequeueReusableCellWithIdentifier:@"commentCell"];
    
    if(cell==nil)
    {
        cell =[[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"commentCell"];
    }
    CommentsData *dataSource = [dataForComments objectAtIndex:indexPath.section];
    CommentDTO *data = [dataSource.commentArray objectAtIndex:indexPath.row];
    
    UIImageView *image =(UIImageView *)[cell viewWithTag:10002];
    image.layer.cornerRadius = 30;
    image.clipsToBounds = YES;
    cell.content.text=data.content ;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];

    return cell;
}

//第section分区的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

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
    
    CommentTableViewCell *cell =[tvComments dequeueReusableCellWithIdentifier:@"commentCell"];
    
    if(cell==nil)
    {
        cell =[[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"commentCell"];
    }
    
    CommentsData *dataSource = [dataForComments objectAtIndex:indexPath.section];
    CommentDTO *data = [dataSource.commentArray objectAtIndex:indexPath.row];
    cell.content.text=data.content ;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    NSDictionary *dicMessage=@{NSFontAttributeName :cell.content.font};
     CGSize size =[data.content  boundingRectWithSize:CGSizeMake(Screen_Width-120,MAXFLOAT ) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicMessage context:nil].size;
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"h=%f", size.height );
    return 66+21+size.height;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

//第section分区头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

//第section分区尾部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

//第section分区头部显示的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
     UIView *v_headerView = [[[UINib nibWithNibName:@"CommentHeadView" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    UILabel *titleLb =(UILabel*)[v_headerView viewWithTag:20001];
    CommentsData *dataSource = [dataForComments objectAtIndex:section];
    [titleLb setText:dataSource.commentsHead];
    
    
//    UIButton *btnPlus = (UIButton*)[v_headerView viewWithTag:20001];
    
    return v_headerView;
}

//第section分区尾部显示的视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - UIConnectionView delegate methods
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ChirdenCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *image =(UIImageView *)[cell viewWithTag:10001];
    image.layer.cornerRadius = 48;
    image.clipsToBounds = YES;
    
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(100, 100);
//}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
