//
//  TopicNewDetailViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TopicDetailNewViewController.h"
#import "TeacherDynamicCell.h"
#import "DynamicRequestManagerClass.h"
#import "DynamicContentCell.h"

@interface TopicDetailNewViewController ()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UITableView *mainTable;

@property (nonatomic, strong) DynamicRequestManagerClass *requestManager;

@property (nonatomic, assign) int page;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *requestType;

@end

@implementation TopicDetailNewViewController

-(UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        [_mainTable registerClass:[DynamicContentCell class]
           forCellReuseIdentifier:NSStringFromClass([DynamicContentCell class])];
    }
    
    return _mainTable;
}

-(DynamicRequestManagerClass *)requestManager
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
    
    _page = 1;
    _dataArray = [NSMutableArray array];
    
    [self.view addSubview:self.mainTable];
    _mainTable.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, 0)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
    _requestType = @"1";
    
}

-(void)setDetailModel:(TopicDetailModel *)detailModel
{
    _detailModel = detailModel;
    [self getList];
}

#pragma mark - 刷新
-(void)refresh
{
    _page = 1;
    _requestType = @"1";
    [self getList];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _page ++;
    _requestType = @"2";
    [self getList];
}

#pragma mark - 获取列表
-(void)getList
{
    [self.requestManager getDynamicListWithToken:Token
                                            type:@"0"
                                            ubId:@""
                                        topicsId:_detailModel.topicId
                                          lastId:@""
                                            page:StringWithInt(_page)
                                        pageSize:@"10"
                                     requestType:_requestType
                                            sort:@"1"
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

#pragma mark -RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTable.mj_footer endRefreshing];
    if ([requestName isEqualToString:GET_DYNAMIC_LIST]) {
        self.requestFinishiBlock();
        [self handleFynamicListWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_mainTable.mj_footer endRefreshing];
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
    self.selectDynamicBlock(_dataArray[indexPath.row]);
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
