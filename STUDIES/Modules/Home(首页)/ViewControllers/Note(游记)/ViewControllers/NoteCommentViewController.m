//
//  NoteCommentViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/26.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteCommentViewController.h"
#import "NoteDetailCommentModel.h"
#import "NoteDetailCommentCell.h"
#import "NoteRequestManagerClass.h"
#import "NoteDetailReplyCell.h"
#import "TrackSubmitViewController.h"
#import "PopViewController.h"
#import "CommonRequestManagerClass.h"
#import "NoteReplyViewController.h"
#import "TeacherDetailPagerViewController.h"
#import "NoteDetailViewController.h"
#import "TopicDetailPagerViewController.h"

@interface NoteCommentViewController ()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate>

/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 回复的数据源 */
@property(nonatomic, strong) NSMutableArray <NoteDetailCommentModel *>*dataArray;
/** 请求类 */
@property(nonatomic, strong) NoteRequestManagerClass *requestManager;
/** 公共请求 */
@property(nonatomic, strong) CommonRequestManagerClass *commonRequestManager;
/** 回复按钮 */
@property(nonatomic, strong) QMUIButton *replyButton;
/** 当前页 */
@property(nonatomic, assign) int offset;
/** 索引 */
@property(nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation NoteCommentViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[NoteDetailReplyCell class]
               forCellReuseIdentifier:NSStringFromClass([NoteDetailReplyCell class])];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
    
    return _mainTableView;
}

-(NoteRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [[NoteRequestManagerClass alloc] init];
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
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@条回复", self.model.reply_number];
    
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
    [self.requestManager getNoteReplyListWithNoteID:self.noteId
                                           reply_id:self.model.commentID
                                             offset:StringWithInt(_offset)
                                              limit:@"10"
                                              token:Token
                                        requestName:GET_NOTE_REPLY];
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
    NoteReplyViewController *vc = [NoteReplyViewController new];
    vc.noteId = _noteId;
    vc.replyId = _model.commentID;
    vc.type = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}
 
#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_footer endRefreshing];
    //回复列表
    if ([requestName isEqualToString:GET_NOTE_REPLY]) {
        [self handleReplyListWithData:info];
    }
    //点赞
    if ([requestName isEqualToString:POST_PRAISE]) {
        
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - 处理回复列表的数据
-(void)handleReplyListWithData:(NSArray *)data
{
    for (NSDictionary *dict in data) {
        NoteDetailCommentModel *model = [[NoteDetailCommentModel alloc] initModelWithDict:dict];
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
    return 15;
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
    
    
    static NSString *identifier = @"NoteDetailReplyCell";
    NoteDetailReplyCell *cell = (NoteDetailReplyCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[NoteDetailReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        cell.model = self.model;
        cell.checkBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }else{
        cell.model = _dataArray[indexPath.row];
        cell.commentButton.hidden = YES;
        cell.checkButton.hidden = YES;
    }
    cell.praiseBlock = ^(NoteDetailCommentModel *model) {
        weakSelf.indexPath = indexPath;
        [weakSelf.requestManager postPraiseNoteWithNoteId:weakSelf.noteId
                                                     type:@"2"
                                                  replyId:model.commentID
                                                    token:Token
                                              requestName:POST_PRAISE];
    };
    cell.menuBlock = ^(NoteDetailCommentModel *model, QMUIButton *button) {
        [self showPopViewWithTitle:@"+关注" sourceView:button];
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

-(void)showPopViewWithTitle:(NSString *)title sourceView:(UIView *)sourceView
{
    NSArray *titles = nil;
    if ([title isEqualToString:@"+关注"]) {
        titles = @[@"添加关注", @"投诉"];
    }
    if ([title isEqualToString:@"已关注"]) {
        titles = @[@"取消关注", @"投诉"];
    }
    
    // 使用方法 2，以 UIWindow 的形式显示到界面上，这种无需默认隐藏，也无需 add 到某个 UIView 上
    QMUIPopupMenuView *menuView = [[QMUIPopupMenuView alloc] init];
    menuView.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
    menuView.shouldShowItemSeparator = YES;
    menuView.maskViewBackgroundColor = UIColorClear;
    menuView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;
    menuView.itemTitleColor = UIColorMakeWithHex(@"#999999");
    NSMutableArray<QMUIPopupMenuButtonItem *> *itmes = [NSMutableArray array];
    for (int i = 0; i < titles.count; i ++) {
        QMUIPopupMenuButtonItem *item = [QMUIPopupMenuButtonItem itemWithImage:nil title:titles[i] handler:^(QMUIPopupMenuButtonItem *aItem) {
            __weak __typeof(self)weakSelf = self;
            if (i == 0) {
//                if ([aItem.title isEqualToString:@"添加关注"]) {
//                    weakSelf.isFollowed = YES;
//                }else{
//                    weakSelf.isFollowed = NO;
//                }
//                [weakSelf.mainTableView reloadData];
//
//                [weakSelf.requestManager postFollowWithAboutType:weakSelf.detailModel.user_type
//                                                         aboutId:weakSelf.detailModel.ub_id
//                                                           token:Token
//                                                     requestName:POST_FOLLOW_USER];
            }else{
                [weakSelf showConplainView];
            }
            
            [menuView hideWithAnimated:YES];
        }];
        [itmes addObject:item];
    }
    menuView.items = [itmes copy];
    menuView.sourceView = sourceView;
    [menuView showWithAnimated:YES];
}

#pragma mark - 投诉
-(void)showConplainView
{
    PopViewController *popVC = [PopViewController new];
    popVC.submitBlock = ^(NSString *reason) {
        [self.commonRequestManager getReportWithPosition:@"3"
                                                 content:reason
                                              complaints:@""
                                               foreignId:self.noteId
                                                   token:Token
                                             requestName:GET_REPORT];
        
        [QMUITips showSucceed:@"投诉成功" inView:self.view hideAfterDelay:1];
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
