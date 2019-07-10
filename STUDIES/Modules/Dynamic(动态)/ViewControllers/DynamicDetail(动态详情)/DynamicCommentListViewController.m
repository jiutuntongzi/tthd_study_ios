//
//  DynamicCommentListViewController.m
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicCommentListViewController.h"
#import "DynamicDetailCommentCell.h"
#import "DynamicRequestManagerClass.h"
#import "DynamicReplyViewController.h"
#import "CommonRequestManagerClass.h"
#import "PopViewController.h"
#import "DynamicDetailReplyCell.h"
#import "TeacherRequestManagerClass.h"
#import "TeacherDetailPagerViewController.h"
#import "NoteDetailViewController.h"
#import "TopicDetailPagerViewController.h"

@interface DynamicCommentListViewController ()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate>

/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 回复的数据源 */
@property(nonatomic, strong) NSMutableArray *dataArray;
/** 请求类 */
@property(nonatomic, strong) DynamicRequestManagerClass *requestManager;
/** 公共请求 */
@property(nonatomic, strong) CommonRequestManagerClass *commonRequestManager;
/** 导师请求类 */
@property(nonatomic, strong) TeacherRequestManagerClass *teacherRequestManager;
/** 回复按钮 */
@property(nonatomic, strong) QMUIButton *replyButton;
/** 当前页 */
@property(nonatomic, assign) int offset;
/** 索引 */
@property(nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation DynamicCommentListViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[DynamicDetailCommentCell class]
               forCellReuseIdentifier:NSStringFromClass([DynamicDetailCommentCell class])];
        [_mainTableView registerClass:[DynamicDetailReplyCell class] forCellReuseIdentifier:NSStringFromClass([DynamicDetailReplyCell class])];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
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

-(CommonRequestManagerClass *)commonRequestManager
{
    if (!_commonRequestManager) {
        _commonRequestManager = [CommonRequestManagerClass new];
        _commonRequestManager.delegate = self;
    }
    
    return _commonRequestManager;
}

-(TeacherRequestManagerClass *)teacherRequestManager
{
    if (!_teacherRequestManager) {
        _teacherRequestManager = [TeacherRequestManagerClass new];
        _teacherRequestManager.delegate = self;
    }
    
    return _teacherRequestManager;
}

-(QMUIButton *)replyButton
{
    if (!_replyButton) {
        _replyButton = [QMUIButton new];
        [_replyButton setTitle:@"回复评论" forState:0];
        [_replyButton setTitleColor:UIColorWhite forState:0];
        [_replyButton setBackgroundColor:UIColorMakeWithHex(@"#91CEC0")];
        _replyButton.titleLabel.font = UIFontMake(18);
        [_replyButton addTarget:self action:@selector(replyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _replyButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    _offset = 1;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@条回复", self.model.reply[@"count"]];
    
    [self.view addSubview:self.replyButton];
    [self.view addSubview:self.mainTableView];
    
    _replyButton.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs([MyTools getPhoneType] == PhoneType_Screen_FULL ? 80 : 50)
    .widthIs(SCREEN_WIDTH);
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(_replyButton, 0);
    
    [self getList];
}

-(void)getList
{
    [self.requestManager postDynamicCommentListWithToken:Token
                                               dynamicId:_dynamicId
                                                parentId:_model.commentId
                                                    page:StringWithInt(_offset)
                                                pageSize:@"10"
                                             requestName:POST_DYNAMIC_COMMENTLIST];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _offset ++;
    [self getList];
}

#pragma mark - 回复
-(void)replyClick
{
    @weakify(self)
    DynamicReplyViewController *vc = [DynamicReplyViewController new];
    vc.dynamicId = _dynamicId;
    vc.parentId = _model.commentId;
    vc.submitSuccessBlock = ^{
        @strongify(self)
        self.offset = 1;
        [self getList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_footer endRefreshing];
    //回复列表
    if ([requestName isEqualToString:POST_DYNAMIC_COMMENTLIST]) {
        [self handleReplyListWithData:info];
    }
    //点赞
    if ([requestName isEqualToString:POST_PRAISE_DYNAMICCOMMENT]) {
        
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - 处理回复列表的数据
-(void)handleReplyListWithData:(NSArray *)data
{
    if (_offset == 1) {
        [_dataArray removeAllObjects];
    }
    for (NSDictionary *dict in data) {
        DynamicCommentModel *model = [[DynamicCommentModel alloc] initModelWithDict:dict];
        [_dataArray addObject:model];
    }
    
    [_mainTableView reloadData];
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : _dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 20;
    }
    
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof (self)weakSelf = self;
    
    static NSString *identifier = @"DynamicDetailReplyCell";
    DynamicDetailReplyCell *cell = (DynamicDetailReplyCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[DynamicDetailReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 0) {
        cell.model = _model;
        cell.checkBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }else{
        cell.model = _dataArray[indexPath.row];
        cell.commentButton.hidden = YES;
        cell.checkButton.hidden = YES;
    }

    cell.menuBlock = ^(DynamicCommentModel *model, QMUIButton *button) {
        [weakSelf showPopViewWithSourceView:button model:model];
    };
    cell.praiseBlock = ^(DynamicCommentModel *model) {
        [weakSelf.requestManager postPraiseDynamicCommentWithCommentId:model.commentId
                                                                 token:Token
                                                           requestName:POST_PRAISE_DYNAMICCOMMENT];
    };
    cell.tapContent = ^(NSDictionary *userInfo, NSString *content) {
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
    return cell;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
-(void)showConplainViewWithModel:(DynamicCommentModel *)model
{
    PopViewController *popVC = [PopViewController new];
    popVC.submitBlock = ^(NSString *reason) {
        [self.commonRequestManager getReportWithPosition:@"7"
                                                 content:reason
                                              complaints:@""
                                               foreignId:model.commentId
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
