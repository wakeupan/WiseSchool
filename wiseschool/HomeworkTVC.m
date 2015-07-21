//
//  HomeworkTVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "HomeworkTVC.h"

@interface HomeworkTVC ()
<UICollectionViewDataSource,
UIBarPositioningDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation HomeworkTVC

#define CourseNameCellID @"CourseNameCell"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.clipsToBounds = YES;
    self.textView.layer.cornerRadius = 4.0;
    self.textView.layer.borderColor = [UIColor colorWithRed:230/255.0
                                                      green:230/255.0
                                                       blue:230/255.0
                                                      alpha:1].CGColor;
    self.textView.layer.borderWidth = 1.0;
   

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CourseNameCellID forIndexPath:indexPath];
    return cell;
}

@end
