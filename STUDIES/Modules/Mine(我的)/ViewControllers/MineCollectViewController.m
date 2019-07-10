//
//  MineCollectViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineCollectViewController.h"
#import "MineNoteCell.h"
#import "NoteDetailViewController.h"
#import "UserReqeustManagerClass.h"
#import "NoteSearchModel.h"
#import "UserCollectModel.h"
#import "UserCollectLineModel.h"
#import "LineSearchCell.h"
#import "LineThemeItemModel.h"
#import "LineDetailNewViewController.h"
#import "NoteRequestManagerClass.h"
#import "LineRequestManagerClass.h"

@interface MineCollectViewController ()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;
/** 请求类 */
@property (nonatomic, strong) UserReqeustManagerClass *requestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 请求页 */
@property (nonatomic, assign) int page;
/** 游记请求 */
@property (nonatomic, strong) NoteRequestManagerClass *noteRequestManager;
/** 路线请求 */
@property (nonatomic, strong) LineRequestManagerClass *lineRequestManager;
@end

@implementation MineCollectViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseStatusViewHeight - BaseNavViewHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[MineNoteCell class]
               forCellReuseIdentifier:NSStringFromClass([MineNoteCell class])];
        [_mainTableView registerClass:[LineSearchCell class]
               forCellReuseIdentifier:NSStringFromClass([LineThemeItemModel class])];
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
    
    return _mainTableView;
}

-(UserReqeustManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [UserReqeustManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

-(NoteRequestManagerClass *)noteRequestManager
{
    if (!_noteRequestManager) {
        _noteRequestManager = [NoteRequestManagerClass new];
        _noteRequestManager.delegate = self;
    }
    
    return _noteRequestManager;
}

-(LineRequestManagerClass *)lineRequestManager
{
    if (!_lineRequestManager) {
        _lineRequestManager = [LineRequestManagerClass new];
        _lineRequestManager.delegate = self;
    }
    
    return _lineRequestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray array];
    
    self.titleLabel.text = @"收藏夹";
    [self.view addSubview:self.mainTableView];
    
    [self refresh];
}

#pragma mark - 刷新
-(void)refresh
{
    _page = 1;
    [self getList];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _page ++;
    [self getList];
}

-(void)getList
{
    [self.requestManager getUserCollectWithOffset:StringWithInt(_page)
                                            limit:@"10"
                                            token:Token
                                      requestName:GET_USER_COLLECT];
}

#pragma mark - 数据处理
-(void)handleCollectDataWithData:(NSArray *)dataArray
{
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        UserCollectModel *model = [[UserCollectModel alloc] initModelWithDict:dic];
        [_dataArray addObject:model];
    }
    
    [_mainTableView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_footer endRefreshing];
    [_mainTableView.mj_header endRefreshing];
    
    if ([requestName isEqualToString:GET_USER_COLLECT]) {
        [self handleCollectDataWithData:info];
    }
    if ([requestName isEqualToString:POST_NOTE_COLLECT] || [requestName isEqualToString:POST_LINE_COLLECT]) {
        [self refresh];
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
    NSString *text = @"收藏夹是空的，请先去收藏吧";
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCollectModel *collectModel = _dataArray[indexPath.row];
    if ([collectModel.type intValue] == 1) {
        //游记
        static NSString *cellIdentifier = @"MineNoteCell";
        MineNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MineNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NoteSearchModel *sModel = [[NoteSearchModel alloc] initModelWithDict:collectModel.travels];
        cell.model = sModel;
        return cell;
    }else{
        //路线
        static NSString *cellIdentifier = @"LineSearchCell";
        LineSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[LineSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        LineThemeItemModel *model = [[LineThemeItemModel alloc] initModelWithDict:collectModel.path];
        cell.model = model;
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCollectModel *collectModel = _dataArray[indexPath.row];
    if ([collectModel.type intValue] == 1) {
        NoteSearchModel *sModel = [[NoteSearchModel alloc] initModelWithDict:collectModel.travels];
        NoteDetailViewController *vc = [NoteDetailViewController new];
        vc.noteId = sModel.noteId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LineThemeItemModel *model = [[LineThemeItemModel alloc] initModelWithDict:collectModel.path];
        LineDetailNewViewController *vc = [LineDetailNewViewController new];
        vc.lineId = model.pId;
        vc.tutorId = model.tutor_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"取消收藏" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self removeWithIndexPath:indexPath];
        completionHandler (YES);
    }];
    deleteRowAction.image = [UIImage imageNamed:@"删除"];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}

#pragma mark - 取消收藏
-(void)removeWithIndexPath:(NSIndexPath *)indexPath
{
    UserCollectModel *collectModel = _dataArray[indexPath.row];
    if ([collectModel.type intValue] == 1) {
        NoteSearchModel *sModel = [[NoteSearchModel alloc] initModelWithDict:collectModel.travels];
        [self.noteRequestManager postCollectNoteWithNoteId:sModel.noteId
                                                     token:Token
                                               requestName:POST_NOTE_COLLECT];
    }else{
        LineThemeItemModel *model = [[LineThemeItemModel alloc] initModelWithDict:collectModel.path];
        [self.lineRequestManager postLineCollectWithLineId:model.pId
                                                     token:Token
                                               requestName:POST_LINE_COLLECT];
    }
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
