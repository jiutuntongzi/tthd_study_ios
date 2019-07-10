//
//  DynamicDetailPraiseViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicDetailPraiseViewController.h"
#import "DynamicRequestManagerClass.h"
#import "DynamicPraiseModel.h"

@interface DynamicDetailPraiseViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, RequestManagerDelegate>

/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

/** 请求类 */
@property (nonatomic, strong) DynamicRequestManagerClass *requestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *modelArray;
@end

@implementation DynamicDetailPraiseViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _modelArray = [NSMutableArray array];
    
    [self.view addSubview:self.mainTableView];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
    [self getLikeList];
}

-(void)refresh
{
    [self getLikeList];
}

#pragma mark - 获取点赞列表
-(void)getLikeList
{
    [self.requestManager postDynamicLikeListWithDynamicId:_dynamicModel.dynamicId
                                              requestName:POST_DYNAMIC_LIKELIST];
}

#pragma mark - 数据处理
-(void)hanldeListDataWithData:(NSArray *)dataArray
{
    for (NSDictionary *dic in dataArray) {
        DynamicPraiseModel *model = [[DynamicPraiseModel alloc] initModelWithDict:dic];
        [_modelArray addObject:model];
    }
    
    [_mainTableView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
    if ([requestName isEqualToString:POST_DYNAMIC_LIKELIST]) {
        [self hanldeListDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_mainTableView.mj_header endRefreshing];
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
    NSString *text = @"这条动态还没有被赞过哦";
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
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    DynamicPraiseModel *model = _modelArray[indexPath.row];
    
    UIImageView *avatarImageView = [UIImageView new];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:UIImageMake(@"common_icon_avatar")];
    avatarImageView.layer.cornerRadius = 30;
    avatarImageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:avatarImageView];
    
    QMUILabel *nameLabel = [MyTools labelWithText:model.nickname textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [cell.contentView addSubview:nameLabel];
    
    QMUILabel *timeLabel = [MyTools labelWithText:[KyoDateTools prettyDateWithDateString:[MyTools getDateStringWithTimeInterval:model.createtime]]
                                        textColor:UIColorGray
                                         textFont:UIFontMake(16)
                                    textAlignment:NSTextAlignmentLeft];
    [cell.contentView addSubview:timeLabel];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorGray;
    [cell.contentView addSubview:line];
    
    avatarImageView.sd_layout
    .centerYEqualToView(cell.contentView)
    .leftSpaceToView(cell.contentView, 10)
    .widthIs(60)
    .heightEqualToWidth();
    
    nameLabel.sd_layout
    .leftSpaceToView(avatarImageView, 10)
    .topEqualToView(avatarImageView)
    .widthIs(200)
    .heightIs(30);
    
    timeLabel.sd_layout
    .leftEqualToView(nameLabel)
    .bottomEqualToView(avatarImageView)
    .widthIs(200)
    .heightIs(30);
    
    line.sd_layout
    .leftEqualToView(cell.contentView)
    .bottomSpaceToView(cell.contentView, 1)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
    
    return cell;
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
