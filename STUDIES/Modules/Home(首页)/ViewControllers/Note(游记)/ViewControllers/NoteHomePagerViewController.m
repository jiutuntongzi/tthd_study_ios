//
//  NoteHomePagerViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteHomePagerViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleImageView.h"
#import "HomeSearchView.h"
#import "ConditionViewController.h"
#import "NoteHomeContainerAllView.h"
#import "NoteHomeContainerTopView.h"
#import "NoteSearchViewController.h"
#import "NoteSubmitViewController.h"
#import "NoteDetailViewController.h"
#import "CommonRequestManagerClass.h"
#import "NoteListModel.h"
#import "BannerModel.h"
#import "TeacherTypeModel.h"
#import "JXPagerListRefreshView.h"

typedef NS_ENUM(NSInteger, CurrentType) {
    CurrentType_Left,
    CurrentType_Right
};

static const CGFloat HeaderViewHeight = 180;
static const CGFloat HeightForHeaderInSection = 50;

@interface NoteHomePagerViewController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate, RequestManagerDelegate, ImagePlayerViewDelegate>

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
/** 弹出菜单 */
@property (nonatomic, strong) ConditionViewController *conditionVC;
/** 分类1 */
@property (nonatomic, strong) NoteHomeContainerAllView *allView;
/** 分类2 */
@property (nonatomic, strong) NoteHomeContainerTopView *topView;
/** 发布按钮 */
@property (nonatomic, strong) QMUIButton *submitButton;
/** 请求类 */
@property (nonatomic, strong) CommonRequestManagerClass *commonRequestManager;
/** banner数据 */
@property (nonatomic, strong) NSMutableArray <BannerModel *> *bannerArray;
/** 类别 */
@property (nonatomic, strong) NSMutableArray <TeacherTypeModel *> *typeArray;
/** 选中的分类 */
@property (nonatomic, strong) TeacherTypeModel *selectedModel;

@end

@implementation NoteHomePagerViewController

#pragma mark - lazy
//内容视图
-(JXPagerListRefreshView *)pagerView
{
    if (!_pagerView) {
        _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];;
        _pagerView.mainTableView.gestureDelegate = self;
        _pagerView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight);
    }
    
    return _pagerView;
}

//标题
-(JXCategoryTitleImageView *)categoryView
{
    if (!_categoryView) {
        NSArray *images = @[@"teacher_icon_down", @"teacher_icon_dow"];
        NSArray *slectedimages = @[@"teacher_icon_down", @"teacher_icon_dow"];
        
        _categoryView = [[JXCategoryTitleImageView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, HeightForHeaderInSection)];
        _categoryView.titles = @[[self.typeArray[0] name], @"精选游记"];
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

//banner
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

//下划线
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
        _searchView.searchLabel.text = @"搜索游记";
        __weak __typeof (self)weakSelf = self;
        _searchView.tapSearch = ^{
            [weakSelf.navigationController pushViewController:[NoteSearchViewController new] animated:YES];
        };
    }
    
    return _searchView;
}

//筛选条件
-(ConditionViewController *)conditionVC
{
    if (!_conditionVC) {
        __weak __typeof (self)weakSelf = self;
        _conditionVC = [ConditionViewController new];
        _conditionVC.selectedTypeBlock = ^(id  _Nonnull model) {
            TeacherTypeModel *iModel = (TeacherTypeModel *)model;
            weakSelf.allView.selectedModel = iModel;
            weakSelf.selectedModel = iModel;
            weakSelf.categoryView.titles = @[iModel.name, @"精选游记"];
            [weakSelf.categoryView reloadData];
            [weakSelf.conditionVC hideInView:weakSelf.allView animated:YES completion:nil];
        };
    }
    
    return _conditionVC;
}

//内容1
-(NoteHomeContainerAllView *)allView
{
    if (!_allView) {
        _allView = [[NoteHomeContainerAllView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight - HeightForHeaderInSection)];
        __weak __typeof (self)weakSelf = self;
        _allView.selectedNoteBlock = ^(NoteListModel *model) {
            NoteDetailViewController *vc = [NoteDetailViewController new];
            vc.noteId = model.noteId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }; 
        _allView.tapImageBlock = ^(NSArray *imageUrls, NSInteger currentIndex) {
            [weakSelf showPhotoBrowserWithUrls:imageUrls currentIndex:currentIndex];
        };
    }
    
    return _allView;
}

//内容2
- (NoteHomeContainerTopView *)topView
{
    if (!_topView) {
        _topView = [[NoteHomeContainerTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight - HeightForHeaderInSection)];
        __weak __typeof (self)weakSelf = self;
        _topView.selectedNoteBlock = ^(NoteListModel *model) {
            NoteDetailViewController *vc = [NoteDetailViewController new];
            vc.noteId = model.noteId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _topView.requestFinishBlock = ^{
            [weakSelf.pagerView.mainTableView.mj_header endRefreshing];
        };
        _topView.tapImageBlock = ^(NSArray *imageUrls, NSInteger currentIndex) {
            [weakSelf showPhotoBrowserWithUrls:imageUrls currentIndex:currentIndex];
        };
    }
    
    return _topView;
}

//发布按钮
-(QMUIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [QMUIButton new];
        [_submitButton setTitle:@"发布" forState:0];
        [_submitButton setTitleColor:UIColorBlack forState:0];
        [_submitButton setBackgroundColor:UIColorMakeWithHex(@"#FEDB5C")];
        _submitButton.titleLabel.font = UIFontMake(17);
        _submitButton.layer.cornerRadius = 6;
        [_submitButton addTarget:self action:@selector(submitNote) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _submitButton;
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

//筛选条件
-(NSMutableArray<TeacherTypeModel *> *)typeArray
{
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
        NSArray *titles = @[@"最新时间", @"浏览数从高到低", @"评论数从高到低", @"收藏数从高到低"];
        NSArray *ids = @[@"1", @"2", @"3", @"4"];
        for (int i = 0; i < titles.count; i ++) {
            TeacherTypeModel *model = [TeacherTypeModel new];
            model.name = titles[i];
            model.typeId = ids[i];
            [_typeArray addObject:model];
        }
        
        self.selectedModel = _typeArray[0];
        self.allView.selectedModel = self.selectedModel;
    }
    
    return _typeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _bannerArray  = [NSMutableArray array];
    
    [self.navView   addSubview:self.searchView];
    [self.navView   addSubview:self.submitButton];
    [self.view      addSubview:self.pagerView];

    
    [self.imagePlayerView reloadData];
    
    _submitButton.sd_layout
    .centerYEqualToView(self.navView)
    .rightSpaceToView(self.navView, 15)
    .heightIs(30)
    .widthIs(65);
    
    _searchView.sd_layout
    .leftSpaceToView(self.navView, 50)
    .rightSpaceToView(_submitButton, 15)
    .centerYEqualToView(self.navView)
    .heightIs(35);
    
    //获取banner
    [self getBanner];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - 发布游记
-(void)submitNote
{
    NoteSubmitViewController *vc = [NoteSubmitViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取banner
-(void)getBanner
{
    [self.commonRequestManager getBannerWithPosition:@"travels"
                                         requestName:GET_BANNER];
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
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    //baner
    if ([requestName isEqualToString:GET_BANNER]) {
        for (NSDictionary *dict in info) {
            BannerModel *model = [[BannerModel alloc] initModelWithDict:dict];
            [_bannerArray addObject:model];
        }
        if (_bannerArray.count == 1) {
            _imagePlayerView.scrollInterval = 0;
        }
        [_imagePlayerView reloadData];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [SVProgressHUD showErrorWithStatus:@"banner获取失败"];
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
        return self.allView;
    }else
        return self.topView;
}

#pragma mark - JXCategoryViewDelegate
-(void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    if (index == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.pagerView.mainTableView.contentOffset = CGPointMake(0, HeaderViewHeight);
        } completion:^(BOOL finished) {
            self.conditionVC.dataSourceArray = self.typeArray;;
            self.conditionVC.selectedModel = self.selectedModel;
            [self.conditionVC showInView:self.allView animated:YES completion:nil];
        }];
        [UIView commitAnimations];
    }
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
//    if (index == 1 && _topDataArray.count == 0) {
//        _curType = 2;
//        [self.requestManager getNoteListWithType:@"2" sort_type:@"" offset:StringWithInt(_all_offset) limit:StringWithInt(_limit) requestName:GET_NOTE_LIST];
//    }
}

#pragma mark - JXPagerMainTableViewGestureDelegate

//- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
//    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
//        return NO;
//    }
//    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
//}

#pragma mark - 浏览图片
-(void)showPhotoBrowserWithUrls:(NSArray *)urls currentIndex:(NSInteger)index
{
    NSMutableArray *photos = [NSMutableArray new];
    [urls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:obj];
        
        [photos addObject:photo];
    }];
    
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.loadStyle = GKPhotoBrowserLoadStyleDeterminate;
    [browser showFromVC:self];
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
