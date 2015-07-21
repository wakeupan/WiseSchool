//
//  CourseTableCell.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "CourseTableCell.h"

@implementation CourseTableCell

- (void)setCourseTable:(CourseTable *)courseTable
{
    _courseTable = courseTable;
    [self.dayBtn setTitle:courseTable.day forState:UIControlStateNormal];
    for (int i = 0; i < courseTable.courses.count; i++) {
        UIButton *course = self.courses[i];
        NSString *courseString = courseTable.courses[i];
        [course setTitle:courseString forState:UIControlStateNormal];
    }
}

- (IBAction)addCourse:(BorderBtn *)sender
{
    NSInteger index = [self.courses indexOfObject:sender];
    [self.delegate addCourseAt:self.cellIndex courseIndex:index];
}


@end
