//
//  BaseTabBarViewController.m
//  STUDIES
//
//  Created by happyi on 2019/3/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "HomeViewController.h"
#import "DynamicViewController.h"
#import "MessageViewController.h"
#import "LineViewController.h"
#import "MineViewController.h"
#import "BaseTabBarView.h"

@interface BaseTabBarViewController ()<BaseTabBarViewDelegate>
/** 自定义tabbar */
@property(nonatomic, strong) BaseTabBarView *baseTabBarView;

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTabBar];
    [self initViewControllers];
}

-(void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
}

#pragma mark - lazy
-(BaseTabBarView *)baseTabBarView
{
    if (!_baseTabBarView) {
        _baseTabBarView = [[BaseTabBarView alloc] init];
        _baseTabBarView.backgroundColor = UIColorWhite;
        _baseTabBarView.delegate = self;
    }
    
    return _baseTabBarView;
}

#pragma mark - 初始化tabBar
-(void)initTabBar
{
    [self.tabBar removeFromSuperview];
    [self.tabBar setHidden:YES];
    [self.view addSubview:self.baseTabBarView];
    
    _baseTabBarView.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .heightIs(BaseTabBarViewHeight);
}

#pragma mark - 初始化VC
-(void)initViewControllers
{

    self.viewControllers = @[[HomeViewController new],
                             [DynamicViewController new],
                             [LineViewController new],
//                             [MessageViewController new],
                             [MineViewController new]
                             ];
    
    NSArray *imageNormalArray = @[@"tab_icon_home_normal",
                                  @"tab_icon_line_normal",
                                  @"tab_icon_dynamic_normal",
//                                  @"tab_icon_message_normal",
                                  @"tab_icon_mine_normal"];
    
    NSArray *imageSelectedArray = @[@"tab_icon_home_selected",
                                    @"tab_icon_line_selected",
                                    @"tab_icon_dynamic_selected",
//                                    @"tab_icon_message_selected",
                                    @"tab_icon_mine_selected"];
    
    NSArray *titleArray = @[@"首页",
                            @"动态",
                            @"路线",
//                            @"消息",
                            @"我的"];
    
    for (int i = 0; i < self.viewControllers.count; i ++) {
        UIImage *normalImage = UIImageMake(imageNormalArray[i]);
        UIImage *selectedImage = UIImageMake(imageSelectedArray[i]);
        [_baseTabBarView addButtonWithTitle:titleArray[i] normalImage:normalImage selectedImage:selectedImage];
    }
}

#pragma mark - BaseTabBarDelegate
-(void)tabBarView:(BaseTabBarView *)tabBarView selectedFromIndex:(NSInteger)selectedFromIndex toIndex:(NSInteger)toIndex
{
    self.selectedIndex = toIndex;
}

@end
