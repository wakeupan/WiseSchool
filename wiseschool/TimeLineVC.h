//
//  TimeLineVC.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommentTableViewCell.h"



@interface TimeLineVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CustomCellDelegateOfClick,UIActionSheetDelegate,UIAlertViewDelegate,
UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *classViewHeight;
@property (strong, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) IBOutlet UIView *classView;

@property(nonatomic,weak)IBOutlet UILabel *lbName;
@property(nonatomic,weak)IBOutlet UILabel *lbClass;

@property(nonatomic,weak)IBOutlet UICollectionView *cvChirdens;
@property(nonatomic,weak)IBOutlet UITableView* tvComments;

@property (nonatomic, strong) CommentTableViewCell *prototypeCell;

@property (nonatomic, strong) NSMutableArray *dataForChirden;

@property(nonatomic,strong) NSMutableArray *dataForComments;

@property (strong,nonatomic) UITapGestureRecognizer *tap;

@property (nonatomic) BOOL imageSelected;

@property (nonatomic) int sendIndex;

@property (nonatomic, strong) NSString *homeVisitID;

@property (nonatomic, strong) NSString *studentID;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomDistance;

@property (weak, nonatomic) IBOutlet UIButton *sendContentBtn;
- (IBAction)actionSendContent:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *sendContentView;
@property (weak, nonatomic) IBOutlet UIImageView *takePhotoImageView;
@property (weak, nonatomic) IBOutlet UITextField *sendContentTxt;
@end
