//
//  ImageCell.h
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlackBoardModel.h"

@protocol ImageCellDelegate <NSObject>

- (void)pickeImageAt:(NSIndexPath*)indexPath withOrignal:(UIImageView*)imageView;

@end

@interface ImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *paraImageView;
@property (nonatomic,strong) BlackBoardModel *model;
@property (nonatomic,weak) id<ImageCellDelegate> delegate;

@end
