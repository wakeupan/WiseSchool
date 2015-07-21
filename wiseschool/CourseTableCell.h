//
//  CourseTableCell.h
//  WiseSchool
//
//  Created by 张宝 on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderBtn.h"
#import "CourseTable.h"

@protocol CourseTableCellDelegate <NSObject>

- (void)addCourseAt:(NSInteger)cellIndex courseIndex:(NSInteger)index;

@end

@interface CourseTableCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet BorderBtn *dayBtn;
@property (strong, nonatomic) IBOutletCollection(BorderBtn) NSArray *courses;
@property (strong, nonatomic) CourseTable *courseTable;
@property (nonatomic) NSInteger cellIndex;

@property id<CourseTableCellDelegate> delegate;

@end
