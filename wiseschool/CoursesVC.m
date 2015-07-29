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

#import "CommonConstants.h"

#import "HttpManager.h"

@interface CoursesVC ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
CourseTableCellDelegate,
UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (nonatomic, strong) NSMutableArray *coursesTableArray;
@property (nonatomic, strong) NSMutableArray *coursesArray;

@property (nonatomic, strong) NSIndexPath *formerSelectedIndexPath;
@property (nonatomic, strong) Course *addedCoursre;

@end

@implementation CoursesVC
#define TopCellID @"CourseCell"
#define BottomCellID @"BottomCourseCell"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFakeData];
    self.formerSelectedIndexPath = nil;
}
- (IBAction)saveCourseTable:(UIBarButtonItem *)sender
{
    [self saveCourse];
}

- (IBAction)actionAddCourseItem {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入科目名称"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
         UITextField *textField = [alertView textFieldAtIndex:0];
        if (textField.text.length > 0) {
            Course *course = [[Course alloc] initWith:textField.text selected:NO];
            self.addedCoursre = course;
            [self createCourseItem:textField.text];
        }
    }
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
    [self fetchSubjectInfo];
    [self requestCourseinfo];
//    CourseTable *Monday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期一",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
//    CourseTable *Tuesday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期二",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
//    CourseTable *Wenseday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期三",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
//    CourseTable *Thurseday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期四",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
//    CourseTable *Friday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期五",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
//    
//    CourseTable *Saturday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期六",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
//    CourseTable *Sunday = [[CourseTable alloc] initFromDictionary:@{@"day":@"星期天",@"courses":@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]}];
//    
//    [self.coursesTableArray addObjectsFromArray:@[Monday,Tuesday,Wenseday,Thurseday,Friday,Saturday,Sunday]];
    
//    Course *math = [[Course alloc] initWith:@"数学" selected:NO];
//    Course *art = [[Course alloc] initWith:@"美术" selected:NO];
//    Course *english = [[Course alloc] initWith:@"英语" selected:NO];
//    Course *pe = [[Course alloc] initWith:@"体育" selected:NO];
//    Course *music = [[Course alloc] initWith:@"音乐" selected:NO];
//    Course *chemestry = [[Course alloc] initWith:@"化学" selected:NO];
//    Course *physicy = [[Course alloc] initWith:@"物理" selected:NO];
//    Course *chinese = [[Course alloc] initWith:@"语文" selected:NO];
//    [self.coursesArray addObjectsFromArray:@[math,art,english,pe,music,chemestry,physicy,chinese]];
    
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

#pragma mark- 添加科目
-(void)createCourseItem:(NSString*)courseName
{
    [ProgressHUD show:@"添加课程中..."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    NSString *queryString =[NSString stringWithFormat:@"%@=%@&%@=%@",USER_ID_KEY,USER_ID_VALUE,@"subjectName",courseName];
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CLASS_CREATE_COURSE portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         if(jsonData !=nil)
         {
             [ProgressHUD dismiss];
             NSArray* arr = [jsonData allKeys];
             for(NSString* str in arr)
             {
                 NSLog(@"%@=%@", str,[jsonData objectForKey:str]);
             }
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 if (self.addedCoursre) {
                     [self.coursesArray addObject:self.addedCoursre];
                     [self.collectionView reloadData];
                     NSIndexPath *temp = [NSIndexPath indexPathForRow:self.coursesArray.count-1 inSection:0];
                     [self.collectionView scrollToItemAtIndexPath:temp atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
                 }
             }else{
                 [ProgressHUD showError:@"添加课程失败！"];
             }
         }else{
             [ProgressHUD showError:[error localizedDescription]];
         }
         
         
     }];

}

#pragma mark- 保存课表
-(void)saveCourse
{
    [ProgressHUD show:@"上传课表中..."];
    NSError *error;
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
    paramDic[CLASS_ID_KEY] = CLASS_ID_VALUE;
    paramDic[USER_ID_KEY] = USER_ID_VALUE;
    NSMutableArray *coursesArray = [NSMutableArray new];
    for (CourseTable *day in self.coursesTableArray){
        NSMutableDictionary *dayDictionary = [NSMutableDictionary new];
        dayDictionary[@"week"] = [[self class] dayIndex:day.day];
        for (int i = 0; i < day.courses.count; i++) {
            NSString *courseNameValue = day.courses[i];
            NSString *courseNameKey = [NSString stringWithFormat:@"lesson%d",i+1];
            dayDictionary[courseNameKey] = courseNameValue;
        }
        [coursesArray addObject:dayDictionary];
    }
    paramDic[@"data"] = coursesArray;
    
   
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    NSString *queryString =[NSString stringWithFormat:@"%@=%@",@"courseData",jsonString];
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CLASS_SET_COURSE portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         if(jsonData !=nil)
         {
             [ProgressHUD showSuccess:@"上传课表成功！"];
         }else{
             [ProgressHUD showError:@"创建课表失败！"];
         }
         
         
     }];
    
}

#pragma mark -获取课表
-(void)requestCourseinfo
{
    [ProgressHUD show:@"获取课程信息中..."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    NSString *queryString =[NSString stringWithFormat:@"%@=%@",CLASS_ID_KEY,CLASS_ID_VALUE];
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CLASS_GET_COURSE_INFO portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         if(jsonData !=nil)
         {
             [ProgressHUD dismiss];
             NSArray* arr = [jsonData allKeys];
             for(NSString* str in arr)
             {
                 NSLog(@"%@=%@", str,[jsonData objectForKey:str]);
             }
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 NSMutableArray *data = [[jsonData objectForKey:@"data"] mutableCopy];//根数组
                 NSMutableDictionary * dic = [[data objectAtIndex:0] mutableCopy];//字典
                 
                 NSMutableArray *courseDatas = [[dic objectForKey:@"data"]mutableCopy];//课程数组（day1、day2、day...)
                 
                 for(int i=0;i<courseDatas.count;i++)
                 {
                     NSDictionary * courseDic =[courseDatas objectAtIndex:i];
                     NSString *dayString = [[self class] daysArray][i];
                      CourseTable *day = [[CourseTable alloc] initFromDictionary:@{@"day":dayString,@"courses":@[courseDic[@"lesson1"],courseDic[@"lesson2"],courseDic[@"lesson3"],courseDic[@"lesson4"],courseDic[@"lesson5"],courseDic[@"lesson6"],courseDic[@"lesson7"],courseDic[@"lesson8"],courseDic[@"lesson9"],courseDic[@"lesson10"]]}];
                     [self.coursesTableArray addObject:day];
                     
                 }
                 [self.bottomCollectionView reloadData];
                 
             }else{
                 [ProgressHUD showError:@"没有课程信息！"];
             }
         }else{
             [ProgressHUD showError:[error localizedDescription]];
         }
         
         
     }];
}



+ (NSArray*)daysArray
{
    return @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
}

+ (NSString*)dayIndex:(NSString*)incomeDayString
{
    NSInteger index = [[[self class] daysArray] indexOfObject:incomeDayString];
    return [NSString stringWithFormat:@"%d",index+1];
}
@end
