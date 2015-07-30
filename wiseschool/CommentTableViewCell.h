//
//  CommentTableViewCell.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommentDTO.h"
@protocol CustomCellDelegateOfClick<NSObject>

-(void)delegateAddComment:(NSIndexPath*)indexPath;

@end
@interface CommentTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)IBOutlet    UIImageView  *icon;
@property (weak, nonatomic) IBOutlet UITableView  *contentTB;
@property(nonatomic,weak)IBOutlet    UIButton     *btn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,strong)NSMutableArray *souceData;

@property(nonatomic,strong)NSString *titleContent;

@property(nonatomic,weak)NSIndexPath *indexPath;

@property(nonatomic,weak) id<CustomCellDelegateOfClick> delegate;

- (IBAction)actionAddComment:(id)sender;

-(void)loadDataFromNib:(CommentDTO *)data;

-(int)heightForCell:(CommentDTO *)data;
@end



