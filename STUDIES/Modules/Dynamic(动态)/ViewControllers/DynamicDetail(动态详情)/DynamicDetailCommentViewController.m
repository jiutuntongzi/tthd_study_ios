//
//  DynamicDetailCommentViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicDetailCommentViewController.h"
#import "DynamicDetailCommentCell.h"
#import "DynamicRequestManagerClass.h"
#import "DynamicCommentModel.h"
#import "DynamicReplyViewController.h"
#import "PopViewController.h"
#import "TeacherRequestManagerClass.h"
#import "CommonRequestManagerClass.h"

@interface DynamicDetailCommentViewController ()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/** 请求类 */
@property (nonatomic, strong) DynamicRequestManagerClass *dynamicRequestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *modelArray;
/** 页码 */
@property (nonatomic, assign) int page;
/** 导师请求 */
@property (nonatomic, strong) TeacherRequestManagerClass *teacherRequestManager;
/** 公共请求 */
@property (nonatomic, strong) CommonRequestManagerClass *commonRequestManager;
@end

@implementation DynamicDetailCommentViewController

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
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        [_mainTableView registerClass:[DynamicDetailCommentCell class]
               forCellReuseIdentifier:NSStringFromClass([DynamicDetailCommentCell class])];
    }
    
    return _mainTableView;
}

-(DynamicRequestManagerClass *)dynamicRequestManager
{
    if (!_dynamicRequestManager) {
        _dynamicRequestManager = [DynamicRequestManagerClass new];
        _dynamicRequestManager.delegate = self;
    }
    
    return _dynamicRequestManager;
}

-(TeacherRequestManagerClass *)teacherRequestManager
{
    if (!_teacherRequestManager) {
        _teacherRequestManager = [TeacherRequestManagerClass new];
        _teacherRequestManager.delegate = self;
    }
    
    return _teacherRequestManager;
}

-(CommonRequestManagerClass *)commonRequestManager
{
    if (!_commonRequestManager) {
        _commonRequestManager = [CommonRequestManagerClass new];
        _commonRequestManager.delegate = self;
    }
    
    return _commonRequestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    
    _modelArray = [NSMutableArray array];
    [self.view addSubview:self.mainTableView];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
    [self getCommentList];
}

#pragma mark - 刷新
-(void)refresh
{
    _page = 1;
    [self getCommentList];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _page ++;
    [self getCommentList];
}

#pragma mark - 获取评论列表
-(void)getCommentList
{
    [self.dynamicRequestManager postDynamicCommentListWithToken:Token
                                                      dynamicId:_dynamicModel.dynamicId
                                                       parentId:@""
                                                           page:StringWithInt(_page)
                                                       pageSize:@"10"
                                                    requestName:POST_DYNAMIC_COMMENTLIST];
}

#pragma mark - 处理数据
-(void)handleListDataWithData:(NSArray *)dataArray
{
    if (_page == 1) {
        [_modelArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        DynamicCommentModel *model = [[DynamicCommentModel alloc] initModelWithDict:dic];
        [_modelArray addObject:model];
    }
    
    [_mainTableView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    if ([requestName isEqualToString:POST_DYNAMIC_COMMENTLIST]) {
        [self handleListDataWithData:info];
    }
    if ([requestName isEqualToString:POST_FOLLOW_USER]) {
        if ([info[@"sign"] intValue] == 0) {
            [QMUITips showSucceed:@"取消关注"];
        }else{
            [QMUITips showSucceed:@"已关注"];
        }
        [self refresh];
    }
    if ([requestName isEqualToString:POST_PRAISE_DYNAMICCOMMENT]) {
        [self refresh];
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
    NSString *text = @"这条动态还没有评论哦";
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
    return _modelArray.count;
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
    static NSString *cellIdentifier = @"DynamicDetailCommentCell";
    DynamicDetailCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[DynamicDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.model = _modelArray[indexPath.row];
    @weakify(self)
    cell.commentBlock = ^(DynamicCommentModel *model) {
        @strongify(self)
        self.replyBlock(self.dynamicModel.dynamicId, model.commentId);
    };
    cell.replyBlock = ^(DynamicCommentModel *model) {
        @strongify(self)
        self.replyListBlock(self.dynamicModel.dynamicId, model);
    };
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
    cell.menuBlock = ^(DynamicCommentModel *model, QMUIButton *button) {
        [self showPopViewWithSourceView:button model:model];
    };
    cell.praiseBlock = ^(DynamicCommentModel *model) {
        [self.dynamicRequestManager postPraiseDynamicCommentWithCommentId:model.commentId
                                                                    token:Token
                                                              requestName:POST_PRAISE_DYNAMICCOMMENT];
    };
    cell.tapImageBlock = ^(NSArray *imageUrls, NSInteger currentIndex) {
        [self showPhotoBrowserWithUrls:imageUrls currentIndex:currentIndex];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.selectDynamicBlock(@"1111");
}

#pragma mark - 展示操作菜单
-(void)showPopViewWithSourceView:(UIView *)sourceView model:(DynamicCommentModel *)model
{
    NSString *title1 = [model.user[@"is_follow"] intValue] == 0 ? @"添加关注" : @"取消关注";
    NSArray *titles = @[title1, @"投诉"];
    QMUIPopupMenuView *menuView = [[QMUIPopupMenuView alloc] init];
    menuView.automaticallyHidesWhenUserTap = YES;
    menuView.shouldShowItemSeparator = YES;
    menuView.maskViewBackgroundColor = UIColorClear;
    menuView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;
    menuView.itemTitleColor = UIColorMakeWithHex(@"#999999");
    NSMutableArray<QMUIPopupMenuButtonItem *> *itmes = [NSMutableArray array];
    for (int i = 0; i < titles.count; i ++) {
        QMUIPopupMenuButtonItem *item = [QMUIPopupMenuButtonItem itemWithImage:nil title:titles[i] handler:^(QMUIPopupMenuButtonItem *aItem) {
            __weak __typeof(self)weakSelf = self;
            if (i == 0) {
                [self.teacherRequestManager postFollowTeacherWithAboutType:[model.user[@"is_tutor"] intValue] == 0 ? @"1" : @"2"
                                                                  userType:@"1"
                                                                   aboutId:model.ub_id
                                                                     token:Token
                                                               requestName:POST_FOLLOW_USER];
            }else{
                [weakSelf showConplainViewWithModel:model];
            }
            
            [menuView hideWithAnimated:YES];
        }];
        [itmes addObject:item];
    }
    menuView.items = [itmes copy];
    menuView.sourceView = sourceView;
    [menuView showWithAnimated:YES];
}

#pragma mark - 展示投诉视图
-(void)showConplainViewWithModel:(DynamicCommentModel *)model
{
    PopViewController *popVC = [PopViewController new];
    popVC.submitBlock = ^(NSString *reason) {
        [self.commonRequestManager getReportWithPosition:@"6" content:reason complaints:@"" foreignId:model.commentId token:Token requestName:GET_REPORT];
        [QMUITips showSucceed:@"已投诉"];
    };
    [popVC showWithAnimated:YES completion:nil];
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
