//
//  NoteSearchViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteSearchViewController.h"
#import "NoteSearchCell.h"
#import "NoteRequestManagerClass.h"
#import "NoteSearchModel.h"
#import "NoteDetailViewController.h"

@interface NoteSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, RequestManagerDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

/** 搜索栏 */
@property(nonatomic, strong) UISearchBar *mySearchBar;
/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 请求类 */
@property(nonatomic, strong) NoteRequestManagerClass *requestManager;
/** 请求数 */
@property(nonatomic, assign) int limit;
/** 请求页 */
@property(nonatomic, assign) int offset;
/** 数据源 */
@property(nonatomic, strong) NSMutableArray <NoteSearchModel *> *dataArray;
/** 关键词 */
@property(nonatomic, strong) NSString *keyword;

@end

@implementation NoteSearchViewController

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
    
    self.leftButton.hidden = YES;
    [self.rightButton setTitle:@"取消" forState:0];
    [self.rightButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.mySearchBar];
    [self.view addSubview:self.mainTableView];
    
    _limit = 10;
    _offset = 1;
    _dataArray = [NSMutableArray array];
    
    _mySearchBar.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, BaseStatusViewHeight + 5)
    .rightSpaceToView(self.view, 60)
    .heightIs(BaseNavViewHeight - 10);
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
}

#pragma mark - 返回
-(void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (![_keyword isEqualToString:searchBar.text]) {
        _offset = 1;
    }
    [_mySearchBar resignFirstResponder];
    [self.requestManager getSearchNoteWithKeyword:searchBar.text
                                             type:@"1"
                                           offset:StringWithInt(_offset)
                                            limit:StringWithInt(_limit)
                                            token:Token
                                      requestName:GET_NOTE_SEARCH];
    _keyword = searchBar.text;
}

#pragma mark - 加载更多
-(void)loadMore
{
    _offset ++;
    [self searchBarSearchButtonClicked:_mySearchBar];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
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

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - TableView Delegate & DataSource
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_mySearchBar resignFirstResponder];
}

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
    NoteDetailViewController *vc = [NoteDetailViewController new];
    vc.noteId = model.noteId;
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
