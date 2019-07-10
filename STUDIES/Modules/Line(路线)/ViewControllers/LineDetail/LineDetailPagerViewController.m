//
//  LineDetailPagerViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineDetailPagerViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXPagerView.h"
#import "LineDetailHeaderView.h"
#import "JXCategoryTitleView.h"
#import "LineDetailViewController.h"
#import "LineRecommandViewController.h"
#import "LineDetailImagesViewController.h"
#import "LineRequestManagerClass.h"
#import "LineDetailModel.h"
#import "HomeBannerCell.h"

static const CGFloat HeaderViewHeight = 410;
static const CGFloat HeightForHeaderInSection = 50;

@interface LineDetailPagerViewController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate, UIScrollViewDelegate, RequestManagerDelegate, UITableViewDelegate, UITableViewDataSource>

/** 分享按钮 */
@property (nonatomic, strong) QMUIButton *shareButton;
/** 主父视图 */
@property (nonatomic, strong) JXPagerView *pagerView;
/** 头部视图 */
@property (nonatomic, strong) LineDetailHeaderView *lineHeaderView;
/** 标题栏 */
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
/** 下划线 */
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
/** 底部视图 */
@property (nonatomic, strong) UIView *bottomView;
/** 底部视图高度 */
@property (nonatomic, assign) CGFloat bottomHeight;
/** 路线详情按钮 */
@property (nonatomic, strong) QMUIButton *detailButton;
/** 推荐按钮 */
@property (nonatomic, strong) QMUIButton *recommandButton;
/** 下划线 */
@property (nonatomic, strong) UIView *bottomLine;
/** 路线请求类 */
@property (nonatomic, strong) LineRequestManagerClass *lineRequesManager;
/** 路线详情数据 */
@property (nonatomic, strong) LineDetailModel *detailModel;
/** 子视图控制器 */
@property (nonatomic, strong) LineDetailViewController *detailVC;
/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation LineDetailPagerViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[HomeBannerCell class] forCellReuseIdentifier:@"HomeBannerCell"];
    }
    
    return _mainTableView;
}

-(QMUIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [QMUIButton new];
        [_shareButton setImage:UIImageMake(@"note_icon_share") forState:0];
//        [_shareButton addTarget:self action:@selector(sharedClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

-(LineDetailHeaderView *)lineHeaderView
{
    if (!_lineHeaderView) {
        __weak __typeof (self) weakSelf = self;
        _lineHeaderView = [[LineDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderViewHeight)];
        _lineHeaderView.backBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _lineHeaderView.shareBlock = ^{
            
        };
        _lineHeaderView.imagePlayerBlock = ^{
            [weakSelf.navigationController pushViewController:[LineDetailImagesViewController new] animated:YES];
        };
    }
    
    return _lineHeaderView;
}

-(JXCategoryTitleView *)categoryView
{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeightForHeaderInSection)];
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
        _pagerView.isListHorizontalScrollEnabled = NO;
        _pagerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - self.bottomView.height);
        _pagerView.pinSectionHeaderVerticalOffset = BaseStatusViewHeight + BaseNavViewHeight;
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
        
        QMUIButton *collectButton = [QMUIButton new];
        [collectButton setImage:UIImageMake(@"note_icon_collect_normal") forState:0];
        [collectButton setImage:UIImageMake(@"note_icon_collect_selected") forState:UIControlStateSelected];
        [collectButton setTitle:@"收藏" forState:0];
        [collectButton setTitle:@"取消收藏" forState:UIControlStateSelected];
        [collectButton setTitleColor:UIColorMakeWithHex(@"#333333") forState:0];
        [collectButton addTarget:self action:@selector(collectedClick:) forControlEvents:UIControlEventTouchUpInside];
        collectButton.imagePosition = QMUIButtonImagePositionLeft;
        collectButton.spacingBetweenImageAndTitle = 10;
        [_bottomView addSubview:collectButton];
        
        QMUIButton *callButton = [QMUIButton new];
        [callButton setTitle:@"立即咨询" forState:0];
        [callButton setTitleColor:UIColorWhite forState:0];
        [callButton setBackgroundColor:UIColorMakeWithHex(@"#91CEC0")];
        [_bottomView addSubview:callButton];
        
        collectButton.sd_layout
        .leftSpaceToView(_bottomView, 10)
        .topSpaceToView(_bottomView, 0)
        .widthIs(120)
        .heightIs(60);
        
        callButton.sd_layout
        .topEqualToView(_bottomView)
        .rightEqualToView(_bottomView)
        .heightIs(60)
        .widthIs(120);
    }
    
    return _bottomView;
}

-(CGFloat)bottomHeight
{
    if (!_bottomHeight) {
        _bottomHeight = [MyTools getPhoneType] == PhoneType_Screen_FULL ? 60 : 60;
    }
    
    return _bottomHeight;
}

-(QMUIButton *)detailButton
{
    if (!_detailButton) {
        _detailButton = [QMUIButton new];
        [_detailButton setTitle:@"路线详情" forState:0];
        [_detailButton setTitleColor:UIColorWhite forState:0];
        _detailButton.titleLabel.font = UIFontMake(22);
        [_detailButton addTarget:self action:@selector(selectedPage:) forControlEvents:UIControlEventTouchUpInside];
        _detailButton.tag = 10000;
    }
    
    return _detailButton;
}

-(QMUIButton *)recommandButton
{
    if (!_recommandButton) {
        _recommandButton = [QMUIButton new];
        [_recommandButton setTitle:@"推荐" forState:0];
        [_recommandButton setTitleColor:UIColorWhite forState:0];
        _recommandButton.titleLabel.font = UIFontMake(22);
        [_recommandButton addTarget:self action:@selector(selectedPage:) forControlEvents:UIControlEventTouchUpInside];
        _recommandButton.tag = 10001;
    }
    
    return _recommandButton;
}

-(UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = UIColorWhite;
    }
    
    return _bottomLine;
}

-(LineRequestManagerClass *)lineRequesManager
{
    if (!_lineRequesManager) {
        _lineRequesManager = [[LineRequestManagerClass alloc] init];
        _lineRequesManager.delegate = self;
    }
    
    return _lineRequesManager;
}

#pragma mark ---
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.titleLabel.text = @"话题详情";
//    [self.navView addSubview:self.shareButton];
    
    [self.navView addSubview:self.detailButton];
    [self.navView addSubview:self.recommandButton];
    [self.navView addSubview:self.bottomLine];
    
    _detailButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 20 - 100, BaseNavViewHeight / 2 - 15, 100, 30);
    _recommandButton.frame = CGRectMake(SCREEN_WIDTH / 2 + 20, BaseNavViewHeight / 2 - 15, 100, 30);
    _bottomLine.frame = CGRectMake(_detailButton.left, BaseNavViewHeight - 5, 100, 2);
    
//    _shareButton.sd_layout
//    .rightSpaceToView(self.navView, 20)
//    .centerYEqualToView(self.navView)
//    .widthIs(30)
//    .heightEqualToWidth();
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.pagerView];
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    self.categoryView.indicators = @[self.lineView];
    
    [self.lineRequesManager getLineDetailWithLineId:self.lineId tutorId:self.tutorId token:Token requestName:GET_LINE_DETAIL];
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
//    [self presentViewController:[TopicSubmitViewController new] animated:YES completion:nil];
}

#pragma mark - 切换页面
-(void)selectedPage:(QMUIButton *)button
{
    if (button.tag == 10000) {
        _bottomLine.frame = CGRectMake(_detailButton.left, BaseNavViewHeight - 5, 100, 2);
        [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }else{
        _bottomLine.frame = CGRectMake(_recommandButton.left, BaseNavViewHeight - 5, 100, 2);
        [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - 收藏
-(void)collectedClick:(QMUIButton *)button
{
    button.selected = !button.selected;
}

#pragma mark - 数据处理
-(void)handleLineDetailDataWithData:(NSDictionary *)dataDic
{
    _detailModel = [[LineDetailModel alloc] initModelWithDict:dataDic[@"path"]];
    
    _lineHeaderView.model = _detailModel;
    _detailVC.detailModel = _detailModel;
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_LINE_DETAIL]) {
        [self handleLineDetailDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.lineHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return HeaderViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 0;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 2;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        _detailVC = [LineDetailViewController new];
        return _detailVC;
    }
    if (index == 1) {
        return [[LineRecommandViewController alloc] init];
    }
    
    return nil;
    
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= HeaderViewHeight - BaseStatusViewHeight - BaseNavViewHeight - 5) {
        [self.view bringSubviewToFront:self.statusView];
        [self.view bringSubviewToFront:self.navView];        
    }else{
        [self.view bringSubviewToFront:self.pagerView];
    }
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
