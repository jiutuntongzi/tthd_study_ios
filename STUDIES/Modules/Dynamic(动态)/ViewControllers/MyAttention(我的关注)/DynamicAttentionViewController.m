//
//  DynamicAttentionViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicAttentionViewController.h"
#import "DynamicContentCell.h"
#import "PopViewController.h"
#import "DynamicRequestManagerClass.h"
#import "DynamicListModel.h"
#import "CommonRequestManagerClass.h"
#import "TeacherRequestManagerClass.h"
#import "VideoPlayViewController.h"

@interface DynamicAttentionViewController ()<UITableViewDelegate, UITableViewDataSource,
RequestManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;
/** 动态请求类 */
@property (nonatomic, strong) DynamicRequestManagerClass *requestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 公共请求类 */
@property (nonatomic, strong) CommonRequestManagerClass *commomRequestManager;
/** 导师请求类 */
@property (nonatomic, strong) TeacherRequestManagerClass *teacherRequestManager;
/** 请求页 */
@property (nonatomic, assign) int page;
@end

@implementation DynamicAttentionViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _page = 1;
    _dataArray = [NSMutableArray array];
    [self.view addSubview:self.mainTableView];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
    [self refresh];
}

#pragma mark - 刷新
-(void)refresh
{
    _page = 1;
    [self.requestManager getDynamicListWithToken:Token
                                            type:@"1"
                                            ubId:@""
                                        topicsId:@""
                                          lastId:@""
                                            page:StringWithInt(_page)
                                        pageSize:@"10"
                                     requestType:@"1"
                                            sort:@""
                                     requestName:GET_DYNAMIC_LIST];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _page ++;
    [self.requestManager getDynamicListWithToken:Token
                                            type:@"1"
                                            ubId:@""
                                        topicsId:@""
                                          lastId:@""
                                            page:StringWithInt(_page)
                                        pageSize:@"10"
                                     requestType:@"2"
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
    if ([requestName isEqualToString:GET_REPORT]) {
        [QMUITips showSucceed:@"投诉成功"];
    }
    if ([requestName isEqualToString:POST_FOLLOW_USER]) {
        [self refresh];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_footer endRefreshing];
    [_mainTableView.mj_header endRefreshing];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您没有关注过的动态，请先关注吧";
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
    cell.followBlock = ^(QMUIButton *button, DynamicListModel *model) {
        [self showPopViewWithSourceView:button model:model];
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
    cell.noteBlock = ^(NSString *noteId) {
        self.selectNoteBlock(noteId);
    };
    cell.playVideoBlock = ^(NSString *videoUrl) {
        VideoPlayViewController *vc = [VideoPlayViewController new];
        vc.animationStyle = QMUIModalPresentationAnimationStylePopup;
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
    self.selectDynamicBlock(_dataArray[indexPath.row]);    
}

#pragma mark - 展示操作菜单
-(void)showPopViewWithSourceView:(UIView *)sourceView model:(DynamicListModel *)model
{
    QMUIButton *button = (QMUIButton *)sourceView;
    NSArray *titles = @[button.titleLabel.text, @"投诉"];
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
                [self.teacherRequestManager postFollowTeacherWithAboutType:[model.user[@"is_tutor"] intValue] == 0 ? @"1" : @"2" userType:@"1" aboutId:model.ub_id token:Token requestName:POST_FOLLOW_USER];
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
-(void)showConplainViewWithModel:(DynamicListModel *)model
{
    PopViewController *popVC = [PopViewController new];
    popVC.submitBlock = ^(NSString *reason) {
        [self.commomRequestManager getReportWithPosition:@"5"
                                                 content:reason
                                              complaints:@""
                                               foreignId:model.dynamicId
                                                   token:Token
                                             requestName:GET_REPORT];
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
