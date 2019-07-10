//
//  DynamicViewController.m
//  STUDIES
//
//  Created by happyi on 2019/3/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryListContainerView.h"
#import "DynamicAttentionViewController.h"
#import "DynamicDynamicViewController.h"
#import "DynamicSearchUserViewController.h"
#import "TrackSubmitViewController.h"
#import "DynamicDetailPagerViewController.h"
#import "TeacherDetailPagerViewController.h"
#import "TopicDetailPagerViewController.h"
#import "NoteDetailViewController.h"
#import "DynamicSearchViewController.h"

@interface DynamicViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, RequestManagerDelegate>

/** 导航切换栏 */
@property (nonatomic, strong) JXCategoryTitleView *titleView;
/** 内容视图 */
@property (nonatomic, strong) JXCategoryListContainerView *containerView;
/** 搜索按钮 */
@property (nonatomic, strong) QMUIButton *searchButton;
/** 添加按钮 */
@property (nonatomic, strong) QMUIButton *addButton;

@end

@implementation DynamicViewController

#pragma mark - lazy
-(JXCategoryTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
        _titleView.delegate = self;
        _titleView.titles = @[@"我的关注", @"动态"];
        _titleView.titleColorGradientEnabled = YES;
        _titleView.titleSelectedColor = UIColorWhite;
        _titleView.titleColor = UIColorWhite;
        _titleView.titleFont = UIFontMake(20);
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineViewColor = UIColorWhite;
        lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
        _titleView.indicators = @[lineView];
    }
    
    return _titleView;
}

-(JXCategoryListContainerView *)containerView
{
    if (!_containerView) {
        _containerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    }
    
    return _containerView;
}

- (QMUIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = [QMUIButton new];
        [_searchButton setBackgroundImage:UIImageMake(@"dynamic_icon_search") forState:0];
        [_searchButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _searchButton;
}

- (QMUIButton *)addButton
{
    if (!_addButton) {
        _addButton = [QMUIButton new];
        [_addButton setImage:UIImageMake(@"dynamic_icon_add") forState:0];
        [_addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.leftButton.hidden = YES;
    [self.navView addSubview:self.titleView];
    [self.navView addSubview:self.searchButton];
    [self.navView addSubview:self.addButton];
    [self.view addSubview:self.containerView];
    
    self.titleView.contentScrollView = self.containerView.scrollView;

    
    _titleView.sd_layout
    .centerXEqualToView(self.navView)
    .centerYEqualToView(self.navView)
    .widthIs(200)
    .heightIs(40);
    
    _searchButton.sd_layout
    .leftSpaceToView(self.navView, 15)
    .centerYEqualToView(self.navView)
    .widthIs(28)
    .heightEqualToWidth();
    
    _addButton.sd_layout
    .rightSpaceToView(self.navView, 15)
    .centerYEqualToView(self.navView)
    .widthIs(40)
    .heightEqualToWidth();
    
    _containerView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, BaseTabBarViewHeight);
    
    
}

#pragma mark - 搜索
-(void)searchClick
{
    [self.navigationController pushViewController:[DynamicSearchViewController new] animated:YES];
}

#pragma mark - 发布
-(void)addClick
{
    [self.navigationController pushViewController:[TrackSubmitViewController new] animated:YES];
}

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 2;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        DynamicAttentionViewController *vc = [DynamicAttentionViewController new];
        vc.selectDynamicBlock = ^(DynamicListModel *model) {
            DynamicDetailPagerViewController *vc = [DynamicDetailPagerViewController new];
            vc.dynamicModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        };
        vc.selectUserBlock = ^(NSString *ubId, NSString *userType) {
            TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
            vc.ub_id = ubId;
            vc.userType = userType;
            [self.navigationController pushViewController:vc animated:YES];
        };
        vc.selectTopicBlock = ^(NSString *topicId) {
            TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
            vc.topicId = topicId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        vc.selectNoteBlock = ^(NSString *noteId) {
            NoteDetailViewController *vc = [NoteDetailViewController new];
            vc.noteId = noteId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return vc;
    }
    if (index == 1) {
        DynamicDynamicViewController *vc = [DynamicDynamicViewController new];
        vc.selectDynamicBlock = ^(DynamicListModel *model) {
            DynamicDetailPagerViewController *vc = [DynamicDetailPagerViewController new];
            vc.dynamicModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        };
        vc.selectUserBlock = ^(NSString *ubId, NSString *userType) {
            TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
            vc.ub_id = ubId;
            vc.userType = userType;
            [self.navigationController pushViewController:vc animated:YES];
        };
        vc.selectTopicBlock = ^(NSString *topicId) {
            TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
            vc.topicId = topicId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        vc.selectNoteBlock = ^(NSString *noteId) {
            NoteDetailViewController *vc = [NoteDetailViewController new];
            vc.noteId = noteId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return vc;
    }
    
    return nil;
}

//传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.containerView didClickSelectedItemAtIndex:index];
}

//传递scrolling事件给listContainerView，必须调用！！！
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.containerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
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
