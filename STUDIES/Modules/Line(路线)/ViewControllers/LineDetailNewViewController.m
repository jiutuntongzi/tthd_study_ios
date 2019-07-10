//
//  LineDetailNewViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineDetailNewViewController.h"
#import "LineRequestManagerClass.h"
#import "LineDetailModel.h"
#import "LineDetailTopCell.h"
#import "LineDetailTeacherCell.h"
#import "LineDetailRecommandCell.h"
#import "LineThemeItemModel.h"
#import "LineDetailImagesViewController.h"

@interface LineDetailNewViewController ()<UITableViewDataSource, UITableViewDelegate, RequestManagerDelegate>

/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;
/** 分享按钮 */
@property (nonatomic, strong) QMUIButton *shareButton;
/** 底部视图 */
@property (nonatomic, strong) UIView *bottomView;
/** 底部视图高度 */
@property (nonatomic, assign) CGFloat bottomHeight;
/** 路线请求类 */
@property (nonatomic, strong) LineRequestManagerClass *lineRequesManager;
/** 路线详情数据 */
@property (nonatomic, strong) LineDetailModel *detailModel;
/** cell高度 */
@property (nonatomic, assign) CGFloat webCellHeight;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *itemArray;
/** 临时webView */
@property (nonatomic, strong) UIWebView *hiddenWebView;
/** 当前网页内容 */
@property (nonatomic, strong) NSString *curHtmlString;
/** 当前索引 */
@property (nonatomic, assign) int selectedIndex;
/** 收藏按钮 */
@property (nonatomic, strong) QMUIButton *collectButton;
@end

@implementation LineDetailNewViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[LineDetailTopCell class]
               forCellReuseIdentifier:NSStringFromClass([LineDetailTopCell class])];
        [_mainTableView registerClass:[LineDetailTeacherCell class]
               forCellReuseIdentifier:NSStringFromClass([LineDetailTeacherCell class])];
        [_mainTableView registerClass:[LineDetailRecommandCell class]
               forCellReuseIdentifier:NSStringFromClass([LineDetailRecommandCell class])];
    }
    
    return _mainTableView;
}

-(QMUIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [QMUIButton new];
        [_shareButton setImage:UIImageMake(@"note_icon_share") forState:0];
//        [_shareButton addTarget:self action:@selector(sharedClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = UIColorWhite;
        _bottomView.userInteractionEnabled = YES;
        
        QMUIButton *collectButton = [QMUIButton new];
        [collectButton setImage:UIImageMake(@"note_icon_collect_normal") forState:0];
        [collectButton setImage:UIImageMake(@"note_icon_collect_selected") forState:UIControlStateSelected];
        [collectButton setTitle:@"收藏" forState:0];
        [collectButton setTitle:@"取消收藏" forState:UIControlStateSelected];
        [collectButton setTitleColor:UIColorMakeWithHex(@"#333333") forState:0];
        [collectButton addTarget:self action:@selector(collectedClick:) forControlEvents:UIControlEventTouchUpInside];
        collectButton.imagePosition = QMUIButtonImagePositionLeft;
        collectButton.spacingBetweenImageAndTitle = 10;
        [_bottomView addSubview:collectButton];
        
        _collectButton = collectButton;
        
        QMUIButton *callButton = [QMUIButton new];
        [callButton setTitle:@"立即咨询" forState:0];
        [callButton setTitleColor:UIColorWhite forState:0];
        [callButton setBackgroundColor:UIColorMakeWithHex(@"#91CEC0")];
        [_bottomView addSubview:callButton];
        
        collectButton.sd_layout
        .leftSpaceToView(_bottomView, 10)
        .topSpaceToView(_bottomView, 0)
        .widthIs(120)
        .heightIs(60);
        
        callButton.sd_layout
        .topEqualToView(_bottomView)
        .rightEqualToView(_bottomView)
        .heightIs(60)
        .widthIs(120);
    }
    
    return _bottomView;
}

-(CGFloat)bottomHeight
{
    if (!_bottomHeight) {
        _bottomHeight = [MyTools getPhoneType] == PhoneType_Screen_FULL ? 60 : 60;
    }
    
    return _bottomHeight;
}

-(LineRequestManagerClass *)lineRequesManager
{
    if (!_lineRequesManager) {
        _lineRequesManager = [[LineRequestManagerClass alloc] init];
        _lineRequesManager.delegate = self;
    }
    
    return _lineRequesManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"路线详情";
    
    _itemArray = [NSMutableArray array];
    _selectedIndex = 0;
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.mainTableView];
    [self.navView addSubview:self.shareButton];
    
    _bottomView.sd_layout
    .leftEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(self.bottomHeight);
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseStatusViewHeight + BaseNavViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(_bottomView, 0);
    
//    _shareButton.sd_layout
//    .rightSpaceToView(self.navView, 20)
//    .centerYEqualToView(self.navView)
//    .widthIs(30)
//    .heightEqualToWidth();
    
    [self.lineRequesManager getLineDetailWithLineId:self.lineId
                                            tutorId:self.tutorId
                                              token:Token
                                        requestName:GET_LINE_DETAIL];
}

#pragma mark - 收藏
-(void)collectedClick:(QMUIButton *)button
{
    button.selected = !button.selected;
    [self.lineRequesManager postLineCollectWithLineId:_lineId
                                                token:Token
                                          requestName:POST_LINE_COLLECT];
}

#pragma mark - 数据处理
-(void)handleLineDetailDataWithData:(NSDictionary *)dataDic
{
    _detailModel = [[LineDetailModel alloc] initModelWithDict:dataDic[@"path"]];
    _curHtmlString = _detailModel.intro;
    
    _collectButton.selected = [_detailModel.is_collect intValue] == 0 ? NO : YES;
    
    for (NSDictionary *dic in dataDic[@"guess"]) {
        LineThemeItemModel *model = [[LineThemeItemModel alloc] initModelWithDict:dic];
        [_itemArray addObject:model];
    }
    
    /** 临时的webview 用于计算webview的高度 */
    _hiddenWebView = [[UIWebView alloc] init];
    _hiddenWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [_hiddenWebView loadHTMLString:_detailModel.intro baseURL:nil];
    [_hiddenWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    _hiddenWebView.hidden = YES;
    [self.view addSubview:_hiddenWebView];
    
    [_mainTableView reloadData];
}

-(void)segmentAction:(UISegmentedControl *)seg
{
    _selectedIndex = (int)seg.selectedSegmentIndex;
    
    if (seg.selectedSegmentIndex == 0) {
        _curHtmlString = _detailModel.intro;
        [_hiddenWebView loadHTMLString:_detailModel.intro baseURL:nil];
    }else{
        _curHtmlString = _detailModel.notice;
        [_hiddenWebView loadHTMLString:_detailModel.notice baseURL:nil];
    }
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_LINE_DETAIL]) {
        [self handleLineDetailDataWithData:info];
    }
    if ([requestName isEqualToString:POST_LINE_COLLECT]) {
        if ([info[@"sign"] intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        }
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return _webCellHeight + 40 + 20;
    }
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return CGFLOAT_MIN;
//    }
//    if (section == 1) {
//        return 40;
//    }
//    return 40;
    if (section == 2) {
        return 80;
    }
    if (section == 3) {
        return 40;
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
    
    if (section == 2) {
        NSArray *titleArray = [[NSArray alloc] initWithObjects:@"路线介绍",@"购买须知", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:titleArray];
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = UIColorMakeWithHex(@"#91CEC0");
        UIFont *font = [UIFont boldSystemFontOfSize:16];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [segmentedControl setTitleTextAttributes:attributes
                                        forState:UIControlStateNormal];
        [segmentedControl addTarget:self
                             action:@selector(segmentAction:)
                   forControlEvents:UIControlEventValueChanged];
        segmentedControl.frame = CGRectMake(SCREEN_WIDTH / 2 - 100, 10, 200, 40);
        segmentedControl.selectedSegmentIndex = _selectedIndex;
        [view addSubview:segmentedControl];
        
        UIView *line = [UIView new];
        line.backgroundColor = UIColorGray;
        line.frame = CGRectMake(0, 60, SCREEN_WIDTH, 1);
        [view addSubview:line];
    }
    
    if (section == 3) {
        QMUILabel *titleLabel = [MyTools labelWithText:@"猜您喜欢" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
        titleLabel.frame = CGRectMake(10, 0, SCREEN_WIDTH, 40);
        [view addSubview:titleLabel];
    }

    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof (self)weakSelf = self;
    
    if (indexPath.section == 0) {
        
        static NSString *identifier = @"LineDetailTopCell";
        LineDetailTopCell *cell = (LineDetailTopCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.model = _detailModel;
        cell.imagePlayerBlock = ^{
            LineDetailImagesViewController *vc = [LineDetailImagesViewController new];
            vc.imgsArray = weakSelf.detailModel.imgs;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    if (indexPath.section == 1) {
        static NSString *identifier = @"LineDetailTeacherCell";
        LineDetailTeacherCell *cell = (LineDetailTeacherCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.model = _detailModel;
    
        return cell;
    }
    
    if (indexPath.section == 2) {
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
        
        UIWebView *webView = [[UIWebView alloc] init];
        [webView loadHTMLString:_curHtmlString baseURL:nil];
        webView.frame = CGRectMake(0, 10, SCREEN_WIDTH, _webCellHeight);
        [cell.contentView addSubview:webView];
        
        
        return cell;
    }

    if (indexPath.section == 3) {
        static NSString *identifier = @"LineDetailRecommandCell";
        LineDetailRecommandCell *cell = (LineDetailRecommandCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectedLineBlock = ^(NSString *lineId, NSString *tutorId) {
            LineDetailNewViewController *vc = [LineDetailNewViewController new];
            vc.lineId = lineId;
            vc.tutorId = tutorId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.dataArray = _itemArray;
        return cell;
    }
//
//    if (indexPath.section == 4) {
//        static NSString *identifier = @"HomeLiveCell";
//        HomeLiveCell *cell = (HomeLiveCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//        cell.selectedLiveBlock = ^{
//            [weakSelf.navigationController pushViewController:[LiveDetailViewController new] animated:YES];
//        };
//        return cell;
//    }
//
//    if (indexPath.section == 5) {
//        static NSString *identifier = @"HomeInteractCell";
//        HomeInteractCell *cell = (HomeInteractCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//        cell.selectedInteractBlock = ^{
//            [weakSelf.navigationController pushViewController:[InteractDetailViewController new] animated:YES];
//        };
//        return cell;
//    }
//
//    if (indexPath.section == 6) {
//        static NSString *identifier = @"HomeTeacherCell";
//        HomeTeacherCell *cell = (HomeTeacherCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//        cell.dataArray = _tutorsArray;
//        cell.selectedTeacherBlock = ^{
//            [weakSelf.navigationController pushViewController:[TeacherDetailPagerViewController new] animated:YES];
//        };
//        return cell;
//    }
//
//    if (indexPath.section == 7) {
//        static NSString *identifier = @"HomeLineCell";
//        HomeLineCell *cell = (HomeLineCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//        cell.dataArray = _pathsArray;
//        cell.selectedLineBlock = ^{
//            [weakSelf.navigationController pushViewController:[LineDetailPagerViewController new] animated:YES];
//        };
//        return cell;
//    }
//
//    if (indexPath.section == 8) {
//        static NSString *identifier = @"HomeTravelCell";
//        HomeTravelCell *cell = (HomeTravelCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//        cell.model = (NoteListModel *)_travelsArray[indexPath.row];
//        return cell;
//    }
    
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
    if (indexPath.section == 8) {
//        [self.navigationController pushViewController:[NoteDetailViewController new] animated:YES];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGPoint point = [change[@"new"] CGPointValue];
        CGFloat height = point.y;
        _webCellHeight = height;
        [_mainTableView reloadData];
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
