//
//  TeacherHomeViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherHomePagerViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleImageView.h"
#import "TeacherHomeContainerAllView.h"
#import "HomeSearchView.h"
#import "TeacherSearchViewController.h"
#import "ConditionViewController.h"
#import "TeacherHomeContainerEvaluteView.h"
#import "TeacherDetailPagerViewController.h"
#import "TeacherRequestManagerClass.h"
#import "TeacherTypeModel.h"
#import "TeacherModel.h"
#import "CommonRequestManagerClass.h"
#import "BannerModel.h"
#import <ImagePlayerView.h>
#import "LoginViewController.h"
#import "JXPagerListRefreshView.h"
static const CGFloat HeaderViewHeight = 180;
static const CGFloat HeightForHeaderInSection = 50;

typedef NS_ENUM(NSInteger, CurrentType) {
    CurrentType_Left,
    CurrentType_Right
};

@interface TeacherHomePagerViewController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate, RequestManagerDelegate, ImagePlayerViewDelegate>

/** 主父视图 */
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
/** 头部视图 */
@property (nonatomic, strong) ImagePlayerView *imagePlayerView;
/** 标题栏 */
@property (nonatomic, strong) JXCategoryTitleImageView *categoryView;
/** 下划线 */
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
/** 搜索 */
@property (nonatomic, strong) HomeSearchView *searchView;
/** 内容视图分类 */
@property (nonatomic, strong) TeacherHomeContainerAllView *containerAllView;
/** 内容视图评价 */
@property (nonatomic, strong) TeacherHomeContainerEvaluteView *containerEvaluteView;
/** 弹出菜单 */
@property (nonatomic, strong) ConditionViewController *conditionVC;
/** 导师请求类 */
@property (nonatomic, strong) TeacherRequestManagerClass *teacherRequestManager;
/** banner请求类 */
@property (nonatomic, strong) CommonRequestManagerClass *commonRequestManager;
/** 分类数据 */
@property (nonatomic, strong) NSMutableArray <TeacherTypeModel *> *typeArray;
/** banner */
@property (nonatomic, strong) NSMutableArray <BannerModel *> *bannerArray;
/** 选择的分类 */
@property (nonatomic, strong) TeacherTypeModel *selectedModel;
@end

@implementation TeacherHomePagerViewController

#pragma mark - lazy
//内容视图
-(JXPagerView *)pagerView
{
    if (!_pagerView) {
        _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
        _pagerView.mainTableView.gestureDelegate = self;
        _pagerView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight);
    }
    
    return _pagerView;
}

//标题栏
-(JXCategoryTitleImageView *)categoryView
{
    if (!_categoryView) {
        NSArray *images = @[@"teacher_icon_down", @"teacher_icon_dow"];
        NSArray *slectedimages = @[@"teacher_icon_down", @""];

        _categoryView = [[JXCategoryTitleImageView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, HeightForHeaderInSection)];
        _categoryView.imageNames = images;
        _categoryView.selectedImageNames = slectedimages;
        _categoryView.delegate = self;
        _categoryView.titleFont = UIFontMake(18);
        _categoryView.titleSelectedColor = UIColorMakeWithHex(@"#2CBCB4");
        _categoryView.titleColor = UIColorMakeWithHex(@"#909192");
        _categoryView.imageTypes = @[@(JXCategoryTitleImageType_RightImage), @(JXCategoryTitleImageType_LeftImage)];
        _categoryView.separatorLineShowEnabled = YES;
        _categoryView.imageSize = CGSizeMake(15, 15);
        _categoryView.separatorLineSize = CGSizeMake(1, HeightForHeaderInSection);
        _categoryView.cellWidth = SCREEN_WIDTH / 2 - 20;
        _categoryView.cellSpacing = 0;
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.layer.borderWidth = 0.5;
        _categoryView.layer.borderColor = UIColorGray.CGColor;
        _categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
        _categoryView.indicators = @[self.lineView];

    }
    
    return _categoryView;
}

//头部banner
-(ImagePlayerView *)imagePlayerView
{
    if (!_imagePlayerView) {
        _imagePlayerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderViewHeight)];
        _imagePlayerView.scrollInterval = 3;
        _imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
        _imagePlayerView.endlessScroll = YES;
        _imagePlayerView.imagePlayerViewDelegate = self;
    }
    
    return _imagePlayerView;
}

//标题下划线
-(JXCategoryIndicatorLineView *)lineView
{
    if (!_lineView) {
        _lineView = [[JXCategoryIndicatorLineView alloc] init];
        _lineView.indicatorLineViewColor = UIColorMakeWithHex(@"#2CBCB4");
        _lineView.indicatorWidth = SCREEN_WIDTH / 2;
        _lineView.indicatorHeight = 2;
    }
    return _lineView;
}

//搜索栏
-(HomeSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[HomeSearchView alloc] initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH - 60, 40)];
        _searchView.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
        _searchView.searchLabel.text = @"搜索导师";
        __weak __typeof (self)weakSelf = self;
        _searchView.tapSearch = ^{
            TeacherSearchViewController *searchVC = [TeacherSearchViewController new];
            [weakSelf.navigationController pushViewController:searchVC animated:YES];
        };
    }
    
    return _searchView;
}

//子视图1
-(TeacherHomeContainerAllView *)containerAllView
{
    if (!_containerAllView) {
        _containerAllView = [[TeacherHomeContainerAllView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight - HeightForHeaderInSection)];
        __weak __typeof (self)weakSelf = self;
        _containerAllView.selectedTeacherBlock = ^(TeacherModel *model) {
            TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
            vc.ub_id = model.ub_id;
            vc.userType = @"2";
            vc.name = model.nickname;
            vc.avatar = model.avatar;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    
    return _containerAllView;
}

//子视图2
-(TeacherHomeContainerEvaluteView *)containerEvaluteView
{
    if (!_containerEvaluteView) {
        _containerEvaluteView = [[TeacherHomeContainerEvaluteView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight - HeightForHeaderInSection)];
        __weak __typeof (self)weakSelf = self;
        _containerEvaluteView.selectedTeacherBlock = ^(TeacherModel *model) {
            TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
            vc.ub_id = model.ub_id;
            vc.userType = @"2";
            vc.name = model.nickname;
            vc.avatar = model.avatar;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    
    return _containerEvaluteView;
}

//筛选条件
-(ConditionViewController *)conditionVC
{
    if (!_conditionVC) {
        __weak __typeof (self)weakSelf = self;
        _conditionVC = [ConditionViewController new];
        _conditionVC.selectedTypeBlock = ^(id  _Nonnull model) {
            TeacherTypeModel *iModel = (TeacherTypeModel *)model;
            weakSelf.containerAllView.selectedModel = iModel;
            weakSelf.selectedModel = iModel;
            weakSelf.categoryView.titles = [@[iModel.name, @"评价从高到低"] mutableCopy];
            [weakSelf.categoryView reloadData];
            [weakSelf.conditionVC hideInView:weakSelf.containerAllView animated:YES completion:nil];
        };
    }
    
    return _conditionVC;
}

//导师请求类
-(TeacherRequestManagerClass *)teacherRequestManager
{
    if (!_teacherRequestManager) {
        _teacherRequestManager = [[TeacherRequestManagerClass alloc] init];
        _teacherRequestManager.delegate = self;
    }
    
    return _teacherRequestManager;
}

//公共请求类
-(CommonRequestManagerClass *)commonRequestManager
{
    if (!_commonRequestManager) {
        _commonRequestManager = [[CommonRequestManagerClass alloc] init];
        _commonRequestManager.delegate = self;
    }
    
    return _commonRequestManager;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _containerAllView.selectedModel = self.selectedModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _typeArray          = [NSMutableArray array];
    _bannerArray        = [NSMutableArray array];

    [self.navView addSubview:self.searchView];
    [self.view addSubview:self.pagerView];

    _searchView.sd_layout
    .leftSpaceToView(self.navView, 50)
    .rightSpaceToView(self.navView, 30)
    .centerYEqualToView(self.navView)
    .heightIs(35);
    
    //获取导师类别
    [self getTeacherType];
    //获取banner
    [self getTeacherBanner];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - 获取导师类别
-(void)getTeacherType
{
    [self.teacherRequestManager getTeacherTypeWithRequestName:GET_TEACHER_TYPE];
}

#pragma mark - 获取导师banner
-(void)getTeacherBanner
{
    [self.commonRequestManager getBannerWithPosition:BannerPosition_tutor
                                         requestName:GET_BANNER];
}

#pragma mark - 数据处理
-(void)handleTypeDataWithData:(NSArray *)dataArray
{
    for (NSDictionary *dic in dataArray) {
        TeacherTypeModel *model = [[TeacherTypeModel alloc] initModelWithDict:dic];
        [_typeArray addObject:model];
    }
    _categoryView.titles = [@[[_typeArray[0] name], @"评价从高到低"] mutableCopy];
    [_categoryView reloadData];
    _containerAllView.selectedModel = _typeArray[0];
    TeacherTypeModel *model = _typeArray[0];
    _selectedModel = model;
}

-(void)handleBannerDataWithData:(NSArray *)dataArray
{
    for (NSDictionary *dic in dataArray) {
        BannerModel *model = [[BannerModel alloc] initModelWithDict:dic];
        [_bannerArray addObject:model];
    }
    if (_bannerArray.count == 1) {
        //当banner只有一张图时，禁止滚动
        _imagePlayerView.scrollInterval = 0;
    }
    [_imagePlayerView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    //导师分类
    if ([requestName isEqualToString:GET_TEACHER_TYPE]) {
        [self handleTypeDataWithData:info];
    }
    //banner
    if ([requestName isEqualToString:GET_BANNER]) {
        [self handleBannerDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.bannerArray.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    if (_bannerArray.count == 0) {
        return;
    }
    BannerModel *model = _bannerArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.image]
                 placeholderImage:UIImageMake(@"commom_icon_placeholderImage")];
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.imagePlayerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return HeaderViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return HeightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 2;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        return self.containerAllView;
    }else
        return self.containerEvaluteView;
}

#pragma mark - JXCategoryViewDelegate
-(void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    if (index == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.pagerView.mainTableView.contentOffset = CGPointMake(0, HeaderViewHeight);
        } completion:^(BOOL finished) {
            self.conditionVC.dataSourceArray = self.typeArray;
            self.conditionVC.selectedModel = self.selectedModel;
            [self.conditionVC showInView:self.containerAllView animated:YES completion:nil];
        }];
        [UIView commitAnimations];
    }
}

@end
