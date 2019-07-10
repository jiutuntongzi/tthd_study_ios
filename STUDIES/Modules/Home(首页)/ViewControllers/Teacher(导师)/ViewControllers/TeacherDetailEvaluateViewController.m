//
//  TeacherEvaluateViewController.m
//  STUDIES
//
//  Created by happyi on 2019/3/25.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherDetailEvaluateViewController.h"
#import "TeacherEvaluateCell.h"
#import "TeacherRequestManagerClass.h"
#import "TeacherEvaluateModel.h"
@interface TeacherDetailEvaluateViewController ()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UITableView *mainTable;

/** 请求类 */
@property (nonatomic, strong) TeacherRequestManagerClass *requestManager;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray <TeacherEvaluateModel *> *evaluateArray;
/** 请求页 */
@property (nonatomic, assign) int offset;
@end

@implementation TeacherDetailEvaluateViewController

#pragma mark - lazy
-(UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.emptyDataSetSource = self;
        _mainTable.emptyDataSetDelegate = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _mainTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        [_mainTable registerClass:[TeacherEvaluateCell class]
           forCellReuseIdentifier:NSStringFromClass([TeacherEvaluateCell class])];
    }
    
    return _mainTable;
}

- (TeacherRequestManagerClass *)requestManager
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
    
    self.view.backgroundColor = UIColorGray;
    
    _offset = 1;
    _evaluateArray = [NSMutableArray array];
    
    [self.view addSubview:self.mainTable];
    _mainTable.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, 0)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
    [self getEvaluateList];
}

#pragma mark - 刷新
-(void)refresh
{
    _offset = 1;
    [self getEvaluateList];
}

#pragma mark - 上拉加载
-(void)loadMore
{
    _offset ++;
    [self getEvaluateList];
}

#pragma mark - 获取列表
-(void)getEvaluateList
{
    [self.requestManager getTeacherEvaluateWithUbId:self.ub_id
                                                  offset:StringWithInt(_offset)
                                                   limit:@"10"
                                             requestName:GET_TEACHER_EVALUATE];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.mainTable;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - 数据处理
-(void)handleEvaluateDataWithData:(NSArray *)dataArray
{
    if (_offset == 1) {
        [_evaluateArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        TeacherEvaluateModel *model = [[TeacherEvaluateModel alloc] initModelWithDict:dic];
        [_evaluateArray addObject:model];
    }
    
    [_mainTable reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTable.mj_header endRefreshing];
    [_mainTable.mj_footer endRefreshing];
    
    if ([requestName isEqualToString:GET_TEACHER_EVALUATE]) {
        [self handleEvaluateDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_mainTable.mj_header endRefreshing];
    [_mainTable.mj_footer endRefreshing];
    
    [SVProgressHUD showErrorWithStatus:@"请求失败"];
}

#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return UIImageMake(@"common_icon_nodata");
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"当前用户无评价";
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
    return _evaluateArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTable];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TeacherEvaluateCell";
    TeacherEvaluateCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[TeacherEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.model = _evaluateArray[indexPath.row];
    cell.tapImageBlock = ^(NSArray *imageUrls, NSInteger currentIndex) {
        [self showPhotoBrowserWithUrls:imageUrls currentIndex:currentIndex];
    };
    return cell;
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
