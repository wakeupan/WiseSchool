//
//  MainVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/3.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "MainVC.h"
#import "ContainerViewController.h"
#import "CommonConstants.h"
#import "LoginOneVCViewController.h"
@interface MainVC ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topButtons;
@property (strong, nonatomic) NSArray *childVCS;
@end

@implementation MainVC

#define BaseTag 1973

#pragma mark- VC lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self switchVC:self.topButtons[0]];
    ContainerViewController *containerVC = (ContainerViewController*)self.parentViewController.parentViewController;
    containerVC.mainVC = self;
}

- (void)performLogin
{
    [self tootgleMenu:nil];
    LoginOneVCViewController *login1= [[LoginOneVCViewController alloc ]initWithNibName:@"LoginOneVCViewController" bundle:nil];
    
    [self.navigationController pushViewController:login1 animated:YES];

}

#pragma mark- Target Actions
- (IBAction)tootgleMenu:(UIBarButtonItem *)sender {
    ContainerViewController *containerVC = (ContainerViewController*)self.parentViewController.parentViewController;
    [containerVC toogleMenuVC:!containerVC.isShowing with:YES];
}
- (IBAction)switchVC:(UIButton *)sender
{
    UIViewController *selectedVC = self.childVCS[sender.tag - BaseTag];
     NSLog(@"view bounds : %@",NSStringFromCGSize(self.view.bounds.size));
     NSLog(@"view bounds : %@",NSStringFromCGSize(selectedVC.view.bounds.size));
    if ([self.view.subviews.lastObject isEqual:selectedVC.view]) {
        return;
    }
    NSLog(@"switched");
    [self allBtnsUnselected];
    [sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    if (self.view.subviews.count > 0) {
        [[self.view.subviews lastObject] removeFromSuperview];
        
        [[self.childViewControllers lastObject] removeFromParentViewController];
    }
    selectedVC.view.frame = self.view.bounds;
    [self.view addSubview:selectedVC.view];
    [self addChildViewController:selectedVC];
    [selectedVC didMoveToParentViewController:self];
}



#pragma mark- lazy getters
- (NSArray *)childVCS
{
    if (!_childVCS) {
        UIViewController* mineVC = VCFromStoryboard(@"Mine", @"MineVC");
        UIViewController* ClassesVC = VCFromStoryboard(@"Classes", @"ClassesVC");
        UIViewController* TimeLineVC = VCFromStoryboard(@"TimeLine", @"TimeLineVC");
        UIViewController* FindVC = VCFromStoryboard(@"Find", @"FindVC");
        _childVCS = @[mineVC,ClassesVC,TimeLineVC,FindVC];
    }
    return _childVCS;
}

#pragma mark- Top buttons state
- (void)allBtnsUnselected
{
    for (UIButton *btn in self.topButtons){
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
