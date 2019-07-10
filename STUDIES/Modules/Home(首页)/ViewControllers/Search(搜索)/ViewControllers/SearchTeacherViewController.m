//
//  SearchTeacherViewController.m
//  STUDIES
//
//  Created by 花想容 on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "SearchTeacherViewController.h"
#import "HomeTeacherContentCell.h"
#import "TeacherModel.h"
#import "TeacherRequestManagerClass.h"

@interface SearchTeacherViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, RequestManagerDelegate>

/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 请求类 */
@property(nonatomic, strong) TeacherRequestManagerClass *requestManager;
/** 数据 */
@property(nonatomic, strong) NSMutableArray <TeacherModel *> *teacherArray;
/** 请求页 */
@property(nonatomic, assign) int offset;
@end

@implementation SearchTeacherViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        [_mainTableView registerClass:[HomeTeacherContentCell class]
               forCellReuseIdentifier:NSStringFromClass([HomeTeacherContentCell class])];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _teacherArray = [NSMutableArray array];
    _offset = 1;

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
    _offset = 1;
    [_teacherArray removeAllObjects];
    [self getSearchList];
}

#pragma mark - 获取列表
-(void)getSearchList
{
    [self.requestManager getTeacherSearchWithKeyword:_keyword
                                              offset:StringWithInt(_offset)
                                               limit:@"10"
                                               token:Token
                                         requestName:GET_TEACHER_SEARCH];
}

#pragma mark - 刷新
-(void)refresh
{
    _offset = 1;
    [self getSearchList];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _offset ++;
    [self getSearchList];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - 数据处理
-(void)handleSearchDataWithData:(NSArray *)dataArray
{
    if (_offset == 1) {
        [_teacherArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        TeacherModel *model = [[TeacherModel alloc] initModelWithDict:dic];
        [_teacherArray addObject:model];
    }
    
    [_mainTableView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    if ([requestName isEqualToString:GET_TEACHER_SEARCH]) {
        [self handleSearchDataWithData:info];
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

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _teacherArray.count;
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
    static NSString *cellIdentifier = @"HomeTeacherContentCell";
    HomeTeacherContentCell *cell = (HomeTeacherContentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.model = _teacherArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectTeacherBlock(_teacherArray[indexPath.row]);
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
