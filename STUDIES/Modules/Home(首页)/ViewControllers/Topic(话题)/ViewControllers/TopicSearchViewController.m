//
//  TopicSearchViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TopicSearchViewController.h"
#import "TopicSearchCell.h"
#import "TopicRequestManagerClass.h"
#import "TopicListModel.h"
#import "TopicDetailPagerViewController.h"

@interface TopicSearchViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, RequestManagerDelegate, UISearchBarDelegate>

/** 搜索栏 */
@property(nonatomic, strong) UISearchBar *mySearchBar;
/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 数据 */
@property(nonatomic, strong) NSMutableArray *topicArray;
/** 请求类 */
@property(nonatomic, strong) TopicRequestManagerClass *requestManager;

@end

@implementation TopicSearchViewController

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
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[TopicSearchCell class]
               forCellReuseIdentifier:NSStringFromClass([TopicSearchCell class])];
    }
    
    return _mainTableView;
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

#pragma mark ---
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _topicArray = [NSMutableArray array];
    
    _requestManager = [TopicRequestManagerClass new];
    _requestManager.delegate = self;
    
    self.leftButton.hidden = YES;
    [self.rightButton setTitle:@"取消" forState:0];
    [self.rightButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.mySearchBar];
    [self.view addSubview:self.mainTableView];
    
    _mySearchBar.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, BaseStatusViewHeight + 5)
    .rightSpaceToView(self.view, 60)
    .heightIs(BaseNavViewHeight - 10);
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_topicArray removeAllObjects];
    [_mySearchBar resignFirstResponder];
    [_requestManager postTopicSearchWithKeyword:searchBar.text
                                           page:@"1"
                                       pageSize:@"100"
                                    requestName:POST_TOPIC_SEARCH];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:POST_TOPIC_SEARCH]) {
        for (NSDictionary *dic in info) {
            TopicListModel *model = [[TopicListModel alloc] initModelWithDict:dic];
            [_topicArray addObject:model];
        }
        
        [_mainTableView reloadData];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - 返回
-(void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _topicArray.count;
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
    static NSString *cellIdentifier = @"TopicSearchCell";
    TopicSearchCell *cell = (TopicSearchCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.model = _topicArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicListModel *model = _topicArray[indexPath.row];
    TopicDetailPagerViewController *vc = [TopicDetailPagerViewController new];
    vc.topicId = model.topicId;
    [self.navigationController pushViewController:vc animated:YES];
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
