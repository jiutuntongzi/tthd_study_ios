//
//  DynamicSearchViewController.m
//  STUDIES
//
//  Created by happyi on 2019/6/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicSearchViewController.h"
#import "DynamicRequestManagerClass.h"
#import "DynamicListModel.h"
#import "CommonRequestManagerClass.h"
#import "TeacherRequestManagerClass.h"
#import "DynamicContentCell.h"
#import "PopViewController.h"
#import "DynamicDetailPagerViewController.h"
#import "NoteDetailViewController.h"
#import "TopicDetailPagerViewController.h"
#import "TeacherDetailPagerViewController.h"

@interface DynamicSearchViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, RequestManagerDelegate, UISearchBarDelegate>

/** 搜索栏 */
@property(nonatomic, strong) UISearchBar *mySearchBar;
/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 请求页 */
@property(nonatomic, assign) int offset;
/** 关键字 */
@property(nonatomic, strong) NSString *keyword;
/** 动态请求类 */
@property (nonatomic, strong) DynamicRequestManagerClass *requestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 公共请求类 */
@property (nonatomic, strong) CommonRequestManagerClass *commomRequestManager;
/** 导师请求类 */
@property (nonatomic, strong) TeacherRequestManagerClass *teacherRequestManager;

@end

@implementation DynamicSearchViewController

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
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.emptyDataSetDelegate = self;
//        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
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
    
    _dataArray = [NSMutableArray array];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.mySearchBar];
    self.leftButton.hidden = YES;
    [self.rightButton setTitle:@"取消" forState:0];
    [self.rightButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
    _mySearchBar.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, BaseStatusViewHeight - 5)
    .rightSpaceToView(self.view, 60)
    .heightIs(BaseNavViewHeight + 10);
}

#pragma mark - 返回
-(void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _offset = 1;
    _keyword = searchBar.text;
    [_mySearchBar resignFirstResponder];

    
    [self.requestManager postDynamicSearchWithKey:searchBar.text
                                             ubId:self.ubId
                                      requestName:POST_DYNAMIC_SEARCH];
}

#pragma mark - 刷新
-(void)refresh
{
    [_dataArray removeAllObjects];
    [self.requestManager postDynamicSearchWithKey:_keyword
                                             ubId:self.ubId
                                      requestName:POST_DYNAMIC_SEARCH];
}

#pragma mark - 加载更多
-(void)loadMore
{
    [self.requestManager postDynamicSearchWithKey:_keyword
                                             ubId:self.ubId
                                      requestName:POST_DYNAMIC_SEARCH];
}

#pragma mark - 处理数据
-(void)handleFynamicListWithData:(NSArray *)dataArray
{
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
    if ([requestName isEqualToString:POST_DYNAMIC_SEARCH]) {
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
    cell.followButton.hidden = YES;
    cell.tapContent = ^(NSDictionary *userInfo, NSString *content) {
        if ([content containsString:@"@"]) {
            TeacherDetailPagerViewController *vc = [TeacherDetailPagerViewController new];
            vc.ub_id = userInfo[@"id"];
            vc.userType = userInfo[@"usertype"];
            [self.navigationController pushViewController:vc animated:YES];
            //个人
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicDetailPagerViewController *vc = [DynamicDetailPagerViewController new];
    vc.dynamicModel = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
