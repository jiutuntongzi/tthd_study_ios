//
//  TeacherFansViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/2.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherFansViewController.h"
#import "TeacherRequestManagerClass.h"
#import "TeacherFansOrFollowsModel.h"
#import "TeacherFansOrFollowsCell.h"
#import "TeacherDetailPagerViewController.h"

@interface TeacherFansViewController()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, RequestManagerDelegate>

/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;
/** 请求类 */
@property (nonatomic, strong) TeacherRequestManagerClass *requestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray <TeacherFansOrFollowsModel *> *fansArray;
/** 当前页 */
@property (nonatomic, assign) int offset;
@end

@implementation TeacherFansViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        [_mainTableView registerClass:[TeacherFansOrFollowsCell class] forCellReuseIdentifier:@"TeacherFansOrFollowsCell"];
    }
    
    return _mainTableView;
}

-(TeacherRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [[TeacherRequestManagerClass alloc] init];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = [_type intValue] == 1 ? @"TA的关注" : @"TA的粉丝";
    
    _fansArray = [NSMutableArray array];
    
    [self.view addSubview:self.mainTableView];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
    [self refresh];
}

#pragma mark - 刷新
-(void)refresh
{
    _offset = 1;
    [self getList];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _offset ++;
    [self getList];
}

#pragma mark - 获取列表
-(void)getList
{
    [self.requestManager getTeacherFansOrFollowsWithType:_type
                                                 aboutId:_ub_id
                                               aboutType:_aboutType
                                                userType:@"1"
                                                  offset:StringWithInt(_offset)
                                                   limit:@"10"
                                                   token:Token
                                             requestName:GET_TEACHER_FANSORFOLLOWS];
}

#pragma mark - 数据处理
-(void)handleFansDataWithData:(NSArray *)dataArray
{
    if (_offset == 1) {
        [_fansArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        TeacherFansOrFollowsModel *model = [[TeacherFansOrFollowsModel alloc] initModelWithDict:dic];
        [_fansArray addObject:model];
    }
    
    [_mainTableView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_TEACHER_FANSORFOLLOWS]) {
        [self handleFansDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"抱歉";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [_type intValue] == 1 ? @"你还没有关注过，请先关注吧！" : @"你还没有粉丝哦";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fansArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TeacherFansOrFollowsCell";
    TeacherFansOrFollowsCell *cell = (TeacherFansOrFollowsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.model = _fansArray[indexPath.row];
    cell.followBlock = ^(TeacherFansOrFollowsModel *model) {
        
        [self.requestManager postFollowTeacherWithAboutType:model.user_type
                                                   userType:@"1"
                                                    aboutId:model.ub_id
                                                      token:Token
                                                requestName:POST_FOLLOW_USER];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeacherFansOrFollowsModel *model = _fansArray[indexPath.row];
    TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
    vc.userType = model.user_type;
    vc.ub_id = model.ub_id;
    vc.avatar = model.avatar;
    vc.name = model.nickname;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
