//
//  BBModel.h
//  wiseschool
//
//  Created by 张宝 on 15/7/30.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *bbID;
@property (nonatomic,strong) NSIndexPath *indexpath;
@property (nonatomic) BOOL opened;
@end
