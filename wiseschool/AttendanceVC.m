//
//  AttendanceVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "AttendanceVC.h"
#import "AttendanceCell.h"
#import "ImageUrls.h"

@interface AttendanceVC ()
<UITableViewDataSource,
UITableViewDelegate,
AttendanceCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic,strong) NSMutableDictionary *contactsDictionary;
@property (nonatomic) NSInteger totalContacts;
@property (nonatomic) NSInteger onTimeContacts;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation AttendanceVC

#define AttendanceCellID @"AttendanceCell"

- (IBAction)reCheck {
    self.dateLabel.text = [self currentDateString];
    for (NSString* key in self.indexArray){
        for (User *user in self.contactsDictionary[key]){
            user.marked = NO;
            user.onTime = NO;
        }
    }
    [self updateResults];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self initFakeData];
}

- (void)markedAsOnTime:(BOOL)onTime at:(NSIndexPath *)indexPath
{
    NSArray *items = self.contactsDictionary[self.indexArray[indexPath.section]];
    User *model = items[indexPath.row];
    model.marked = YES;
    model.onTime = onTime;
    [self updateResults];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *items = self.contactsDictionary[self.indexArray[section]];
    return items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.indexArray[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}
//建立索引栏和section的关联
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.indexArray indexOfObject:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttendanceCell *cell = [tableView dequeueReusableCellWithIdentifier:AttendanceCellID];
    NSArray *items = self.contactsDictionary[self.indexArray[indexPath.section]];
    User *user = items[indexPath.row];
    cell.user = user;
    cell.delegate = self;
    cell.indexPath= indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count;
}

- (NSMutableArray *)indexArray
{
    if (!_indexArray) {
        _indexArray = [[NSMutableArray alloc] init];
    }
    return _indexArray;
}

- (NSMutableDictionary *)contactsDictionary
{
    if (!_contactsDictionary) {
        _contactsDictionary = [[NSMutableDictionary alloc] init];
    }
    return _contactsDictionary;
}

- (void)initFakeData
{
    NSMutableArray *contactsArray = [NSMutableArray new];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"whatya",@"iconUrl":image1,@"studentOrTeacher":@"班主任",@"incheckOrManager":@"语文老师"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"蓝胖子",@"iconUrl":image2,@"studentOrTeacher":@"管理员",@"incheckOrManager":@"数学老师"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"王大",@"iconUrl":image3,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"李老板",@"iconUrl":image4,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"潘大神",@"iconUrl":image5,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"阿三",@"iconUrl":image6,@"studentOrTeacher":@"审核中",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"嘀嗒",@"iconUrl":image7,@"studentOrTeacher":@"审核中",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"李荣浩",@"iconUrl":image8,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"华仔",@"iconUrl":image9,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"苏菲",@"iconUrl":image10,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"whatya",@"iconUrl":image1,@"studentOrTeacher":@"班主任",@"incheckOrManager":@"语文老师"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"蓝胖子",@"iconUrl":image2,@"studentOrTeacher":@"管理员",@"incheckOrManager":@"数学老师"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"王大",@"iconUrl":image3,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"李老板",@"iconUrl":image4,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"潘大神",@"iconUrl":image5,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"阿三",@"iconUrl":image6,@"studentOrTeacher":@"审核中",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"嘀嗒",@"iconUrl":image7,@"studentOrTeacher":@"审核中",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"李荣浩",@"iconUrl":image8,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"华仔",@"iconUrl":image9,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"苏菲",@"iconUrl":image10,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"whatya",@"iconUrl":image1,@"studentOrTeacher":@"班主任",@"incheckOrManager":@"语文老师"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"蓝胖子",@"iconUrl":image2,@"studentOrTeacher":@"管理员",@"incheckOrManager":@"数学老师"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"王大",@"iconUrl":image3,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"李老板",@"iconUrl":image4,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"潘大神",@"iconUrl":image5,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"阿三",@"iconUrl":image6,@"studentOrTeacher":@"审核中",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"嘀嗒",@"iconUrl":image7,@"studentOrTeacher":@"审核中",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"李荣浩",@"iconUrl":image8,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"华仔",@"iconUrl":image9,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    [contactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"苏菲",@"iconUrl":image10,@"studentOrTeacher":@"",@"incheckOrManager":@"学生"}]];
    
    for (User *user in contactsArray){
        NSString* index = [self firstLetter:user.username];
        if (![self.indexArray containsObject:index]) {
            [self.indexArray addObject:index];
        }
        NSMutableArray *items = self.contactsDictionary[index];
        if (items) {
            [items addObject:user];
        }else{
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            [temp addObject:user];
            self.contactsDictionary[index] = temp;
        }
    }
    [self.indexArray sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    self.dateLabel.text = [self currentDateString];
    [self updateResults];
}

- (NSString*)firstLetter:(NSString*)inComingString
{
    NSMutableString *ms = [[NSMutableString alloc] initWithString:inComingString];
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
    return [[ms substringToIndex:1] uppercaseString];
}

- (void)updateResults
{
    self.totalContacts = 0;
    self.onTimeContacts = 0;
    for (NSString* key in self.indexArray){
        for (User *user in self.contactsDictionary[key]){
            self.totalContacts ++;
            if (user.onTime) {
                self.onTimeContacts++;
            }
        }
    }
    
    self.resultLabel.text = [NSString stringWithFormat:@"应到%d人，实到%d人，未到%d人",self.totalContacts,self.onTimeContacts,self.totalContacts-self.onTimeContacts];
    
}

- (NSString*)currentDateString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [df stringFromDate:date];
}

@end
