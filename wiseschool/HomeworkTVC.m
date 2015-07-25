//
//  HomeworkTVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "HomeworkTVC.h"
#import "HttpManager.h"
#import "CommonConstants.h"
#import "Course.h"

@interface HomeworkTVC ()
<UICollectionViewDataSource,
UIBarPositioningDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *coursesArray;
@end

@implementation HomeworkTVC

#define CourseNameCellID @"CourseNameCell"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchSubjectInfo];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.coursesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CourseNameCellID forIndexPath:indexPath];
    UILabel *lable = [cell.contentView.subviews lastObject];
    Course *course = self.coursesArray[indexPath.row];
    lable.text = course.courseName;
    if (course.selected) {
        lable.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1];
        cell.layer.borderWidth = 0;
        
    }else{
        lable.textColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.borderColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1].CGColor;
        cell.layer.borderWidth = 1;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *lable = [cell.contentView.subviews lastObject];
    Course *selectedModel = self.coursesArray[indexPath.row];
    if (!selectedModel.selected) {
        lable.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1];
        cell.layer.borderWidth = 0;
        selectedModel.selected = YES;
    }else{
        lable.textColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.borderColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1].CGColor;
        cell.layer.borderWidth = 1;
        selectedModel.selected = NO;
    }
    
    
}

- (NSMutableArray *)coursesArray
{
    if (!_coursesArray) {
        _coursesArray = [NSMutableArray new];
    }
    return _coursesArray;
}

#pragma mark- 获取科目
- (void)fetchSubjectInfo
{
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_LOGIN_GET_SUBJECT_INFO portID:8080 queryString:@"" callBack:^(NSDictionary* jsonData, NSError *error) {
        if (jsonData) {
            NSArray *subjects = jsonData[@"data"];
            for (NSDictionary *subject in subjects){
                Course *course = [[Course alloc] initWith:subject[@"subjectName"] selected:NO];
                [self.coursesArray addObject:course];
            }
            [self.collectionView reloadData];
        }
    }];
}

@end
