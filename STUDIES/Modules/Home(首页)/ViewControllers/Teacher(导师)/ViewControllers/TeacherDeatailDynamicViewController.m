//
//  TeacherDynamicViewController.m
//  STUDIES
//
//  Created by happyi on 2019/3/25.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherDeatailDynamicViewController.h"
#import <UILabel+YBAttributeTextTapAction.h>
#import "TeacherDynamicCell.h"
#import "DynamicRequestManagerClass.h"
#import "DynamicListModel.h"
#import "DynamicContentCell.h"
@interface TeacherDeatailDynamicViewController ()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/** 主视图 */
@property (nonatomic, strong) UITableView *mainTable;
/** 请求类 */
@property (nonatomic, strong) DynamicRequestManagerClass *requestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 请求页 */
@property (nonatomic, assign) int page;

@end

@implementation TeacherDeatailDynamicViewController

-(UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.emptyDataSetSource = self;
        _mainTable.emptyDataSetDelegate = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTable registerClass:[DynamicContentCell class]
               forCellReuseIdentifier:NSStringFromClass([DynamicContentCell class])];
        _mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _mainTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
    
    return _mainTable;
}

- (DynamicRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [DynamicRequestManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    
    self.view.backgroundColor = UIColorGray;
    
    [self.view addSubview:self.mainTable];
    _mainTable.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, 0)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
}

-(void)setDetailModel:(TeacherDetailModel *)detailModel
{
    _page = 1;
    _detailModel = detailModel;
    [self getDynamicListWithType:@"1"];
}

#pragma mark - 刷新
-(void)refresh
{
    _page = 1;
    [self getDynamicListWithType:@"1"];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _page ++;
    [self getDynamicListWithType:@"2"];
}

#pragma mark - 获取动态数据
-(void)getDynamicListWithType:(NSString *)requestType
{
    [self.requestManager getDynamicListWithToken:Token
                                            type:@"3"
                                            ubId:_detailModel.ub_id
                                        topicsId:@""
                                          lastId:@""
                                            page:StringWithInt(_page)
                                        pageSize:@"10"
                                     requestType:requestType
                                            sort:@""
                                     requestName:GET_DYNAMIC_LIST];
}

#pragma mark - 处理数据
-(void)handleFynamicListWithData:(NSArray *)dataArray
{
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        DynamicListModel *model = [[DynamicListModel alloc] initModelWithDict:dic];
        [_dataArray addObject:model];
    }
    
    [_mainTable reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTable.mj_header endRefreshing];
    [_mainTable.mj_footer endRefreshing];
    
    if ([requestName isEqualToString:GET_DYNAMIC_LIST]) {
        [self handleFynamicListWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_mainTable.mj_header endRefreshing];
    [_mainTable.mj_footer endRefreshing];
    
    [SVProgressHUD showErrorWithStatus:@"请求失败"];
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

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"TA还没有发布过动态哦";
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
    return _dataArray.count;
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
    static NSString *cellIdentifier = @"DynamicContentCell";
    DynamicContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[DynamicContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.model = _dataArray[indexPath.row];
    cell.followButton.hidden = YES;
    cell.tapContent = ^(NSDictionary *userInfo, NSString *content) {
        if ([content containsString:@"@"]) {
            //个人
            self.selectUserBlock(userInfo[@"id"], userInfo[@"usertype"]);
        }else if ([content containsString:@"#"]){
            //话题
            self.selectTopicBlock(userInfo[@"id"]);
        }else if ([content containsString:@"《"]){
            //游记
            self.selectNoteBlock(userInfo[@"id"]);
        }
    };
    cell.noteBlock = ^(NSString *noteId) {
        self.selectNoteBlock(noteId);
    };
    cell.tapImageBlock = ^(NSArray *imageUrls, NSInteger currentIndex) {
        [self showPhotoBrowserWithUrls:imageUrls currentIndex:currentIndex];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedDynamicBlock(_dataArray[indexPath.row]);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
