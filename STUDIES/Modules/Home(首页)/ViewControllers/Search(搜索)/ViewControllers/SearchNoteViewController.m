//
//  SearchNoteViewController.m
//  STUDIES
//
//  Created by 花想容 on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "SearchNoteViewController.h"
#import "NoteSearchCell.h"
#import "NoteRequestManagerClass.h"
#import "NoteSearchModel.h"
#import "NoteDetailViewController.h"

@interface SearchNoteViewController ()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 请求类 */
@property(nonatomic, strong) NoteRequestManagerClass *requestManager;
/** 请求页 */
@property(nonatomic, assign) int offset;
/** 数据源 */
@property(nonatomic, strong) NSMutableArray <NoteSearchModel *> *dataArray;

@end

@implementation SearchNoteViewController

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
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        [_mainTableView registerClass:[NoteSearchCell class]
               forCellReuseIdentifier:NSStringFromClass([NoteSearchCell class])];
    }
    
    return _mainTableView;
}

-(NoteRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [[NoteRequestManagerClass alloc] init];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _offset = 1;
    _dataArray = [NSMutableArray array];
    
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
    [_dataArray removeAllObjects];
    [self getSearchList];
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

#pragma mark - 获取列表
-(void)getSearchList
{
    [self.requestManager getSearchNoteWithKeyword:_keyword
                                             type:@"1"
                                           offset:StringWithInt(_offset)
                                            limit:@"10"
                                            token:Token
                                      requestName:GET_NOTE_SEARCH];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    if ([requestName isEqualToString:GET_NOTE_SEARCH]) {
        [_mainTableView.mj_footer endRefreshing];
        if (_offset == 1) {
            [_dataArray removeAllObjects];
        }
        [self handelDataWithDatas:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
}

#pragma mark - 数据处理
-(void)handelDataWithDatas:(NSArray *)datas
{
    for (NSDictionary *dict in datas) {
        NoteSearchModel *model = [[NoteSearchModel alloc] initModelWithDict:dict];
        [_dataArray addObject:model];
    }
    [_mainTableView reloadData];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NoteSearchCell";
    NoteSearchModel *model = _dataArray[indexPath.row];
    NoteSearchCell *cell = (NoteSearchCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteSearchModel *model = _dataArray[indexPath.row];
    self.selectNoteBlock(model);
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
