//
//  BlackBoardModel.h
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BlackBoardModel : NSObject

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) UIImage  *image;

- (instancetype)initWith:(NSIndexPath*)indexPath andTitle:(NSString*)title andContent:(NSString*)content andImage:(UIImage*)image;
@end
