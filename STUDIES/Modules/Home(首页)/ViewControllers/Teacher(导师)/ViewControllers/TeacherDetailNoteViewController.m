//
//  TeacherDetailNoteViewController.m
//  STUDIES
//
//  Created by happyi on 2019/6/3.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherDetailNoteViewController.h"
#import "NoteRequestManagerClass.h"
#import "NoteSearchModel.h"
#import "MineNoteCell.h"
#import "NoteDetailViewController.h"
@interface TeacherDetailNoteViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, RequestManagerDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;
/** 游记请求类 */
@property (nonatomic, strong) NoteRequestManagerClass *noteRequestManager;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray <NoteSearchModel *> *noteArray;
/** 加载页 */
@property (nonatomic, assign) int offset;

@end

@implementation TeacherDetailNoteViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        [_mainTableView registerClass:[MineNoteCell class]
               forCellReuseIdentifier:NSStringFromClass([MineNoteCell class])];
    }
    
    return _mainTableView;
}

-(NoteRequestManagerClass *)noteRequestManager
{
    if (!_noteRequestManager) {
        _noteRequestManager = [NoteRequestManagerClass new];
        _noteRequestManager.delegate = self;
    }
    
    return _noteRequestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _offset = 1;
    _noteArray = [NSMutableArray array];
    
    [self.view addSubview:self.mainTableView];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, 0)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
    [self getUserNoteList];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _offset ++;
    [self getUserNoteList];
}

#pragma mark - 获取列表
-(void)getUserNoteList
{
    [self.noteRequestManager getUserNoteListWithUbId:_ubid
                                              offset:StringWithInt(_offset)
                                               limit:@"10"
                                         requestName:GET_USER_NOTELIST];
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

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    
    if ([requestName isEqualToString:GET_USER_NOTELIST]) {
        [self handleNoteDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.mainTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}


#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"TA还没有发布过游记";
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
    self.selectNoteBlock(_noteArray[indexPath.row]);
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
