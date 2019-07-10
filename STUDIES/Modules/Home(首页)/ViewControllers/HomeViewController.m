//
//  HomeViewController.m
//  STUDIES
//
//  Created by happyi on 2019/3/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeBannerCell.h"
#import "HomeMenuCell.h"
#import "HomeRecommendCell.h"
#import "HomeHotCell.h"
#import "HomeInteractCell.h"
#import "HomeTeacherCell.h"
#import "HomeLineCell.h"
#import "HomeTravelCell.h"
#import "Track1ViewController.h"
#import "StudyViewController.h"
#import "InteractViewController.h"
#import "HomeMenuViewController.h"
#import "TeacherHomePagerViewController.h"
#import "NoteHomePagerViewController.h"
#import "TopicHomePagerViewController.h"
#import "TopicDetailPagerViewController.h"
#import "InteractDetailViewController.h"
#import "TeacherDetailPagerViewController.h"
#import "LineDetailPagerViewController.h"
#import "NoteDetailViewController.h"
#import "TrackSubmitViewController.h"
#import "NoteSubmitViewController.h"
#import "HomeRequestManagerClass.h"
#import "BannerModel.h"
#import "HomeTheamModel.h"
#import "HomeTopicModel.h"
#import "HomeTutorModel.h"
#import "HomePathModel.h"
#import "HomeTravelModel.h"
#import "NoteListModel.h"
#import "CommonRequestManagerClass.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "LinePlaceDetailViewController.h"
#import "HomeCallModel.h"

@interface HomeViewController()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate>
/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 首页请求类 */
@property(nonatomic, strong) HomeRequestManagerClass *homeRequestManager;
/** 公共请求类 */
@property(nonatomic, strong) CommonRequestManagerClass *commonRequestManger;
/** banner数据 */
@property(nonatomic, strong) NSMutableArray <BannerModel *> *bannerArray;
/** 推荐活动数据 */
@property(nonatomic, strong) NSMutableArray <HomeTheamModel *> *theamsArray;
/** 话题数据 */
@property(nonatomic, strong) NSMutableArray <HomeTopicModel *> *topicsArray;
/** 导师数据 */
@property(nonatomic, strong) NSMutableArray <HomeTutorModel *> *tutorsArray;
/** 路线数据 */
@property(nonatomic, strong) NSMutableArray <HomePathModel *> *pathsArray;
/** 游记数据 */
@property(nonatomic, strong) NSMutableArray <HomeTravelModel *> *travelsArray;
/** 互动的数据 */
@property(nonatomic, strong) NSMutableArray <HomeCallModel *> *callsArray;

@end

@implementation HomeViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        [_mainTableView registerClass:[HomeBannerCell class]
               forCellReuseIdentifier:NSStringFromClass([HomeBannerCell class])];
        [_mainTableView registerClass:[HomeMenuCell class]
               forCellReuseIdentifier:NSStringFromClass([HomeMenuCell class])];
        [_mainTableView registerClass:[HomeRecommendCell class] forCellReuseIdentifier:NSStringFromClass([HomeRecommendCell class])];
        [_mainTableView registerClass:[HomeHotCell class]
               forCellReuseIdentifier:NSStringFromClass([HomeHotCell class])];
        [_mainTableView registerClass:[HomeInteractCell class]
               forCellReuseIdentifier:NSStringFromClass([HomeInteractCell class])];
        [_mainTableView registerClass:[HomeTeacherCell class]
               forCellReuseIdentifier:NSStringFromClass([HomeTeacherCell class])];
        [_mainTableView registerClass:[HomeLineCell class]
               forCellReuseIdentifier:NSStringFromClass([HomeLineCell class])];
        [_mainTableView registerClass:[HomeTravelCell class]
               forCellReuseIdentifier:NSStringFromClass([HomeTravelCell class])];
    }
    
    return _mainTableView;
}

-(HomeRequestManagerClass *)homeRequestManager
{
    if (!_homeRequestManager) {
        _homeRequestManager = [[HomeRequestManagerClass alloc] init];
        _homeRequestManager.delegate = self;
    }
    
    return _homeRequestManager;
}

-(CommonRequestManagerClass *)commonRequestManger
{
    if (!_commonRequestManger) {
        _commonRequestManger = [[CommonRequestManagerClass alloc] init];
        _commonRequestManger.delegate = self;
    }
    
    return _commonRequestManger;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = @"首页";
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    
    [self.view addSubview:self.mainTableView];
    
    _bannerArray    = [NSMutableArray array];
    _theamsArray    = [NSMutableArray array];
    _topicsArray    = [NSMutableArray array];
    _tutorsArray    = [NSMutableArray array];
    _pathsArray     = [NSMutableArray array];
    _travelsArray   = [NSMutableArray array];
    _callsArray     = [NSMutableArray array];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, -44)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, BaseTabBarViewHeight);
    
    
    //获取首页数据
    [self getHome];
    //获取banner
    [self getBanner];
}

#pragma mark - 刷新
-(void)refresh
{
    [_mainTableView.mj_header endRefreshing];
}

#pragma mark - 获取首页
-(void)getHome
{
    NSString *ubid = @"";
    if (Token) {
        UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
        ubid = model.ub_id;
    }
    [self.homeRequestManager getHomeWithUbId:ubid
                                 requestName:GET_HOME];
}

#pragma mark - 获取banner
-(void)getBanner
{
    [self.commonRequestManger getBannerWithPosition:BannerPosition_Index
                                        requestName:GET_BANNER];
}

#pragma mark - 初始化菜单
-(void)showMenuWithView:(UIView *)view
{
    @weakify(self)
    HomeMenuViewController *vc = [HomeMenuViewController new];
    vc.dynamicBlock = ^{
        @strongify(self)
        [self.navigationController pushViewController:[TrackSubmitViewController new] animated:YES];
    };
    vc.noteBlock = ^{
        @strongify(self)
        [self.navigationController pushViewController:[NoteSubmitViewController new] animated:YES];
    };
    vc.recruitBlock = ^{
        NSLog(@"招募导师");
    };
    [vc showWithAnimated:YES completion:nil];
}

#pragma mark - 处理首页数据
-(void)handleHomeDataWithData:(NSDictionary *)dataDic
{
    //推荐活动
    for (NSDictionary *dic in dataDic[@"theams"]) {
        HomeTheamModel *model = [[HomeTheamModel alloc] initModelWithDict:dic];
        [_theamsArray addObject:model];
    }
    [_mainTableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    
    //话题
    for (NSDictionary *dic in dataDic[@"topics"]) {
        HomeTopicModel *model = [[HomeTopicModel alloc] initModelWithDict:dic];
        [_topicsArray addObject:model];
    }
    [_mainTableView reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
    //互动
    for (NSDictionary *dic in dataDic[@"interactions"]) {
        HomeCallModel *model = [[HomeCallModel alloc] initModelWithDict:dic];
        [_callsArray addObject:model];
    }
    [_mainTableView reloadSection:4 withRowAnimation:UITableViewRowAnimationNone];
    //导师
    for (NSDictionary *dic in dataDic[@"tutors"]) {
        HomeTutorModel *model = [[HomeTutorModel alloc] initModelWithDict:dic];
        [_tutorsArray addObject:model];
    }
    [_mainTableView reloadSection:5 withRowAnimation:UITableViewRowAnimationNone];
    
    //路线
    for (NSDictionary *dic in dataDic[@"path"]) {
        HomePathModel *model = [[HomePathModel alloc] initModelWithDict:dic];
        [_pathsArray addObject:model];
    }
    [_mainTableView reloadSection:6 withRowAnimation:UITableViewRowAnimationNone];
    
    //游记
    for (NSDictionary *dic in dataDic[@"travels"]) {
        HomeTravelModel *model = [[HomeTravelModel alloc] initModelWithDict:dic];
        [_travelsArray addObject:model];
    }
    [_mainTableView reloadSection:7 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    //banner
    if ([requestName isEqualToString:GET_BANNER]) {
        for (NSDictionary *dict in info) {
            BannerModel *model = [[BannerModel alloc] initModelWithDict:dict];
            [_bannerArray addObject:model];
        }
        [_mainTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }
    //首页
    if ([requestName isEqualToString:GET_HOME]) {
        [self handleHomeDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [SVProgressHUD showErrorWithStatus:@"获取失败"];
}

#pragma mark - 更多按钮
-(void)moreClick:(QMUIButton *)button
{
    if (button.tag - 10000 == 3) {
        [self.navigationController pushViewController:[TopicHomePagerViewController new] animated:YES];
    }
    if (button.tag - 10000 == 5) {
        [self.navigationController pushViewController:[TeacherHomePagerViewController new] animated:YES];
    }
    if (button.tag - 10000 == 6) {

    }
    if (button.tag - 10000 == 7) {
        [self.navigationController pushViewController:[NoteHomePagerViewController new] animated:YES];
    }
}

#pragma mark - TableView Delegate & DataSource
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 80) {
        [self.view bringSubviewToFront:self.statusView];
        [self.view bringSubviewToFront:self.navView];
    }else{
        [self.view bringSubviewToFront:_mainTableView];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 7) {
        return _travelsArray.count;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3 || section == 4 || section == 5 || section == 6 || section == 7) {
        return 40;
    }
    
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = BaseBackgroundColor;
    view.userInteractionEnabled = YES;
    
    if (section == 3 || section == 4 || section == 5 || section == 6 || section == 7 ) {
        NSArray *titles = @[@"热门话题", @"互动打call", @"金牌导师", @"热门路线", @"精选游记"];
        
        QMUILabel *title = [MyTools labelWithText:titles[section - 3]
                                        textColor:UIColorBlack
                                         textFont:UIFontMake(18)
                                    textAlignment:NSTextAlignmentLeft];
        [view addSubview:title];
        
        QMUIButton *more = [QMUIButton new];
        [more setTitle:@"更多 +" forState:0];;
        [more setTitleColor:UIColorMakeWithHex(@"#999999") forState:0];
        more.titleLabel.font = UIFontMake(16);
        [more addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        more.tag = 10000 + section;
        more.userInteractionEnabled = YES;
        [view addSubview:more];
        
        if (section == 6) {
            more.hidden = YES;
        }
        
        title.sd_layout
        .leftSpaceToView(view, 10)
        .topEqualToView(view)
        .bottomSpaceToView(view, 0)
        .widthIs(100);
        
        more.sd_layout
        .rightSpaceToView(view, 10)
        .centerYEqualToView(view)
        .widthIs(60)
        .heightIs(30);
        
        return view;
    }
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //banner
    if (indexPath.section == 0) {
        static NSString *identifier = @"HomeBannerCell";
        HomeBannerCell *cell = (HomeBannerCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.modelArray = _bannerArray;
        @weakify(self)
        cell.menuBtnClicked = ^(QMUIButton *button){
            @strongify(self)
            [self showMenuWithView:button];
        };
        cell.searchView.tapSearch = ^{
            @strongify(self)
            [self.navigationController pushViewController:[SearchViewController new] animated:YES];
        };
        cell.tapImageBlock = ^(NSMutableArray *imageUrls, NSInteger curIndex) {
            
        };
        return cell;
    }
    
    //菜单
    if (indexPath.section == 1) {
        static NSString *identifier = @"HomeMenuCell";
        HomeMenuCell *cell = (HomeMenuCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectMenu = ^(NSInteger index) {
            if (!Token) {
                [self showLogin];
                return;
            }
            if (index == 1000) {
                [self.navigationController pushViewController:[TeacherHomePagerViewController new] animated:YES];
            }
            if (index == 1001) {
                [self.navigationController pushViewController:[NoteHomePagerViewController new] animated:YES];
            }
            if (index == 1002) {
                [self.navigationController pushViewController:[TopicHomePagerViewController new] animated:YES];
            }
            if (index == 1003) {
                [self.navigationController pushViewController:[Track1ViewController new] animated:YES];
            }
            if (index == 1004) {
                [self.navigationController pushViewController:[StudyViewController new] animated:YES];
            }
            if (index == 1005) {
                InteractViewController *vc = [InteractViewController new];
                vc.dataArray = self.callsArray;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    }
    
    //推荐目的地
    if (indexPath.section == 2) {
        static NSString *identifier = @"HomeRecommendCell";
        HomeRecommendCell *cell = (HomeRecommendCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.dataArray = _theamsArray;
        cell.selectedActivity = ^(HomeTheamModel *model) {
            if (!Token) {
                [self showLogin];
                return;
            }
            LinePlaceDetailViewController *vc = [LinePlaceDetailViewController new];
            vc.dId = model.tId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    //热门话题
    if (indexPath.section == 3) {
        static NSString *identifier = @"HomeHotCell";
        HomeHotCell *cell = (HomeHotCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.dataArray = _topicsArray;
        cell.selectedTopic = ^(NSString *topicId) {
            if (!Token) {
                [self showLogin];
                return;
            }
            TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
            vc.topicId = topicId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    //互动打call
    if (indexPath.section == 4) {
        static NSString *identifier = @"HomeInteractCell";
        HomeInteractCell *cell = (HomeInteractCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.dataArray = _callsArray;
        cell.selectedInteractBlock = ^(HomeCallModel *model) {
            if (!Token) {
                [self showLogin];
                return;
            }
            InteractDetailViewController *vc = [InteractDetailViewController new];
            vc.url = model.url;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    //金牌导师
    if (indexPath.section == 5) {
        static NSString *identifier = @"HomeTeacherCell";
        HomeTeacherCell *cell = (HomeTeacherCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.dataArray = _tutorsArray;
        cell.selectedTeacherBlock = ^(HomeTutorModel *model) {
            if (!Token) {
                [self showLogin];
                return;
            }
            TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
            vc.userType = @"2";
            vc.ub_id = model.ub_id;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    //热门路线
    if (indexPath.section == 6) {
        static NSString *identifier = @"HomeLineCell";
        HomeLineCell *cell = (HomeLineCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.dataArray = _pathsArray;
        cell.selectedLineBlock = ^(HomePathModel *model) {
            if (!Token) {
                [self showLogin];
                return;
            }
            LineDetailPagerViewController *vc = [LineDetailPagerViewController new];
            vc.lineId = model.pId;
            vc.tutorId = model.tutor_id;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    //精选游记
    if (indexPath.section == 7) {
        static NSString *identifier = @"HomeTravelCell";
        HomeTravelCell *cell = (HomeTravelCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.model = (NoteListModel *)_travelsArray[indexPath.row];
        cell.tapImageBlock = ^(NSArray *imageUrls, NSInteger currentIndex) {
            [self showPhotoBrowserWithUrls:imageUrls currentIndex:currentIndex];
        };
        return cell;
    }
    
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 7) {
        if (!Token) {
            [self showLogin];
            return;
        }
        NoteDetailViewController *vc = [NoteDetailViewController new];
        vc.noteId = _travelsArray[indexPath.row].tId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 登录
-(void)showLogin
{
    LoginViewController *loginVC = [LoginViewController new];
    loginVC.loginSuccessBlock = ^{

    };
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [vc setNavigationBarHidden:YES];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

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

@end
