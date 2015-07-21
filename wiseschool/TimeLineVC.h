//
//  TimeLineVC.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *classViewHeight;
@property (strong, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) IBOutlet UIView *classView;

@property(nonatomic,weak)IBOutlet UILabel *lbName;
@property(nonatomic,weak)IBOutlet UILabel *lbClass;

@property(nonatomic,weak)IBOutlet UICollectionView *cvChirdens;
@property(nonatomic,weak)IBOutlet UITableView* tvComments;

@property (nonatomic, strong) UITableViewCell *prototypeCell; 

@property(nonatomic,strong) NSMutableArray *dataForComments;

@end
