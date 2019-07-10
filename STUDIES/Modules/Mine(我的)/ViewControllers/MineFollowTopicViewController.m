//
//  MineFollowTopicViewController.m
//  STUDIES
//
//  Created by happyi on 2019/6/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineFollowTopicViewController.h"
#import "TopicRequestManagerClass.h"
#import "TopicListModel.h"
#import "TopicContentCell.h"
#import "TopicDetailPagerViewController.h"

@interface MineFollowTopicViewController ()<RequestManagerDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) TopicRequestManagerClass *requestManager;

@property (nonatomic, assign) int page;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MineFollowTopicViewController

#pragma mark - lazy
-(TopicRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [TopicRequestManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[TopicContentCell class]
               forCellReuseIdentifier:NSStringFromClass([TopicContentCell class])];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"话题";
    
    _page = 1;
    _dataArray = [NSMutableArray array];
    
    [self.view addSubview:self.mainTableView];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
    [self getList];
}

#pragma mark - 刷新
-(void)refresh
{
    _page = 1;
    [self getList];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _page ++;
    [self getList];
}

-(void)getList
{
    [self.requestManager getTopicFollowListWithToken:Token
                                                page:StringWithInt(_page)
                                            pageSize:@"10"
                                         requestName:GET_TOPIC_FOLLOWLIST];
}

#pragma mark - 数据处理
-(void)hanleTopicListDataWithData:(NSArray *)dataArray
{
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        TopicListModel *model = [[TopicListModel alloc] initModelWithDict:dic];
        [_dataArray addObject:model];
    }
    [_mainTableView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    
    if ([requestName isEqualToString:GET_TOPIC_FOLLOWLIST]) {
        [self hanleTopicListDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
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
    static NSString *cellIdentifier = @"TopicContentCell";
    TopicContentCell *cell = (TopicContentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicListModel *model = _dataArray[indexPath.row];
    TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
    vc.topicId = model.topicId;
    [self.navigationController pushViewController:vc animated:YES];
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
