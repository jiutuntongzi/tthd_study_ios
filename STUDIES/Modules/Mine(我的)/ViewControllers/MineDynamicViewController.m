//
//  MineDynamicViewController.m
//  STUDIES
//
//  Created by happyi on 2019/6/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineDynamicViewController.h"
#import "DynamicRequestManagerClass.h"
#import "DynamicListModel.h"
#import "CommonRequestManagerClass.h"
#import "TeacherRequestManagerClass.h"
#import "DynamicContentCell.h"
#import "PopViewController.h"
#import "DynamicDetailPagerViewController.h"
#import "VideoPlayViewController.h"
#import "NoteDetailViewController.h"
#import "TeacherDetailPagerViewController.h"
#import "TopicDetailPagerViewController.h"

@interface MineDynamicViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, RequestManagerDelegate, UISearchBarDelegate>

/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 请求页 */
@property(nonatomic, assign) int offset;
/** 动态请求类 */
@property (nonatomic, strong) DynamicRequestManagerClass *requestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 公共请求类 */
@property (nonatomic, strong) CommonRequestManagerClass *commomRequestManager;
/** 导师请求类 */
@property (nonatomic, strong) TeacherRequestManagerClass *teacherRequestManager;

@end

@implementation MineDynamicViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[DynamicContentCell class]
               forCellReuseIdentifier:NSStringFromClass([DynamicContentCell class])];
    }
    
    return _mainTableView;
}

-(DynamicRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [DynamicRequestManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

-(CommonRequestManagerClass *)commomRequestManager
{
    if (!_commomRequestManager) {
        _commomRequestManager = [CommonRequestManagerClass new];
        _commomRequestManager.delegate = self;
    }
    
    return _commomRequestManager;
}

-(TeacherRequestManagerClass *)teacherRequestManager
{
    if (!_teacherRequestManager) {
        _teacherRequestManager = [TeacherRequestManagerClass new];
        _teacherRequestManager.delegate = self;
    }
    
    return _teacherRequestManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"我的动态";
    _offset = 1;
    
    _dataArray = [NSMutableArray array];
    [self.view addSubview:self.mainTableView];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
    [self refresh];
}

#pragma mark - 刷新
-(void)refresh
{
    _offset = 1;
    [self.requestManager getDynamicListWithToken:Token
                                            type:@"2"
                                            ubId:@""
                                        topicsId:@""
                                          lastId:@""
                                            page:StringWithInt(_offset)
                                        pageSize:@"10"
                                     requestType:@"1"
                                            sort:@""
                                     requestName:GET_DYNAMIC_LIST];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _offset ++;
    [self.requestManager getDynamicListWithToken:Token
                                            type:@"2"
                                            ubId:@""
                                        topicsId:@""
                                          lastId:@""
                                            page:StringWithInt(_offset)
                                        pageSize:@"10"
                                     requestType:@"2"
                                            sort:@""
                                     requestName:GET_DYNAMIC_LIST];
}

#pragma mark - 处理数据
-(void)handleFynamicListWithData:(NSArray *)dataArray
{
    if (_offset == 1) {
        [_dataArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        DynamicListModel *model = [[DynamicListModel alloc] initModelWithDict:dic];
        [_dataArray addObject:model];
    }
    
    [_mainTableView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_footer endRefreshing];
    [_mainTableView.mj_header endRefreshing];
    if ([requestName isEqualToString:GET_DYNAMIC_LIST]) {
        [self handleFynamicListWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_footer endRefreshing];
    [_mainTableView.mj_header endRefreshing];
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有发表过动态";
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
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
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
    @weakify(self)
    cell.tapContent = ^(NSDictionary *userInfo, NSString *content) {
        @strongify(self)
        if ([content containsString:@"@"]) {
            //个人
            TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
            vc.ub_id = userInfo[@"id"];
            vc.userType = userInfo[@"usertype"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([content containsString:@"#"]){
            //话题
            TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
            vc.topicId = userInfo[@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([content containsString:@"《"]){
            //游记
            NoteDetailViewController *vc = [NoteDetailViewController new];
            vc.noteId = userInfo[@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    cell.noteBlock = ^(NSString *noteId) {
        NoteDetailViewController *vc = [NoteDetailViewController new];
        vc.noteId = noteId;
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.playVideoBlock = ^(NSString *videoUrl) {
        VideoPlayViewController *vc = [VideoPlayViewController new];
        vc.videoUrl = videoUrl;
        [vc showWithAnimated:YES completion:nil];
    };
    cell.tapImageBlock = ^(NSArray *imageUrls, NSInteger currentIndex) {
        [self showPhotoBrowserWithUrls:imageUrls currentIndex:currentIndex];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicDetailPagerViewController *vc = [DynamicDetailPagerViewController new];
    vc.dynamicModel = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
