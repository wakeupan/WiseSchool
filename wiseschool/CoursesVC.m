//
//  CoursesVC.m
//  WiseSchool
//
//  Created by itours on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "CoursesVC.h"
#import "CourseTableCell.h"
#import "CourseTable.h"
#import "Course.h"

@interface CoursesVC ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
CourseTableCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (nonatomic, strong) NSMutableArray *coursesTableArray;
@property (nonatomic, strong) NSMutableArray *coursesArray;

@property (nonatomic, strong) NSIndexPath *formerSelectedIndexPath;

@end

@implementation CoursesVC
#define TopCellID @"CourseCell"
#define BottomCellID @"BottomCourseCell"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFakeData];
    self.formerSelectedIndexPath = nil;
}

- (void)addCourseAt:(NSInteger)cellIndex courseIndex:(NSInteger)index
{
    if (!self.formerSelectedIndexPath) {
        return;
    }
    CourseTable *table = self.coursesTableArray[cellIndex];
    NSMutableArray *courses = table.courses;
    Course *selectedCourse = self.coursesArray[self.formerSelectedIndexPath.row];
    NSString *formerCourse = courses[index];
    if ([formerCourse isEqualToString:selectedCourse.courseName]) {
        courses[index] = @"";
    }else{
        courses[index] = selectedCourse.courseName;
    }
    [self.bottomCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:cellIndex inSection:0]]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        UIButton *btn = [cell.contentView.subviews lastObject];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:235/255.0 green:185/255.0 blue:95/255.0 alpha:1]];
        
        if (self.formerSelectedIndexPath) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.formerSelectedIndexPath];
            UIButton *btn = [cell.contentView.subviews lastObject];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
        self.formerSelectedIndexPath = indexPath;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionView]) {
        return self.coursesArray.count;
    }else{
        return self.coursesTableArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if ([collectionView isEqual:self.collectionView]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopCellID forIndexPath:indexPath];
        UIButton *btn = [cell.contentView.subviews lastObject];
        Course *course = self.coursesArray[indexPath.row];
        [btn setTitle:course.courseName forState:UIControlStateNormal];
        
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BottomCellID forIndexPath:indexPath];
        CourseTableCell *temp = (CourseTableCell*)cell;
        CourseTable *table = self.coursesTableArray[indexPath.row];
        temp.courseTable = table;
        temp.cellIndex = indexPath.row;
        temp.delegate = self;
    }
   
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        return CGSizeMake(50, 30);
    }else{
        CGFloat screenWidth = self.view.bounds.size.width;
        return CGSizeMake(screenWidth, 60);
    }
    
}

- (NSMutableArray *)coursesTableArray
{
    if (!_coursesTableArray) {
        _coursesTableArray = [[NSMutableArray alloc] init];
    }
    return _coursesTableArray;
}

- (NSMutableArray *)coursesArray
{
    if (!_coursesArray) {
        _coursesArray = [[NSMutableArray alloc] init];
    }
    return _coursesArray;
}

- (void)initFakeData
{
    CourseTable *Monday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期一",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
    CourseTable *Tuesday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期二",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
    CourseTable *Wenseday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期三",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
    CourseTable *Thurseday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期四",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
    CourseTable *Friday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期五",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
    
    CourseTable *Saturday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期六",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
    CourseTable *Sunday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期天",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
    
    [self.coursesTableArray addObjectsFromArray:@[Monday,Tuesday,Wenseday,Thurseday,Friday,Saturday,Sunday]];
    
    Course *math = [[Course alloc] initWith:@"数学" selected:NO];
    Course *art = [[Course alloc] initWith:@"美术" selected:NO];
    Course *english = [[Course alloc] initWith:@"英语" selected:NO];
    Course *pe = [[Course alloc] initWith:@"体育" selected:NO];
    Course *music = [[Course alloc] initWith:@"音乐" selected:NO];
    Course *chemestry = [[Course alloc] initWith:@"化学" selected:NO];
    Course *physicy = [[Course alloc] initWith:@"物理" selected:NO];
    Course *chinese = [[Course alloc] initWith:@"语文" selected:NO];
    [self.coursesArray addObjectsFromArray:@[math,art,english,pe,music,chemestry,physicy,chinese]];
    
}

@end
