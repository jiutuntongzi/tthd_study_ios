//
//  NoteDetailViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "NoteDetailContentCell.h"
#import "NoteDetailCommentCell.h"
#import "NoteDetailCommentView.h"
#import "NoteCommentViewController.h"
#import "PopViewController.h"
#import "NoteRequestManagerClass.h"
#import "NoteDetailModel.h"
#import "NoteDetailCommentModel.h"
#import "CommonRequestManagerClass.h"
#import "NoteReplyViewController.h"
#import "TeacherDetailPagerViewController.h"
#import "TopicDetailPagerViewController.h"
#import "NoteDetailViewController.h"
#import "TeacherRequestManagerClass.h"

@interface NoteDetailViewController ()<UITableViewDelegate, UITableViewDataSource, QMUIKeyboardManagerDelegate, RequestManagerDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

/** 分享按钮 */
@property(nonatomic, strong) QMUIButton *shareButton;
/** 收藏按钮 */
@property(nonatomic, strong) QMUIButton *collectButton;
/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 是否已关注 */
@property(nonatomic, assign) BOOL isFollowed;
/** 投诉理由 */
@property(nonatomic, strong) NSArray *reasonsArray;
/** 已选择的理由 */
@property(nonatomic, strong) NSMutableArray *selectedReasonsArray;
/** 评论视图 */
@property(nonatomic, strong) NoteDetailCommentView *commentView;
/** 请求类 */
@property(nonatomic, strong) NoteRequestManagerClass *requestManager;
/** 公共请求类 */
@property(nonatomic, strong) CommonRequestManagerClass *commonRequestManager;
/** 用户请求类 */
@property(nonatomic, strong) TeacherRequestManagerClass *teacherRequestManager;
/** 数据模型 */
@property(nonatomic, strong) NoteDetailModel *detailModel;
/** 图片集合 */
@property(nonatomic, strong) NSMutableArray <UIImage *> *imageArray;
/** 请求当前页 */
@property(nonatomic, assign) int offset;
/** 评论数据集 */
@property(nonatomic, strong) NSMutableArray <NoteDetailCommentModel *> *commentsArray;
/** 点赞数 */
@property(nonatomic, strong) NSString *favors;
/** 点赞类型 1、游记 2、评论 */
@property(nonatomic, strong) NSString *praiseType;
/** 当前操作的index */
@property(nonatomic, assign) NSInteger rowIndex;
@end

@implementation NoteDetailViewController

-(QMUIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [QMUIButton new];
        [_shareButton setImage:UIImageMake(@"note_icon_share") forState:0];
        [_shareButton addTarget:self action:@selector(sharedClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

-(QMUIButton *)collectButton
{
    if (!_collectButton) {
        _collectButton = [QMUIButton new];
        [_collectButton setImage:UIImageMake(@"note_icon_collect_normal") forState:0];
        [_collectButton setImage:UIImageMake(@"note_icon_collect_selected") forState:UIControlStateSelected];
        [_collectButton addTarget:self action:@selector(collectedClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectButton;
}

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[NoteDetailContentCell class]
               forCellReuseIdentifier:NSStringFromClass([NoteDetailContentCell class])];
        [_mainTableView registerClass:[NoteDetailCommentCell class]
               forCellReuseIdentifier:NSStringFromClass([NoteDetailCommentCell class])];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    }
    
    return _mainTableView;
}

-(NSArray *)reasonsArray
{
    if (!_reasonsArray) {
        _reasonsArray = [NSArray arrayWithObjects:@"垃圾营销",@"涉黄信息",@"有害信息",@"违法信息",@"侵犯人身权益",@"其他", nil];
    }
    
    return _reasonsArray;
}

-(NSMutableArray *)selectedReasonsArray
{
    if (!_selectedReasonsArray) {
        _selectedReasonsArray = [NSMutableArray array];
    }
    
    return _selectedReasonsArray;
}

-(NoteDetailCommentView *)commentView
{
    __weak __typeof(self) weakSelf = self;
    if (!_commentView) {
        _commentView = [[NoteDetailCommentView alloc] initWithFrame:CGRectZero];
        _commentView.tapTextFieldBlock = ^{
            NoteReplyViewController *vc = [NoteReplyViewController new];
            vc.noteId = weakSelf.detailModel.noteId;
            vc.replyId = @"";
            vc.type = @"1";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _commentView.favorBlock = ^{
            weakSelf.praiseType = @"1";
            [weakSelf.requestManager postPraiseNoteWithNoteId:weakSelf.detailModel.noteId
                                                         type:@"1"
                                                      replyId:@""
                                                        token:Token
                                                  requestName:POST_PRAISE];
        };
    }
    
    return _commentView;
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
    
    self.titleLabel.text = @"游记详情";
    
    _isFollowed = NO;
    _imageArray = [NSMutableArray array];
    _commentsArray = [NSMutableArray array];
    
    _offset = 1;
    
    [self.navView addSubview:self.shareButton];
    [self.navView addSubview:self.collectButton];
    [self.view addSubview:self.commentView];
    [self.view addSubview:self.mainTableView];
    
    [self getNoteDetail];
    [self getNoteDetailComments];
    
    _collectButton.sd_layout
    .rightSpaceToView(self.navView, 20)
    .centerYEqualToView(self.navView)
    .widthIs(30)
    .heightEqualToWidth();
    
//    _collectButton.sd_layout
//    .rightSpaceToView(_shareButton, 20)
//    .centerYEqualToView(self.navView)
//    .widthIs(30)
//    .heightEqualToWidth();
    
    _commentView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs([MyTools getPhoneType] == PhoneType_Screen_FULL ? 80 : 60);
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(_commentView, 0);
}

#pragma mark - 获取游记详情
-(void)getNoteDetail
{
    [self.requestManager getNoteDetailWithNoteId:self.noteId
                                           token:Token
                                     requestName:GET_NOTE_DETAIL];
}

#pragma mark - 获取评论列表
-(void)getNoteDetailComments
{
    [self.requestManager getNoteDetailCommentsWithNoteId:self.noteId
                                                  offset:StringWithInt(_offset)
                                                   limit:@"10"
                                                   token:Token
                                             requestName:GET_NOTE_DETAIL_COMMENTS];
}

#pragma mark - 刷新
-(void)refresh
{
    _offset = 1;
    [self getNoteDetailComments];
}

#pragma mark - 加载更多
-(void)loadMore
{
    _offset ++;
    [self getNoteDetailComments];
}

#pragma mark - 数据处理
-(void)handleDetailDataWithData:(NSDictionary *)dict
{
    self.detailModel = [[NoteDetailModel alloc] initModelWithDict:dict];
    _favors = self.detailModel.live_number;
    _commentView.isFavored = [self.detailModel.is_live intValue] == 0 ? NO : YES;
    _commentView.favores = _favors;
    
    self.collectButton.selected = [self.detailModel.is_collect intValue] == 0 ? NO : YES;
    
    __weak __typeof (self)weakSelf = self;
    if (_detailModel.imgs.count == 0) {
        [_mainTableView reloadData];
        return;
    }
    for (NSString *imgUrl in _detailModel.imgs) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager loadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [weakSelf.imageArray addObject:image];
            [weakSelf.mainTableView reloadData];
            
        }];
    }
    
}

-(void)handleCommentsDataWithData:(NSArray *)dataArray
{
    if (dataArray.count > 0) {
        if (_offset == 1) {
            [_commentsArray removeAllObjects];
        }
        for (NSDictionary *dict in dataArray) {
            NoteDetailCommentModel *model = [[NoteDetailCommentModel alloc] initModelWithDict:dict];
            [_commentsArray addObject:model];
        }
        
        [_mainTableView reloadSection:2 withRowAnimation:0];;
    }
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    //获取详情
    if ([requestName isEqualToString:GET_NOTE_DETAIL]) {
        [self handleDetailDataWithData:info];
    }
    //获取评论列表
    if ([requestName isEqualToString:GET_NOTE_DETAIL_COMMENTS]) {
        [self handleCommentsDataWithData:info];
    }
    //收藏
    if ([requestName isEqualToString:POST_NOTE_COLLECT]) {
        NSLog(@"111");
    }
    //关注
    if ([requestName isEqualToString:POST_FOLLOW_USER]) {
        _detailModel.is_follow = info[@"sign"];
        [_mainTableView reloadData];
    }
    //投诉
    if ([requestName isEqualToString:GET_REPORT]) {
        [QMUITips showSucceed:@"投诉成功" inView:self.view hideAfterDelay:2];
    }
    //点赞
    if ([requestName isEqualToString:POST_PRAISE]) {
        if ([_praiseType isEqualToString:@"1"]) {
            if ([info[@"sign"] intValue] == 0) {
                _favors = StringWithInt([_favors intValue] - 1);
                _commentView.favores = _favors;
            }else{
                _favors = StringWithInt([_favors intValue] + 1);
                _commentView.favores = _favors;
            }
        }else{
            NoteDetailCommentModel *model = _commentsArray[_rowIndex];
            if ([info[@"sign"] intValue] == 0) {
                model.live_number = StringWithInt([model.live_number intValue] - 1);
                model.is_live = @"0";
            }else{
                model.live_number = StringWithInt([model.live_number intValue] + 1);
                model.is_live = @"1";
            }
            [_commentsArray replaceObjectAtIndex:_rowIndex withObject:model];
            [_mainTableView reloadData];
        }
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - 收藏
-(void)collectedClick:(QMUIButton *)sender
{
    sender.selected = !sender.selected;
    [self.requestManager postCollectNoteWithNoteId:self.noteId
                                             token:Token
                                       requestName:POST_NOTE_COLLECT];
}

#pragma mark - 菜单
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
                if ([aItem.title isEqualToString:@"添加关注"]) {
                    weakSelf.isFollowed = YES;
                }else{
                    weakSelf.isFollowed = NO;
                }
                [weakSelf.mainTableView reloadData];
                
                [weakSelf.requestManager postFollowWithAboutType:weakSelf.detailModel.user_type
                                                         aboutId:weakSelf.detailModel.ub_id
                                                           token:Token
                                                     requestName:POST_FOLLOW_USER];
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

-(void)showPopViewWithSourceView:(QMUIButton *)button model:(NoteDetailCommentModel *)model
{
    NSString *title1 = @"";
    if ([model.is_follow intValue] == 0) {
        title1 = @"添加关注";
    }else{
        title1 = @"取消关注";
    }
    NSArray *titles = [NSArray arrayWithObjects:title1, @"投诉", nil];    
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
                if ([aItem.title isEqualToString:@"添加关注"]) {
                    weakSelf.isFollowed = YES;
                }else{
                    weakSelf.isFollowed = NO;
                }
                [weakSelf.mainTableView reloadData];
                
//                [weakSelf.requestManager postFollowWithAboutType:weakSelf.detailModel.user_type
//                                                         aboutId:weakSelf.detailModel.ub_id
//                                                           token:Token
//                                                     requestName:POST_FOLLOW_USER];
                
                [weakSelf.teacherRequestManager postFollowTeacherWithAboutType:@"1"
                                                                      userType:@"1"
                                                                       aboutId:model.ub_id
                                                                         token:Token
                                                                   requestName:POST_FOLLOW_USER];
            }else{
                [weakSelf showConplainView];
            }
            
            [menuView hideWithAnimated:YES];
        }];
        [itmes addObject:item];
    }
    menuView.items = [itmes copy];
    menuView.sourceView = button;
    [menuView showWithAnimated:YES];
}

#pragma mark - 分享
-(void)sharedClick
{
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    moreOperationController.items = @[
                                      @[
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"微信好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              
                                              [moreOperationController hideToBottom];// 如果嫌每次都在 handler 里写 hideToBottom 烦，也可以直接把这句写到 moreOperationController:didSelectItemView: 里，它可与 handler 共存
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"朋友圈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareWeibo") title:@"微博" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                          }],
                                          ],
                                      ];
    [moreOperationController showFromBottom];
}

#pragma mark - 投诉
-(void)showConplainView
{
    NSString *positon = @"";
    if ([_praiseType isEqualToString:@"2"]) {
        positon = @"2";
    }else{
        positon = @"1";
    }
    PopViewController *popVC = [PopViewController new];
    popVC.submitBlock = ^(NSString *reason) {
        [self.commonRequestManager getReportWithPosition:positon
                                                 content:reason
                                              complaints:@""
                                               foreignId:self->_detailModel.noteId
                                                   token:Token
                                             requestName:GET_REPORT];
    };
    [popVC showWithAnimated:YES completion:nil];
    
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _imageArray.count;
    }
    if (section == 2) {
        return _commentsArray.count;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (_imageArray.count == 0) {
            return 20;
        }
        UIImage *image = _imageArray[indexPath.row];
        return image.size.width > SCREEN_WIDTH ? SCREEN_WIDTH * image.size.height / image.size.width + 5 : image.size.height + 5;
    }
    if (indexPath.section == 2) {
        return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
    }
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 60;
    }
    
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = BaseBackgroundColor;
    
    UILabel *title = [MyTools labelWithText:@"全部回复" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    [view addSubview:title];
    
    title.sd_layout
    .leftSpaceToView(view, 15)
    .topSpaceToView(view, 15)
    .widthIs(80)
    .autoHeightRatio(0);
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof (self)weakSelf = self;
    
    if (indexPath.section == 0) {
        
        static NSString *identifier = @"NoteDetailContentCell";
        NoteDetailContentCell *cell = (NoteDetailContentCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        __weak __typeof(cell)weakCell = cell;
        cell.model = _detailModel;
        cell.followBlock = ^(NSString *title) {
            [self showPopViewWithTitle:title sourceView:weakCell.followButton];
        };
        return cell;
    }
    
    if (indexPath.section == 1) {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }else{
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_imageArray.count > 0) {
            UIImage *image = _imageArray[indexPath.row];
            UIImageView *imageView = [UIImageView new];
            CGSize size = image.size.width > SCREEN_WIDTH ? CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * image.size.height / image.size.width) : image.size;
            imageView.frame = CGRectMake(5, 0, size.width - 10, size.height);
            imageView.image = image;
            [cell.contentView addSubview:imageView];
        }
        
        return cell;
    }
    
    if (indexPath.section == 2) {
        static NSString *identifier = @"NoteDetailCommentCell";
        NoteDetailCommentCell *cell = (NoteDetailCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[NoteDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        if (_commentsArray.count > 0) {
            NoteDetailCommentModel *model = _commentsArray[indexPath.row];
            cell.model = model;
            cell.replyBlock = ^(NoteDetailCommentModel *model) {                
                NoteCommentViewController *vc = [NoteCommentViewController new];
                vc.model = model;
                vc.noteId = weakSelf.noteId;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            cell.praiseBlock = ^(NoteDetailCommentModel *model) {
                weakSelf.rowIndex = indexPath.row;
                weakSelf.praiseType = @"2";
                [weakSelf.requestManager postPraiseNoteWithNoteId:weakSelf.detailModel.noteId
                                                             type:@"2"
                                                          replyId:model.commentID
                                                            token:Token
                                                      requestName:POST_PRAISE];
            };
            cell.menuBlock = ^(NoteDetailCommentModel *model,QMUIButton *button) {
                self->_praiseType = @"2";
                [self showPopViewWithSourceView:button model:model];
            };
            cell.commentBlock = ^(NoteDetailCommentModel *model) {
                NoteReplyViewController *vc = [NoteReplyViewController new];
                vc.noteId = weakSelf.detailModel.noteId;
                vc.replyId = model.commentID;
                vc.type = @"2";
                [weakSelf.navigationController pushViewController:vc animated:YES];
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
            cell.tapImageBlock = ^(NSArray *imageUrls, NSInteger currentIndex) {
                [self showPhotoBrowserWithUrls:imageUrls currentIndex:currentIndex];
            };
        }
        

        return cell;
    }
    
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self showPhotoBrowserWithUrls:_detailModel.imgs currentIndex:indexPath.row];
    }
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
