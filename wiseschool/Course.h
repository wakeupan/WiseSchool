//
//  Course.h
//  WiseSchool
//
//  Created by 张宝 on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property(nonatomic,strong) NSString *courseName;
@property(nonatomic) BOOL selected;

- (instancetype)initWith:(NSString*)name selected:(BOOL)isSelected;

@end
