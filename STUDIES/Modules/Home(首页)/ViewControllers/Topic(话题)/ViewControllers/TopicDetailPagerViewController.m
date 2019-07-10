//
//  TopicPagingViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TopicDetailPagerViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "TopicDetailNewViewController.h"
#import "TopicDetailHotViewController.h"
#import "JXPagerView.h"
#import "TopicDetailHeaderView.h"
#import "JXCategoryTitleView.h"
#import "TopicSubmitViewController.h"
#import "TopicRequestManagerClass.h"
#import "TopicDetailModel.h"
#import "DynamicDetailPagerViewController.h"
#import "TeacherDetailPagerViewController.h"
#import "TopicDetailPagerViewController.h"
#import "NoteDetailViewController.h"
#import "TrackSubmitViewController.h"

static const CGFloat HeaderViewHeight = 140;
static const CGFloat HeightForHeaderInSection = 50;

@interface TopicDetailPagerViewController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate, RequestManagerDelegate>

/** 分享按钮 */
@property (nonatomic, strong) QMUIButton *shareButton;
/** 主父视图 */
@property (nonatomic, strong) JXPagerView *pagerView;
/** 头部视图 */
@property (nonatomic, strong) TopicDetailHeaderView *topicHeaderView;
/** 标题栏 */
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
/** 下划线 */
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
/** 底部视图 */
@property (nonatomic, strong) UIView *bottomView;
/** 底部视图高度 */
@property (nonatomic, assign) CGFloat bottomHeight;
/** 话题请求类 */
@property (nonatomic, strong) TopicRequestManagerClass *requestManager;
/** 话题详情 */
@property (nonatomic, strong) TopicDetailModel *detailModel;
/** 最新 */
@property (nonatomic, strong) TopicDetailNewViewController *newsVC;
/** 最热 */
@property (nonatomic, strong) TopicDetailHotViewController *hotVC;
@end

@implementation TopicDetailPagerViewController

#pragma mark - lazy
-(QMUIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [QMUIButton new];
        [_shareButton setImage:UIImageMake(@"note_icon_share") forState:0];
        [_shareButton addTarget:self action:@selector(sharedClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

-(TopicDetailHeaderView *)topicHeaderView
{
    @weakify(self)
    if (!_topicHeaderView) {
        _topicHeaderView = [[TopicDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderViewHeight)];
        _topicHeaderView.model = _topicModel;
        _topicHeaderView.followTopicBlock = ^(TopicDetailModel *model) {
            @strongify(self)
            [self.requestManager postFollowTopicWithTopicId:model.topicId token:Token requestName:POST_FOLLOW_TOPIC];
        };
    }
    
    return _topicHeaderView;
}

-(JXCategoryTitleView *)categoryView
{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, HeightForHeaderInSection)];
        _categoryView.titles = @[@"最新", @"热门"];
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.delegate = self;
        _categoryView.titleFont = UIFontMake(18);
        _categoryView.titleSelectedColor = UIColorMakeWithHex(@"#2CBCB4");
        _categoryView.titleColor = UIColorMakeWithHex(@"#909192");
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.layer.cornerRadius = 10;
        _categoryView.layer.masksToBounds = YES;
        _categoryView.separatorLineShowEnabled = NO;
    }
    
    return _categoryView;
}

-(JXCategoryIndicatorLineView *)lineView
{
    if (!_lineView) {
        _lineView = [[JXCategoryIndicatorLineView alloc] init];
        _lineView.indicatorLineViewColor = UIColorMakeWithHex(@"#2CBCB4");
        _lineView.indicatorLineWidth = 60;
    }
    return _lineView;
}

-(JXPagerView *)pagerView
{
    if (!_pagerView) {
        _pagerView = [self preferredPagingView];
        _pagerView.mainTableView.gestureDelegate = self;
        _pagerView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight - self.bottomView.height);
        _pagerView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    }
    
    return _pagerView;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = UIColorWhite;
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - self.bottomHeight, SCREEN_WIDTH, self.bottomHeight);
        _bottomView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBottomView)];
        [_bottomView addGestureRecognizer:tgr];
        
        QMUILabel *label = [MyTools labelWithText:@"一起参与讨论吧~" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
        label.backgroundColor = UIColorMakeWithHex(@"#DDF0EF");
        label.layer.cornerRadius = 20;
        label.layer.masksToBounds = YES;
        label.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_bottomView addSubview:label];
        
        label.sd_layout
        .leftSpaceToView(_bottomView, 20)
        .topSpaceToView(_bottomView, 10)
        .rightSpaceToView(_bottomView, 20)
        .heightIs(40);
    }
    
    return _bottomView;
}

-(CGFloat)bottomHeight
{
    if (!_bottomHeight) {
        _bottomHeight = [MyTools getPhoneType] == PhoneType_Screen_FULL ? 90 : 60;
    }
    
    return _bottomHeight;
}

-(TopicRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [TopicRequestManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

#pragma mark ---
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"话题详情";
    [self.navView addSubview:self.shareButton];

    [self initNewVC];
    [self initHotVC];
    
//    _shareButton.sd_layout
//    .rightSpaceToView(self.navView, 20)
//    .centerYEqualToView(self.navView)
//    .widthIs(30)
//    .heightEqualToWidth();
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.pagerView];
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    self.categoryView.indicators = @[self.lineView];
    
    [self.requestManager getTopicDetailWithTopicId:_topicId requestName:GET_TOPIC_DETAIL];
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

-(void)touchBottomView
{
    TrackSubmitViewController *vc = [TrackSubmitViewController new];
    TopicListModel *model = [TopicListModel new];
    model.topicId = _detailModel.topicId;
    model.ub_id     = _detailModel.ub_id;
    model.title     = _detailModel.title;
    model.describe  = _detailModel.describe;
    model.is_hot    = _detailModel.is_hot;
    model.clicks    = _detailModel.clicks;
    model.discuss   = _detailModel.discuss;
    model.images    = _detailModel.images;
    model.createtime= _detailModel.createtime;
    model.user      = _detailModel.user;
    vc.topicModel   = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 初始化
-(void)initNewVC
{
    @weakify(self)
    _newsVC = [TopicDetailNewViewController new];
    _newsVC.requestFinishiBlock = ^{
        @strongify(self)
        [self.pagerView.mainTableView.mj_header endRefreshing];
    };
    _newsVC.selectDynamicBlock = ^(DynamicListModel *model) {
        @strongify(self)
        DynamicDetailPagerViewController *vc = [DynamicDetailPagerViewController new];
        vc.dynamicModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    };
    _newsVC.selectUserBlock = ^(NSString *ubId, NSString *userType) {
        @strongify(self)
        TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
        vc.ub_id = ubId;
        vc.userType = userType;
        [self.navigationController pushViewController:vc animated:YES];
    };
    _newsVC.selectTopicBlock = ^(NSString *topicId) {
        @strongify(self)
        TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
        vc.topicId = topicId;
        [self.navigationController pushViewController:vc animated:YES];
    };
    _newsVC.selectNoteBlock = ^(NSString *noteId) {
        @strongify(self)
        NoteDetailViewController *vc = [NoteDetailViewController new];
        vc.noteId = noteId;
        [self.navigationController pushViewController:vc animated:YES];
    };
}

-(void)initHotVC
{
    @weakify(self)
    _hotVC = [TopicDetailHotViewController new];
    _hotVC.requestFinishiBlock = ^{
        @strongify(self)
        [self.pagerView.mainTableView.mj_header endRefreshing];
    };
    _hotVC.selectDynamicBlock = ^(DynamicListModel *model) {
        @strongify(self)
        DynamicDetailPagerViewController *vc = [DynamicDetailPagerViewController new];
        vc.dynamicModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    };
    _hotVC.selectUserBlock = ^(NSString *ubId, NSString *userType) {
        @strongify(self)
        TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
        vc.ub_id = ubId;
        vc.userType = userType;
        [self.navigationController pushViewController:vc animated:YES];
    };
    _hotVC.selectTopicBlock = ^(NSString *topicId) {
        @strongify(self)
        TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
        vc.topicId = topicId;
        [self.navigationController pushViewController:vc animated:YES];
    };
    _hotVC.selectNoteBlock = ^(NSString *noteId) {
        @strongify(self)
        NoteDetailViewController *vc = [NoteDetailViewController new];
        vc.noteId = noteId;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
}

#pragma mark - 刷新
-(void)refresh
{
    [_newsVC refresh];
    [_hotVC refresh];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_TOPIC_DETAIL]) {
        _detailModel = [[TopicDetailModel alloc] initModelWithDict:info];
        _topicHeaderView.detailModel = _detailModel;
        _newsVC.detailModel = _detailModel;
        _hotVC.detailModel = _detailModel;
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - 分享
-(void)sharedClick
{
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    moreOperationController.items = @[
                                      @[
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"微信好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              
                                              [moreOperationController hideToBottom];// 如果嫌每次都在 handler 里写 hideToBottom 烦，也可以直接把这句写到 moreOperationController:didSelectItemView: 里，它可与 handler 共存
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"朋友圈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareWeibo") title:@"微博" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                          }],
                                          ],
                                      ];
    [moreOperationController showFromBottom];
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.topicHeaderView;
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
        _newsVC.customHeight = self.bottomHeight;
        return _newsVC;
    }
    if (index == 1) {
        return _hotVC;
    }

    return nil;
    
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
