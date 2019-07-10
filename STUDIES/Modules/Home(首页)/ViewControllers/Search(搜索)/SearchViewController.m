//
//  SearchViewController.m
//  STUDIES
//
//  Created by 花想容 on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "SearchViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryListContainerView.h"
#import "SearchLineViewController.h"
#import "SearchTeacherViewController.h"
#import "SearchNoteViewController.h"
#import "SearchTopicViewController.h"
#import "SearchUserViewController.h"
#import "PageIndexModel.h"
#import "LineDetailNewViewController.h"
#import "TeacherDetailPagerViewController.h"
#import "NoteDetailViewController.h"
#import "TopicDetailPagerViewController.h"

@interface SearchViewController ()<UISearchBarDelegate, JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

/** 搜索栏 */
@property(nonatomic, strong) UISearchBar *mySearchBar;
/** 导航切换栏 */
@property (nonatomic, strong) JXCategoryTitleView *titleView;
/** 内容视图 */
@property (nonatomic, strong) JXCategoryListContainerView *containerView;
/** 当前页面 */
@property (nonatomic, strong) PageIndexModel *indexModel;
/** 子视图控制器 */
@property (nonatomic, strong) SearchLineViewController      *lineVC;
@property (nonatomic, strong) SearchTeacherViewController   *teacherVC;
@property (nonatomic, strong) SearchNoteViewController      *noteVC;
@property (nonatomic, strong) SearchTopicViewController     *topicVC;
@property (nonatomic, strong) SearchUserViewController      *userVC;
@end

@implementation SearchViewController

#pragma mark - lazy
-(UISearchBar *)mySearchBar
{
    if (!_mySearchBar) {
        _mySearchBar = [[UISearchBar alloc] init];
        _mySearchBar.placeholder = @"请输入关键字";
        _mySearchBar.searchBarStyle = UISearchBarStyleDefault;
        _mySearchBar.barStyle = UISearchBarStyleDefault;
        _mySearchBar.backgroundImage = [[UIImage alloc] init];
        _mySearchBar.delegate = self;
        
        UIView *backgroundView = [_mySearchBar subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];
        backgroundView.layer.cornerRadius = 18;
        backgroundView.clipsToBounds = YES;
        
    }
    
    return _mySearchBar;
}

-(JXCategoryTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
        _titleView.delegate = self;
        _titleView.titles = @[@"路线", @"导师", @"游记", @"话题", @"用户"];
        _titleView.titleColorGradientEnabled = YES;
        _titleView.titleSelectedColor = BaseNavBarColor;
        _titleView.titleColor = UIColorGray;
        _titleView.titleFont = UIFontMake(20);
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineViewColor = BaseNavBarColor;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _indexModel = [PageIndexModel new];
    _indexModel.index = 1;
    
    __weak __typeof (self)weakSelf = self;
    
    _lineVC     = [SearchLineViewController new];
    _lineVC.selectLineBlock = ^(LineThemeItemModel *model) {
        LineDetailNewViewController *vc = [LineDetailNewViewController new];
        vc.lineId = model.pId;
        vc.tutorId = model.tutor_id;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    
    _teacherVC  = [SearchTeacherViewController new];
    _teacherVC.selectTeacherBlock = ^(TeacherModel *model) {
        TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
        vc.ub_id = model.ub_id;
        vc.userType = @"2";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    
    _noteVC     = [SearchNoteViewController new];
    _noteVC.selectNoteBlock = ^(NoteSearchModel *model) {
        NoteDetailViewController *vc = [NoteDetailViewController new];
        vc.noteId = model.noteId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    
    _topicVC    = [SearchTopicViewController new];
    _topicVC.selectTopicBlock = ^(TopicListModel *model) {
        TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
        vc.topicModel = model;
        vc.topicId = model.topicId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    _userVC     = [SearchUserViewController new];
    _userVC.selectUserBlock = ^(HomeUserModel *model) {
        TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
        vc.ub_id = model.ub_id;
        vc.userType = @"1";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //观察页面值的变化
    [_indexModel addObserver:self
                  forKeyPath:@"index"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
    
    self.leftButton.hidden = YES;
    [self.rightButton setTitle:@"取消" forState:0];
    [self.rightButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mySearchBar];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.containerView];

    self.titleView.contentScrollView = self.containerView.scrollView;
    
    _mySearchBar.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, BaseStatusViewHeight - 5)
    .rightSpaceToView(self.view, 60)
    .heightIs(BaseNavViewHeight + 10);
    
    _titleView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .heightIs(40);
    
    _containerView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight + 40)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self searchBarSearchButtonClicked:_mySearchBar];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_mySearchBar resignFirstResponder];
    switch (_indexModel.index) {
        case 1:
            _lineVC.keyword     = searchBar.text;
            break;
        case 2:
            _teacherVC.keyword  = searchBar.text;
            break;
        case 3:
            _noteVC.keyword     = searchBar.text;
            break;
        case 4:
            _topicVC.keyword    = searchBar.text;
            break;
        case 5:
            _userVC.keyword     = searchBar.text;
            break;
        default:
            break;
    }
}

#pragma mark - 返回
-(void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 5;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return _lineVC;
    }
    if (index == 1) {
        return _teacherVC;
    }
    if (index == 2) {
        return _noteVC;
    }
    if (index == 3) {
        return _topicVC;
    }
    if (index == 4) {
        return _userVC;
    }
    
    return nil;
}

//传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    _indexModel.index = index + 1;
    
    [self.containerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index
{
    _indexModel.index = index + 1;
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
