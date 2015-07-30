//
//  CommentItemDTO.m
//  wiseschool
//
//  Created by BlueWind on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "CommentItemDTO.h"

@implementation CommentItemDTO

- (instancetype)initFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _commentName =[dictionary objectForKey:PERSON_NAME];
        
        _commentConten = [dictionary objectForKey:CONTENT];
        
        NSArray *images = [dictionary objectForKey:COMMENT_IMAGES];
        
        if(images==nil || images.count==0)
        {
            _whetherHaveImage = NO;
        }else
            _whetherHaveImage =YES;
    }
    return self;
}

-(int)heightForCellwithWidth:(int)width withFont:(UIFont*)font
{
    int height = 0;
    
    NSDictionary *dicMessage=@{NSFontAttributeName :font};
    CGSize size =[_commentConten  boundingRectWithSize:CGSizeMake(width,MAXFLOAT ) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicMessage context:nil].size;
    if(size.height>30)
        height=size.height +36;
    else height = 66;
    return height;
}

@end
