//
//  TeacherHomeContainerEvaluteView.m
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherHomeContainerEvaluteView.h"
#import "HomeTeacherContentCell.h"

@implementation TeacherHomeContainerEvaluteView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
        [self addSubview:_mainTableView];
        [self getTeacherList];
    }
    
    return self;
}

#pragma mark - 初始化
-(void)initialization
{
    //请求页
    _offset = 1;
    //请求类
    _requestManager = [TeacherRequestManagerClass new];
    _requestManager.delegate = self;
    //列表
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mainTableView registerClass:[HomeTeacherContentCell class]
           forCellReuseIdentifier:NSStringFromClass([HomeTeacherContentCell class])];
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.showsHorizontalScrollIndicator = NO;
    _mainTableView.frame = self.bounds;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    //数据
    _dataArray = [NSMutableArray array];
}

#pragma mark - JXPagerViewListViewDelegate
-(UIView *)listView
{
    return self;
}

- (UIScrollView *)listScrollView
{
    return _mainTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - 获取导师列表
-(void)getTeacherList
{
    [_requestManager getTeacherListWithType:@"2"
                                   userType:@"1"
                                  labelType:@"0"
                                     offset:StringWithInt(_offset)
                                      limit:@"10"
                                      token:Token
                                requestName:GET_TEACHER_LIST];
}

#pragma mark - 刷新
-(void)refresh
{
    _offset = 1;
    [self getTeacherList];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _offset ++;
    [self getTeacherList];
}

-(void)hanleListDataWithData:(NSArray *)dataArray
{
    if (_offset == 1) {
        [_dataArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        TeacherModel *model = [[TeacherModel alloc] initModelWithDict:dic];
        [_dataArray addObject:model];
    }
    
    [_mainTableView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    //导师列表
    if ([requestName isEqualToString:GET_TEACHER_LIST]) {
        [self hanleListDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:@"请求失败"];
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HomeTeacherContentCell";
    HomeTeacherContentCell *cell = (HomeTeacherContentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.model = _dataArray[indexPath.row];
    cell.followBlock = ^(TeacherModel *model) {
        [self->_requestManager postFollowTeacherWithAboutType:@"2"
                                                     userType:@"1"
                                                      aboutId:model.ub_id
                                                        token:Token
                                                  requestName:POST_FOLLOW_USER];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTeacherBlock(_dataArray[indexPath.row]);
}


@end
