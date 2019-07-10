//
//  MineViewController.m
//  STUDIES
//
//  Created by happyi on 2019/3/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "MineHeaderView.h"
#import "MineButtonsView.h"
#import "MineNoteCell.h"
#import "MineSetViewController.h"
#import "MineCollectViewController.h"
#import "TopicHomePagerViewController.h"
#import "MineDynamicViewController.h"
#import "TeacherFansViewController.h"
#import "NoteDetailViewController.h"
#import "UserInfoModel.h"
#import "NoteRequestManagerClass.h"
#import "NoteSearchModel.h"
#import "UserReqeustManagerClass.h"
#import "UserIndexModel.h"
#import "MineEditDesViewController.h"
#import "Track1ViewController.h"
#import "TeacherFansViewController.h"
#import "MineFollowTopicViewController.h"
#import "RegisterViewController.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, RequestManagerDelegate>
/** 头部视图 */
@property (nonatomic, strong) MineHeaderView *headerView;
/** 头部视图高度 */
@property (nonatomic, assign) CGFloat headerViewHeight;
/** 按钮视图 */
@property (nonatomic, strong) MineButtonsView *buttonsView;
/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;
/** 游记请求类 */
@property (nonatomic, strong) NoteRequestManagerClass *noteRequestManager;
/** 个人请求类 */
@property (nonatomic, strong) UserReqeustManagerClass *userRequestManager;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray <NoteSearchModel *> *noteArray;
/** 加载页 */
@property (nonatomic, assign) int offset;

@end

@implementation MineViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.buttonsView.bottom + 10, SCREEN_WIDTH, SCREEN_HEIGHT - self.buttonsView.bottom - 10 - BaseTabBarViewHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        [_mainTableView registerClass:[MineNoteCell class]
               forCellReuseIdentifier:NSStringFromClass([MineNoteCell class])];
    }
    
    return _mainTableView;
}

-(MineHeaderView *)headerView
{
    __weak __typeof (self)weakSelf = self;
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.headerViewHeight)];
        _headerView.setClickBlock = ^{
            MineSetViewController *vc = [MineSetViewController new];
            vc.logoutBlock = ^{
                [weakSelf showUnlogin];
                [weakSelf.noteArray removeAllObjects];
                [weakSelf.mainTableView reloadData];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _headerView.dynamicBlock = ^{
            if (!Token) {
                [weakSelf showLogin];
            }else{
                [weakSelf.navigationController pushViewController:[MineDynamicViewController new] animated:YES];
            }
        };
        _headerView.followBlock = ^{
            if (!Token) {
                [weakSelf showLogin];
            }else{
                UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
                TeacherFansViewController *vc = [TeacherFansViewController new];
                vc.ub_id = model.ub_id;
                vc.type = @"1";
                vc.aboutType = @"1";
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        _headerView.fansBlock = ^{
            if (!Token) {
                [weakSelf showLogin];
            }else{
                UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
                TeacherFansViewController *vc = [TeacherFansViewController new];
                vc.ub_id = model.ub_id;
                vc.type = @"2";
                vc.aboutType = @"1";
                [weakSelf.navigationController pushViewController:vc animated:YES];            }
        };
        _headerView.loginBlock = ^{
            [weakSelf showLogin];
        };
        _headerView.editBlock = ^{
            if (!Token) {
                [weakSelf showLogin];
            }else{
                [weakSelf.navigationController pushViewController:[MineEditDesViewController new] animated:YES];
            }
        };
    }
    
    return _headerView;
}

- (CGFloat)headerViewHeight
{
    if (!_headerViewHeight) {
        _headerViewHeight = 180 + BaseStatusViewHeight;
    }
    return _headerViewHeight;
}

-(MineButtonsView *)buttonsView
{
    __weak __typeof (self)weakSelf = self;
    if (!_buttonsView) {
        _buttonsView = [[MineButtonsView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom + 5, SCREEN_WIDTH, 70)];
        _buttonsView.selectCollectBlock = ^{
            if (!Token) {
                [weakSelf showLogin];
                return ;
            }
            [weakSelf.navigationController pushViewController:[MineCollectViewController new] animated:YES];
        };
        _buttonsView.selectTrackBlock = ^{
            if (!Token) {
                [weakSelf showLogin];
                return ;
            }
            [weakSelf.navigationController pushViewController:[MineDynamicViewController new] animated:YES];
        };
        _buttonsView.selectTopicBlock = ^{
            if (!Token) {
                [weakSelf showLogin];
                return ;
            }
            [weakSelf.navigationController pushViewController:[MineFollowTopicViewController new] animated:YES];
        };
    }
    return _buttonsView;
}

-(NoteRequestManagerClass *)noteRequestManager
{
    if (!_noteRequestManager) {
        _noteRequestManager = [NoteRequestManagerClass new];
        _noteRequestManager.delegate = self;
    }
    
    return _noteRequestManager;
}

-(UserReqeustManagerClass *)userRequestManager
{
    if (!_userRequestManager) {
        _userRequestManager = [UserReqeustManagerClass new];
        _userRequestManager.delegate = self;
    }
    
    return _userRequestManager;
}

#pragma mark - life
-(void)viewWillAppear:(BOOL)animated
{
    //查询当前的数据库中是否有个人信息的数据，若有表示已登录，若没有，表示未登录
    if (Token) {
        UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
        _headerView.infoModel = model;
        //已登录，获取用户详情和游记列表
        [self getUserNoteList];
        [self getUserIndex];
    }else{
        //未登录
        [self showUnlogin];
    }
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorWhite;
    self.navView.hidden = YES;
    self.statusView.hidden = YES;

    _offset = 1;
    _noteArray = [NSMutableArray array];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.buttonsView];
    [self.view addSubview:self.mainTableView];
    
}

#pragma mark - 展示未登录页面
-(void)showUnlogin
{
    _headerView.indexModel = nil;
    _headerView.infoModel = nil;
}

#pragma mark - 登录
-(void)showLogin
{
    LoginViewController *loginVC = [LoginViewController new];
    loginVC.loginSuccessBlock = ^{
        //登录成功，刷新用户信息
        [self refreshUserInfo];
        //获取游记列表
        [self getUserNoteList];
        //获取个人信息首页
        [self getUserIndex];
    };
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [vc setNavigationBarHidden:YES];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 刷新用户信息
-(void)refreshUserInfo
{
    UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
    _headerView.infoModel = model;
}

#pragma mark - 刷新
-(void)refreshData
{
    _offset = 1;
    [self getUserNoteList];
}

-(void)loadMore
{
    _offset ++;
    [self getUserNoteList];
}

#pragma mark - 获取个人中心信息
-(void)getUserIndex
{
    [self.userRequestManager getUserIndexWithToken:Token requestName:GET_USER_INDEX];
}

#pragma mark - 获取我的游记列表
-(void)getUserNoteList
{
    [self.noteRequestManager getSearchNoteWithKeyword:@"" type:@"2" offset:StringWithInt(_offset) limit:@"10" token:Token requestName:GET_NOTE_SEARCH];
}

#pragma mark - 数据处理
-(void)handleNoteDataWithData:(NSArray *)dataArray
{
    if (_offset == 1) {
        [_noteArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        NoteSearchModel *model = [[NoteSearchModel alloc] initModelWithDict:dic];
        [_noteArray addObject:model];
    }
    
    [_mainTableView reloadData];
}

-(void)handleUserIndexWithData:(NSDictionary *)dic
{
    UserIndexModel *model = [[UserIndexModel alloc] initModelWithDict:dic];
    _headerView.indexModel = model;
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    
    if ([requestName isEqualToString:GET_NOTE_SEARCH]) {
        [self handleNoteDataWithData:info];
    }
    if ([requestName isEqualToString:GET_USER_INDEX]) {
        [self handleUserIndexWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有游记，请先去发表一篇吧";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return UIImageMake(@"common_icon_nodata");
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _noteArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MineNoteCell";
    MineNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.model = _noteArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteDetailViewController *vc = [NoteDetailViewController new];
    vc.noteId = [_noteArray[indexPath.row] noteId];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"游记";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:17]];
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
