//
//  LivePagerViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LivePagerViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleImageView.h"
#import "HomeSearchView.h"
#import "LiveHomeContainerView.h"
#import "LiveDetailViewController.h"
#import "LiveSearchViewController.h"
static const CGFloat HeaderViewHeight = 180;
static const CGFloat HeightForHeaderInSection = 50;

@interface LivePagerViewController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

/** 主父视图 */
@property (nonatomic, strong) JXPagerView *pagerView;
/** 头部视图 */
@property (nonatomic, strong) UIImageView *liveHeaderView;
/** 标题栏 */
@property (nonatomic, strong) JXCategoryTitleImageView *categoryView;
/** 下划线 */
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
/** 搜索 */
@property (nonatomic, strong) HomeSearchView *searchView;
/** 内容 */
@property (nonatomic, strong) LiveHomeContainerView *containerView;

@end

@implementation LivePagerViewController

#pragma mark - lazy
-(JXPagerView *)pagerView
{
    if (!_pagerView) {
        _pagerView = [self preferredPagingView];
        _pagerView.mainTableView.gestureDelegate = self;
        _pagerView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight);
    }
    
    return _pagerView;
}

-(JXCategoryTitleImageView *)categoryView
{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleImageView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, HeightForHeaderInSection)];
        _categoryView.titles = @[@"人气从高到低", @"最新直播"];
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
    }
    
    return _categoryView;
}

- (UIImageView *)liveHeaderView
{
    if (!_liveHeaderView) {
        _liveHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderViewHeight)];
        _liveHeaderView.image = UIImageMake(@"default1.jpg");
    }
    
    return _liveHeaderView;
}

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

-(HomeSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[HomeSearchView alloc] initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH - 60, 40)];
        _searchView.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
        _searchView.searchLabel.text = @"搜索直播";
        __weak __typeof (self)weakSelf = self;
        _searchView.tapSearch = ^{
            [weakSelf.navigationController pushViewController:[LiveSearchViewController new] animated:YES];
        };
    }
    
    return _searchView;
}

-(LiveHomeContainerView *)containerView
{
    if (!_containerView) {
        _containerView = [[LiveHomeContainerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight - HeightForHeaderInSection)];
        _containerView.backgroundColor = UIColorTestRed;
        __weak __typeof (self)weakSelf = self;
        _containerView.selectedLiveBlock = ^{
            [weakSelf.navigationController pushViewController:[LiveDetailViewController new] animated:YES];
        };
    }
    
    return _containerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navView addSubview:self.searchView];
    
    [self.view addSubview:self.pagerView];
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    self.categoryView.indicators = @[self.lineView];
    
    _searchView.sd_layout
    .leftSpaceToView(self.navView, 50)
    .rightSpaceToView(self.navView, 30)
    .centerYEqualToView(self.navView)
    .heightIs(35);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (JXPagerView *)preferredPagingView {
    return [[JXPagerView alloc] initWithDelegate:self];
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.liveHeaderView;
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
    return self.containerView;
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickedItemContentScrollViewTransitionToIndex:(NSInteger)index {
    //请务必实现该方法
    //因为底层触发列表加载是在代理方法：`- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath`回调里面
    //所以，如果当前有5个item，当前在第1个，用于点击了第5个。categoryView默认是通过设置contentOffset.x滚动到指定的位置，这个时候有个问题，就会触发中间2、3、4的cellForItemAtIndexPath方法。
    //如此一来就丧失了延迟加载的功能
    //所以，如果你想规避这样的情况发生，那么务必按照这里的方法处理滚动。
    //    [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

    //如果你想相邻的两个item切换时，通过有动画滚动实现。未相邻的两个item直接切换，可以用下面这段代码

    NSInteger diffIndex = labs(categoryView.selectedIndex - index);
    if (diffIndex > 1) {
        [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else {
        [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }

}

#pragma mark - JXPagerMainTableViewGestureDelegate
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
