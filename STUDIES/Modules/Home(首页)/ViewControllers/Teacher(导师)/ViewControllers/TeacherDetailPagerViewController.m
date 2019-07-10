//
//  OCExampleViewController.m
//  JXPagerView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "TeacherDetailPagerViewController.h"
#import "JXCategoryView.h"
#import "TeacherDeatailDynamicViewController.h"
#import "TeacherDetailDescriptionViewController.h"
#import "TeacherDetailLineViewController.h"
#import "TeacherDetailLiveViewController.h"
#import "TeacherDetailEvaluateViewController.h"
#import "UIImageEffects.h"
#import "TeacherEvaluateViewController.h"
#import "TeacherFansViewController.h"
#import "HomeSearchView.h"
#import "TeacherSearchViewController.h"
#import <UMShare/UMShare.h>
#import "DynamicDetailPagerViewController.h"
#import "LineDetailPagerViewController.h"
#import "LiveDetailViewController.h"
#import "TeacherRequestManagerClass.h"
#import "TeacherDetailModel.h"
#import "TopicDetailPagerViewController.h"
#import "NoteDetailViewController.h"
#import "DynamicSearchViewController.h"
#import "TeacherDetailNoteViewController.h"
#import "JXPagerListRefreshView.h"
@interface TeacherDetailPagerViewController ()<JXCategoryViewDelegate, RequestManagerDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

/** 标题 */
@property (nonatomic, strong) NSArray <NSString *> *titles;
/** 底部按钮 */
@property (nonatomic, strong) UIView *bottomButtons;
/** 搜索栏 */
@property (nonatomic, strong) HomeSearchView *searchView;
/** 请求类 */
@property (nonatomic, strong) TeacherRequestManagerClass *requestManager;
/** 导师详情数据 */
@property (nonatomic, strong) TeacherDetailModel *detailModel;
/** 动态页面 */
@property (nonatomic, strong) TeacherDeatailDynamicViewController *dynamicVC;
/** 内容视图 */
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
/** 标题栏 */
@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@end

@implementation TeacherDetailPagerViewController

#pragma mark - lazy
//底部按钮
-(UIView *)bottomButtons
{
    if (!_bottomButtons) {
        CGFloat bottomHight = [MyTools getPhoneType] == PhoneType_Screen_FULL ? 80 : 60;
        _bottomButtons = [UIView new];
        _bottomButtons.backgroundColor = UIColorWhite;
        _bottomButtons.frame = CGRectMake(0, SCREEN_HEIGHT - bottomHight, SCREEN_WIDTH, bottomHight);
        
        NSArray *titlesNormal   = @[@"+关注", @"私信", @"我要评价"];
        NSArray *titlesSelected = @[@"取消关注", @"", @""];
        NSArray *imagesNormal   = @[@"teacher_icon_follow_selected", @"teacher_icon_chat", @"teacher_icon_evaluate"];
        NSArray *imagesSelected = @[@"teacher_icon_follow_selected", @"teacher_icon_chat", @"teacher_icon_evaluate"];

        for (int i = 0; i < 3; i ++) {
            QMUIButton *button = [QMUIButton new];
            button.frame = CGRectMake(SCREEN_WIDTH / 3 * i, 0, SCREEN_WIDTH / 3, bottomHight);
            [button setTitle:titlesNormal[i] forState:0];
            [button setTitle:titlesSelected[i] forState:UIControlStateSelected];
            [button setTitleColor:UIColorBlack forState:0];
            [button setTitleColor:UIColorMakeWithHex(@"#2CBCB4") forState:UIControlStateSelected];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = UIColorMakeWithHex(@"#D1D2D3").CGColor;
            [button setImage:UIImageMake(imagesNormal[i]) forState:UIControlStateNormal];
            [button setImage:UIImageMake(imagesSelected[i]) forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.imagePosition = QMUIButtonImagePositionLeft;
            button.spacingBetweenImageAndTitle = 10;
            button.tag = 10000 + i;
            if ([MyTools getPhoneType] == PhoneType_Screen_FULL) {
                button.contentEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
            }
            if (i == 0) {
                [button setTitleColor:UIColorBlack forState:UIControlStateSelected];
                [button setTitleColor:UIColorMakeWithHex(@"#2CBCB4") forState:0];
            }
            [_bottomButtons addSubview:button];
        }
    }
    
    return _bottomButtons;
}

//搜索栏
-(HomeSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[HomeSearchView alloc] initWithFrame:CGRectMake(50, 5, SCREEN_WIDTH - 100, 35)];
        _searchView.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
        _searchView.searchLabel.text = @"搜索TA的状态";
        _searchView.searchLabel.textColor = UIColorBlack;
        __weak __typeof (self)weakSelf = self;
        _searchView.tapSearch = ^{
            DynamicSearchViewController *searchVC = [DynamicSearchViewController new];
            searchVC.ubId = weakSelf.detailModel.ub_id;
            [weakSelf.navigationController pushViewController:searchVC animated:YES];
        };
    }
    
    return _searchView;
}

//导师请求类
-(TeacherRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [[TeacherRequestManagerClass alloc] init];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

//头部视图
-(TeacherDetailHeaderView *)userHeaderView
{
    if (!_userHeaderView) {
        __weak __typeof (self)weakSelf = self;
        _userHeaderView = [[TeacherDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, JXTableHeaderViewHeight)];
        _userHeaderView.tagButton.hidden = [_userType intValue] == 1 ? YES : NO;
        _userHeaderView.followBlock = ^{
            TeacherFansViewController *vc = [TeacherFansViewController new];
            vc.ub_id = weakSelf.detailModel.ub_id;
            vc.type = @"1";
            vc.aboutType = @"2";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _userHeaderView.fansBlock = ^{
            TeacherFansViewController *vc = [TeacherFansViewController new];
            vc.ub_id = weakSelf.detailModel.ub_id;
            vc.type = @"2";
            vc.aboutType = @"2";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _userHeaderView.shareBlock = ^{
            NSLog(@"分享");
        };
    }
    
    return _userHeaderView;
}

//标题栏
-(JXCategoryTitleView *)categoryView
{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, JXheightForHeaderInSection)];
        _categoryView.titles = self.titles;
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.delegate = self;
        _categoryView.titleFont = UIFontMake(16);
        _categoryView.titleSelectedColor = UIColorMakeWithHex(@"#2CBCB4");
        _categoryView.titleColor = UIColorMakeWithHex(@"#909192");
        _categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;

        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineViewColor = UIColorMakeWithHex(@"#2CBCB4");
        lineView.indicatorLineWidth = 60;
        _categoryView.indicators = @[lineView];
    }
    
    return _categoryView;
}

//内容视图
-(JXPagerListRefreshView *)pagerView
{
    if (!_pagerView) {
        _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
        _pagerView.mainTableView.gestureDelegate = self;
        CGFloat bottomHight = [MyTools getPhoneType] == PhoneType_Screen_FULL ? 80 : 60;
        _pagerView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - bottomHight - BaseNavViewHeight - BaseStatusViewHeight);
        _pagerView.backgroundColor = UIColorRed;
    }
    
    return _pagerView;
}

//标题
-(NSArray<NSString *> *)titles
{
    if (!_titles) {
        _titles = [NSArray array];
        if ([_userType intValue] == 1) {
            _titles = @[@"动态", @"游记"];
        }else{
            _titles = @[@"动态", @"介绍", @"路线", @"评价"];
        }
    }
    
    return _titles;
}

//动态页面
-(TeacherDeatailDynamicViewController *)dynamicVC
{
    if (!_dynamicVC) {
        __weak __typeof (self)weakSelf = self;
        _dynamicVC = [TeacherDeatailDynamicViewController new];
        _dynamicVC.selectedDynamicBlock = ^(DynamicListModel *model){
            DynamicDetailPagerViewController *vc = [DynamicDetailPagerViewController new];
            vc.dynamicModel = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _dynamicVC.selectUserBlock = ^(NSString *ubId, NSString *userType) {
            TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
            vc.ub_id = ubId;
            vc.userType = userType;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _dynamicVC.selectTopicBlock = ^(NSString *topicId) {
            TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
            vc.topicId = topicId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _dynamicVC.selectNoteBlock = ^(NSString *noteId) {
            NoteDetailViewController *vc = [NoteDetailViewController new];
            vc.noteId = noteId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    
    return _dynamicVC;
}

#pragma mark - 底部按钮响应事件
-(void)buttonClicked:(QMUIButton *)button
{
    if (button.tag == 10000) {
        button.selected = !button.selected;
        [self.requestManager postFollowTeacherWithAboutType:@"2"
                                                   userType:@"1"
                                                    aboutId:_detailModel.ub_id token:Token
                                                requestName:POST_FOLLOW_USER];
    }
    if (button.tag == 10001) {
        [SVProgressHUD showInfoWithStatus:@"暂未开放"];
    }
    if (button.tag == 10002) {
        if ([_userType intValue] == 1) {
            [SVProgressHUD showErrorWithStatus:@"普通用户不允许评价"];
            return;
        }
        [self showEvaluateView];
    }
}

#pragma mark - 评价页面
-(void)showEvaluateView
{    
    TeacherEvaluateViewController *evaluateVC = [TeacherEvaluateViewController new];
    evaluateVC.tutor_id     = _detailModel.tutor_id;
    evaluateVC.avatar       = _detailModel.avatar;
    evaluateVC.name         = _detailModel.nickname;
    evaluateVC.star         = _detailModel.star;
    [self presentViewController:evaluateVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.statusView.backgroundColor = UIColorMakeWithHex(@"#8DFAC9");
    self.navView.backgroundColor    = UIColorMakeWithHex(@"#8DFAC9");
    self.rightButton.hidden         = YES;
    self.view.backgroundColor       = [UIColor whiteColor];
    
    [self.navView   addSubview:self.searchView];
    [self.view      addSubview:self.pagerView];
    [self.view      addSubview:self.bottomButtons];

    [self.requestManager getTeacherDetailWithTeacherId:_ub_id
                                              userType:@"1"
                                             aboutType:_userType
                                                 token:Token
                                           requestName:GET_TEACHER_DETAIL];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - 数据处理
-(void)handleDetailDataWithData:(NSDictionary *)dic
{
    _detailModel = [[TeacherDetailModel alloc] initModelWithDict:dic];
    _userHeaderView.model = _detailModel;
    _dynamicVC.detailModel = _detailModel;
    
    UIButton *button = [_bottomButtons viewWithTag:10000];
    button.selected = [_detailModel.is_follow intValue] == 0 ? NO : YES;
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_TEACHER_DETAIL]) {
        [self handleDetailDataWithData:info];
    }
    if ([requestName isEqualToString:POST_FOLLOW_USER]) {
        
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return JXTableHeaderViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return JXheightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    __weak __typeof (self)weakSelf = self;
    //动态
    if (index == 0) {
        return self.dynamicVC;
    }
    if (index == 1) {
        //游记
        if ([_userType intValue] == 1) {
            TeacherDetailNoteViewController *vc = [TeacherDetailNoteViewController new];
            vc.ubid = _detailModel.ub_id;
            vc.selectNoteBlock = ^(NoteSearchModel *model) {
                NoteDetailViewController *vc = [NoteDetailViewController new];
                vc.noteId = model.noteId;
                [self.navigationController pushViewController:vc animated:YES];
            };
            return vc;
        }
        //介绍
        TeacherDetailDescriptionViewController *desVC = [TeacherDetailDescriptionViewController new];
        desVC.htmlString = _detailModel.intro;
        return desVC;
    }
    
    //路线
    if (index == 2) {
        TeacherDetailLineViewController *lineVC = [TeacherDetailLineViewController new];
        lineVC.ub_id = _detailModel.ub_id;
        lineVC.selectedLineBlock = ^{
            [weakSelf.navigationController pushViewController:[LineDetailPagerViewController new] animated:YES];
        };
        return lineVC;
    }

    //评价
    if (index == 3) {
        TeacherDetailEvaluateViewController *vc = [TeacherDetailEvaluateViewController new];
        vc.ub_id = _detailModel.ub_id;
        return vc;
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
    [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    //如果你想相邻的两个item切换时，通过有动画滚动实现。未相邻的两个item直接切换，可以用下面这段代码
    /*
    NSInteger diffIndex = labs(categoryView.selectedIndex - index);
     if (diffIndex > 1) {
         [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
     }else {
         [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
     }
     */
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end


