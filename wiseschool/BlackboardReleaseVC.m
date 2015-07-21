//
//  BlackboardReleaseVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BlackboardReleaseVC.h"

@interface BlackboardReleaseVC ()
<UITableViewDataSource,
UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger paragraphCount;
@end

@implementation BlackboardReleaseVC
#define TitleCellID @"TitleCell"
#define ContentCellID @"ContentCell"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paragraphCount = 2;
}
- (IBAction)addParagraph:(UIButton *)sender
{
    self.paragraphCount += 2;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paragraphCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row % 2 == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:TitleCellID];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:ContentCellID];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return 40;
    }else{
        return 120;
    }
}

@end
