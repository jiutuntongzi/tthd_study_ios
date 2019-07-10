//
//  TopicHomePagerViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TopicHomePagerViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleImageView.h"
#import "HomeSearchView.h"
#import "TopicHomeContainerView.h"
#import "TopicSearchViewController.h"
#import "TopicDetailPagerViewController.h"
#import "TopicSubmitViewController.h"
#import "TopicRequestManagerClass.h"
#import "TopicListModel.h"
#import "BannerModel.h"
#import "CommonRequestManagerClass.h"

typedef NS_ENUM(NSInteger, CurrentType) {
    CurrentType_Left,
    CurrentType_Right
};

static const CGFloat HeaderViewHeight = 180;
static const CGFloat HeightForHeaderInSection = 50;

@interface TopicHomePagerViewController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate, RequestManagerDelegate, ImagePlayerViewDelegate>

/** 主父视图 */
@property (nonatomic, strong) JXPagerView *pagerView;
/** 头部视图 */
@property (nonatomic, strong) ImagePlayerView *imagePlayerView;
/** 标题栏 */
@property (nonatomic, strong) JXCategoryTitleImageView *categoryView;
/** 下划线 */
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
/** 搜索 */
@property (nonatomic, strong) HomeSearchView *searchView;
/** 内容 */
@property (nonatomic, strong) TopicHomeContainerView *containerView;
/** 发布按钮 */
@property (nonatomic, strong) QMUIButton *submitButton;
/** 请求类 */
@property (nonatomic, strong) TopicRequestManagerClass *requestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray <TopicListModel *> *topicLeftArray;
@property (nonatomic, strong) NSMutableArray <TopicListModel *> *topicRightArray;
/** 当前类 */
@property (nonatomic, assign) CurrentType curType;
/** banner */
@property (nonatomic, strong) NSMutableArray <BannerModel *> *bannerArray;
/** banner请求类 */
@property (nonatomic, strong) CommonRequestManagerClass *commonRequestManager;

@end

@implementation TopicHomePagerViewController

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
        _categoryView.titles = @[@"最新时间", @"热度讨论"];
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

- (ImagePlayerView *)imagePlayerView
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
        _searchView.searchLabel.text = @"搜索话题";
        __weak __typeof (self)weakSelf = self;
        _searchView.tapSearch = ^{
            [weakSelf.navigationController pushViewController:[TopicSearchViewController new] animated:YES];
        };
    }
    
    return _searchView;
}

-(TopicHomeContainerView *)containerView
{
    if (!_containerView) {
        _containerView = [[TopicHomeContainerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight - HeightForHeaderInSection)];
        __weak __typeof (self)weakSelf = self;
        _containerView.selectTopicBlock = ^(TopicListModel *model) {
            TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
            vc.topicModel = model;
            vc.topicId = model.topicId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }

    return _containerView;
}

-(QMUIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [QMUIButton new];
        [_submitButton setTitle:@"发起话题" forState:0];
        [_submitButton setTitleColor:UIColorBlack forState:0];
        [_submitButton setBackgroundColor:UIColorMakeWithHex(@"#FEDB5C")];
        _submitButton.titleLabel.font = UIFontMake(16);
        _submitButton.layer.cornerRadius = 6;
        [_submitButton addTarget:self action:@selector(submitNote) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _submitButton;
}

-(TopicRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [TopicRequestManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

-(CommonRequestManagerClass *)commonRequestManager
{
    if (!_commonRequestManager) {
        _commonRequestManager = [[CommonRequestManagerClass alloc] init];
        _commonRequestManager.delegate = self;
    }
    
    return _commonRequestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _topicLeftArray = [NSMutableArray array];
    _topicRightArray = [NSMutableArray array];
    _bannerArray        = [NSMutableArray array];
    _curType = CurrentType_Left;
    
    [self.navView addSubview:self.searchView];
    [self.navView addSubview:self.submitButton];
    [self.view addSubview:self.pagerView];
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    self.categoryView.indicators = @[self.lineView];
    
    _submitButton.sd_layout
    .centerYEqualToView(self.navView)
    .rightSpaceToView(self.navView, 15)
    .heightIs(30)
    .widthIs(80);
    
    _searchView.sd_layout
    .leftSpaceToView(self.navView, 50)
    .rightSpaceToView(_submitButton, 15)
    .centerYEqualToView(self.navView)
    .heightIs(35);
    
    [self getTopicList];
    [self.commonRequestManager getBannerWithPosition:BannerPosition_topic
                                         requestName:GET_BANNER];
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

-(void)getTopicList
{
    NSString *ishot;
    NSString *isnew;
    if (_curType == CurrentType_Left) {
        ishot = @"0";
        isnew = @"1";
    }else{
        ishot = @"1";
        isnew = @"1";
    }
    [self.requestManager getTopicListWithIsHot:ishot isNew:isnew requestName:GET_TOPIC_LIST];

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

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    //    self.clicked(index);
}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didScorllIndex:(NSInteger)index
{
    //        if (_bannerArray.count > 0) {
    //            MH_BannerModel *model = _bannerArray[index];
    //
    //            _descLabel.text = model.desc.length > 40 ? [model.desc substringToIndex:40] : model.desc;
    //        }
}

#pragma mark - 数据处理
-(void)hanleTopicListDataWithData:(NSArray *)dataArray
{
    if (_curType == CurrentType_Left) {
        [_topicLeftArray removeAllObjects];
        for (NSDictionary *dic in dataArray) {
            TopicListModel *model = [[TopicListModel alloc] initModelWithDict:dic];
            [_topicLeftArray addObject:model];
        }
        _containerView.dataArray = _topicLeftArray;
    }else{
        [_topicRightArray removeAllObjects];
        for (NSDictionary *dic in dataArray) {
            TopicListModel *model = [[TopicListModel alloc] initModelWithDict:dic];
            [_topicRightArray addObject:model];
        }
        _containerView.dataArray = _topicRightArray;
    }
    
}

-(void)handleBannerDataWithData:(NSArray *)dataArray
{
    for (NSDictionary *dic in dataArray) {
        BannerModel *model = [[BannerModel alloc] initModelWithDict:dic];
        [_bannerArray addObject:model];
    }
    
    [_imagePlayerView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_TOPIC_LIST]) {
        [self hanleTopicListDataWithData:info];
    }
    //banner
    if ([requestName isEqualToString:GET_BANNER]) {
        [self handleBannerDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - 发起话题
-(void)submitNote
{
    [self.navigationController pushViewController:[TopicSubmitViewController new] animated:YES];
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
    
//    NSInteger diffIndex = labs(categoryView.selectedIndex - index);
//    if (diffIndex > 1) {
//        [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    }else {
//        [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    }
    
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
