//
//  DynamicDetailPagerViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicDetailPagerViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXPagerView.h"
#import "JXCategoryTitleView.h"
#import "DynamicDetailHeaderView.h"
#import "PopViewController.h"
#import "DynamicDetailCommentViewController.h"
#import "DynamicDetailPraiseViewController.h"
#import "DynamicReplyViewController.h"
#import "DynamicRequestManagerClass.h"
#import "TeacherDetailPagerViewController.h"
#import "TopicDetailPagerViewController.h"
#import "NoteDetailViewController.h"
#import "TeacherRequestManagerClass.h"
#import "CommonRequestManagerClass.h"
#import "DynamicCommentListViewController.h"
#import "JXPagerListRefreshView.h"
static const CGFloat HeightForHeaderInSection = 40;

@interface DynamicDetailPagerViewController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate, RequestManagerDelegate>

/** 分享按钮 */
@property (nonatomic, strong) QMUIButton *shareButton;
/** 主父视图 */
@property (nonatomic, strong) JXPagerView *pagerView;
/** 头部视图 */
@property (nonatomic, strong) DynamicDetailHeaderView *dynamicHeaderView;
/** 标题栏 */
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
/** 下划线 */
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
/** 头部视图高度 */
@property (nonatomic, assign) CGFloat headerViewHeight;
/** 是否已关注 */
@property (nonatomic, assign) BOOL isFollowed;
/** 底部按钮 */
@property (nonatomic, strong) UIView *bottomButtons;
/** 评论页 */
@property (nonatomic, strong) DynamicDetailCommentViewController *commentVC;
/** 点赞页 */
@property (nonatomic, strong) DynamicDetailPraiseViewController *praiseVC;
/** 请求类 */
@property (nonatomic, strong) DynamicRequestManagerClass *dynamicRequestManager;
@property (nonatomic, strong) TeacherRequestManagerClass *teacherRequestManager;
@property (nonatomic, strong) CommonRequestManagerClass  *commonReqeustManager;
@end

@implementation DynamicDetailPagerViewController

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

-(DynamicDetailHeaderView *)dynamicHeaderView
{
    @weakify(self)
    if (!_dynamicHeaderView) {
        @strongify(self)
        _dynamicHeaderView = [[DynamicDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.headerViewHeight)];
        _dynamicHeaderView.dynamicModel = self.dynamicModel;
        _dynamicHeaderView.tapContent = ^(NSDictionary *userInfo, NSString *content) {
            if ([content containsString:@"@"]) {
                //个人
                TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
                vc.ub_id = userInfo[@"id"];
                vc.userType = userInfo[@"usertype"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([content containsString:@"#"]){
                //话题
                TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
                vc.topicId = userInfo[@"id"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([content containsString:@"《"]){
                //游记
                NoteDetailViewController *vc = [NoteDetailViewController new];
                vc.noteId = userInfo[@"id"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        _dynamicHeaderView.followBlock = ^(QMUIButton *button, DynamicListModel *model) {
            [self showPopViewWithSourceView:button model:model];
        };
    }
    
    return _dynamicHeaderView;
}

-(JXCategoryTitleView *)categoryView
{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
        _categoryView.titles = @[[NSString stringWithFormat:@"评论%@", _dynamicModel.comments], [NSString stringWithFormat:@"点赞%@", _dynamicModel.likes]];
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.delegate = self;
        _categoryView.titleFont = UIFontMake(15);
        _categoryView.titleSelectedColor = UIColorMakeWithHex(@"#2CBCB4");
        _categoryView.titleColor = UIColorMakeWithHex(@"#909192");
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = YES;
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
        CGFloat bottomHight = [MyTools getPhoneType] == PhoneType_Screen_FULL ? 80 : 50;
        _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
        _pagerView.mainTableView.gestureDelegate = self;
        _pagerView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight - bottomHight);
    }
    
    return _pagerView;
}

-(UIView *)bottomButtons
{
    if (!_bottomButtons) {
        CGFloat bottomHight = [MyTools getPhoneType] == PhoneType_Screen_FULL ? 80 : 50;
        
        _bottomButtons = [UIView new];
        _bottomButtons.backgroundColor = UIColorWhite;
        
        _bottomButtons.frame = CGRectMake(0, SCREEN_HEIGHT - bottomHight, SCREEN_WIDTH, bottomHight);
        
        NSArray *titlesNormal = @[@"回复", @"赞"];
        NSArray *imagesNormal = @[@"teacher_icon_comment", @"teacher_icon_praise_normal"];
        NSArray *imagesSelected = @[@"", @"teacher_icon_praise_selected"];
        
        for (int i = 0; i < 2; i ++) {
            QMUIButton *button = [QMUIButton new];
            button.frame = CGRectMake(SCREEN_WIDTH / 2 * i, 0, SCREEN_WIDTH / 2, bottomHight);
            [button setTitle:titlesNormal[i] forState:0];
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
            if (i == 1) {
                button.selected = [_dynamicModel.is_likes intValue] == 1 ? YES : NO;
            }
            [_bottomButtons addSubview:button];
        }
    }
    
    return _bottomButtons;
}

-(DynamicRequestManagerClass *)dynamicRequestManager
{
    if (!_dynamicRequestManager) {
        _dynamicRequestManager = [DynamicRequestManagerClass new];
        _dynamicRequestManager.delegate = self;
    }
    
    return _dynamicRequestManager;
}

-(TeacherRequestManagerClass *)teacherRequestManager
{
    if (!_teacherRequestManager) {
        _teacherRequestManager = [TeacherRequestManagerClass new];
        _teacherRequestManager.delegate = self;
    }
    
    return _teacherRequestManager;
}

-(CommonRequestManagerClass *)commonReqeustManager
{
    if (!_commonReqeustManager) {
        _commonReqeustManager = [CommonRequestManagerClass new];
        _commonReqeustManager.delegate = self;
    }
    
    return _commonReqeustManager;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.view addSubview:self.pagerView];
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    self.categoryView.indicators = @[self.lineView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    //初始化评论页面
    [self initCommentVC];
    
    _praiseVC = [DynamicDetailPraiseViewController new];
    
    self.titleLabel.text = @"动态详情";
    [self.navView addSubview:self.shareButton];
    [self.view addSubview:self.bottomButtons];
    
//    _shareButton.sd_layout
//    .rightSpaceToView(self.navView, 20)
//    .centerYEqualToView(self.navView)
//    .widthIs(30)
//    .heightEqualToWidth();

    [self getHeaderViewHeight];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - 初始化评论页面
-(void)initCommentVC
{
    @weakify(self)
    _commentVC = [DynamicDetailCommentViewController new];
    _commentVC.replyBlock = ^(NSString *dynamicId, NSString *commentId) {
        @strongify(self)
        [self pushReplyWithDynamicId:dynamicId parentId:commentId];
    };
    _commentVC.replyListBlock = ^(NSString *dynamicId, DynamicCommentModel *model) {
        @strongify(self)
        DynamicCommentListViewController *vc = [DynamicCommentListViewController new];
        vc.dynamicId = dynamicId;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    };
    _commentVC.selectUserBlock = ^(NSString *ubId, NSString *userType) {
        @strongify(self)
        TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
        vc.ub_id = ubId;
        vc.userType = userType;
        [self.navigationController pushViewController:vc animated:YES];
    };
    _commentVC.selectTopicBlock = ^(NSString *topicId) {
        @strongify(self)
        TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
        vc.topicId = topicId;
        [self.navigationController pushViewController:vc animated:YES];
    };
    _commentVC.selectNoteBlock = ^(NSString *noteId) {
        @strongify(self)
        NoteDetailViewController *vc = [NoteDetailViewController new];
        vc.noteId = noteId;
        [self.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - 跳转回复
-(void)pushReplyWithDynamicId:(NSString *)dynamicId parentId:(NSString *)parentId
{
    @weakify(self)
    DynamicReplyViewController *vc = [DynamicReplyViewController new];
    vc.dynamicId = dynamicId;
    vc.parentId = parentId;
    vc.submitSuccessBlock = ^{
        @strongify(self)
        [self.commentVC refresh];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 需在子视图开始创建之前先获取到headerview经过sdlayout布局之后的高度
-(void)getHeaderViewHeight
{
    DynamicDetailHeaderView *layoutView = [[DynamicDetailHeaderView alloc] init];
    layoutView.dynamicModel = self.dynamicModel;
    [self.view addSubview:layoutView];
    layoutView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .autoHeightRatio(0);
    
    __weak __typeof (layoutView)weakView = layoutView;
    __weak __typeof (self)weakSelf = self;
    layoutView.didFinishAutoLayoutBlock = ^(CGRect frame) {
        [weakView removeFromSuperviewAndClearAutoLayoutSettings];
        if (frame.size.height > 0) {
            weakSelf.headerViewHeight = frame.size.height;
        }
    };
}

#pragma mark - 分享
-(void)sharedClick
{
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    moreOperationController.items = @[
                                      @[
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"微信好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
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

#pragma mark - 底部按钮
-(void)buttonClicked:(QMUIButton *)button
{
    if (button.tag == 10000) {
        [self pushReplyWithDynamicId:_dynamicModel.dynamicId parentId:@""];
    }else{
        if (button.selected == YES) {
            return;
        }
        //点赞
        [self.dynamicRequestManager postDynamicPraiseWithToken:Token
                                              dynamicId:_dynamicModel.dynamicId
                                            reqeustName:POST_DYNAMIC_PRAISE];
        button.selected = YES;
    }
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:POST_DYNAMIC_PRAISE]) {
        [SVProgressHUD showSuccessWithStatus:@"已点赞"];
        [_praiseVC refresh];
    }
    if ([requestName isEqualToString:POST_FOLLOW_USER]) {
        if ([info[@"sign"] intValue] == 0) {
            _dynamicModel.is_follow = @"0";
        }else{
            _dynamicModel.is_follow = @"1";
        }
        _dynamicHeaderView.dynamicModel = _dynamicModel;
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.dynamicHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.headerViewHeight;
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
        _commentVC.dynamicModel = _dynamicModel;
        return _commentVC;
    }
    if (index == 1) {
        _praiseVC.dynamicModel = _dynamicModel;
        return _praiseVC;
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

#pragma mark - 展示操作菜单
-(void)showPopViewWithSourceView:(UIView *)sourceView model:(DynamicListModel *)model
{
    QMUIButton *button = (QMUIButton *)sourceView;
    NSArray *titles = @[button.titleLabel.text, @"投诉"];
    QMUIPopupMenuView *menuView = [[QMUIPopupMenuView alloc] init];
    menuView.automaticallyHidesWhenUserTap = YES;
    menuView.shouldShowItemSeparator = YES;
    menuView.maskViewBackgroundColor = UIColorClear;
    menuView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;
    menuView.itemTitleColor = UIColorMakeWithHex(@"#999999");
    NSMutableArray<QMUIPopupMenuButtonItem *> *itmes = [NSMutableArray array];
    for (int i = 0; i < titles.count; i ++) {
        QMUIPopupMenuButtonItem *item = [QMUIPopupMenuButtonItem itemWithImage:nil title:titles[i] handler:^(QMUIPopupMenuButtonItem *aItem) {
            __weak __typeof(self)weakSelf = self;
            if (i == 0) {
                [self.teacherRequestManager postFollowTeacherWithAboutType:[model.user[@"is_tutor"] intValue] == 0 ? @"1" : @"2"
                                                                  userType:@"1"
                                                                   aboutId:model.ub_id
                                                                     token:Token
                                                               requestName:POST_FOLLOW_USER];
            }else{
                [weakSelf showConplainViewWithModel:model];
            }
            
            [menuView hideWithAnimated:YES];
        }];
        [itmes addObject:item];
    }
    menuView.items = [itmes copy];
    menuView.sourceView = sourceView;
    [menuView showWithAnimated:YES];
}

#pragma mark - 展示投诉视图
-(void)showConplainViewWithModel:(DynamicListModel *)model
{
    PopViewController *popVC = [PopViewController new];
    popVC.submitBlock = ^(NSString *reason) {
        [self.commonReqeustManager getReportWithPosition:@"5"
                                                 content:reason
                                              complaints:@""
                                               foreignId:model.dynamicId
                                                   token:Token
                                             requestName:GET_REPORT];
        [QMUITips showSucceed:@"已投诉"];
    };
    [popVC showWithAnimated:YES completion:nil];
}
@end
