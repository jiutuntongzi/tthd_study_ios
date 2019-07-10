//
//  SearchUserViewController.m
//  STUDIES
//
//  Created by 花想容 on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "SearchUserViewController.h"
#import "HomeRequestManagerClass.h"
#import "HomeUserCell.h"
#import "HomeUserModel.h"

@interface SearchUserViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, RequestManagerDelegate>

/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 数据 */
@property(nonatomic, strong) NSMutableArray *userArray;
/** 请求类 */
@property(nonatomic, strong) HomeRequestManagerClass *requestManager;
/** 请求页 */
@property(nonatomic, assign) int page;
@end

@implementation SearchUserViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[HomeUserCell class]
               forCellReuseIdentifier:NSStringFromClass([HomeUserCell class])];
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
    
    return _mainTableView;
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有搜索结果，换一个关键字试试！";
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
    return UIImageMake(@"search_icon_nodata");
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _userArray = [NSMutableArray array];
    
    _requestManager = [HomeRequestManagerClass new];
    _requestManager.delegate = self;
    
    [self.view addSubview:self.mainTableView];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, 0)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
}

-(void)setKeyword:(NSString *)keyword
{
    _keyword = keyword;
    [_userArray removeAllObjects];
    [self refresh];
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

#pragma mark - 获取列表
-(void)getList
{
    [_requestManager postHomeSearchWithKey:_keyword
                                     token:Token
                                      type:@"2"
                                      page:StringWithInt(_page)
                                  pageSize:@"10"
                               requestName:POST_HOME_SEARCH];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    if ([requestName isEqualToString:POST_HOME_SEARCH]) {
        if (_page == 1) {
            [_userArray removeAllObjects];
        }
        for (NSDictionary *dic in info) {
            HomeUserModel *model = [[HomeUserModel alloc] initModelWithDict:dic];
            [_userArray addObject:model];
        }
        
        [_mainTableView reloadData];
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
    return _userArray.count;
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
    static NSString *cellIdentifier = @"HomeUserCell";
    HomeUserCell *cell = (HomeUserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.model = _userArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectUserBlock(_userArray[indexPath.row]);
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

@end
