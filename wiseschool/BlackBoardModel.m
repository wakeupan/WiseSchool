//
//  BlackBoardModel.m
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BlackBoardModel.h"

@implementation BlackBoardModel
- (instancetype)initWith:(NSIndexPath *)indexPath
                andTitle:(NSString *)title
              andContent:(NSString *)content
                andImage:(UIImage *)image
                    mode:(UIViewContentMode)mode
{
    self = [super init];
    if (self) {
        _indexPath = indexPath;
        _title = title;
        _content = content;
        _image = image;
       // _mode = UIViewContentModeScaleAspectFill;
    }
    return self;
}
@end
