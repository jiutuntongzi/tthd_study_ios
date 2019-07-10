//
//  DynamicTopicViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicTopicViewController.h"
#import "TopicSearchCell.h"
#import "TopicRequestManagerClass.h"
#import "TopicListModel.h"

@interface DynamicTopicViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, RequestManagerDelegate, UISearchBarDelegate>

@property(nonatomic, strong) UITableView *mainTableView;
/** 请求类 */
@property(nonatomic, strong) TopicRequestManagerClass *requestManager;
/** 搜索 */
@property(nonatomic, strong) UISearchBar *mySearchBar;
/** 数据 */
@property(nonatomic, strong) NSMutableArray *topicArray;

@end

@implementation DynamicTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topicArray = [NSMutableArray array];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    contentView.backgroundColor = UIColorWhite;
    
    _mySearchBar = [[UISearchBar alloc] init];
    _mySearchBar.placeholder = @"请输入关键字";
    _mySearchBar.searchBarStyle = UISearchBarStyleDefault;
    _mySearchBar.barStyle = UISearchBarStyleDefault;
    _mySearchBar.backgroundImage = [[UIImage alloc] init];
    _mySearchBar.delegate = self;
    UIView *backgroundView = [_mySearchBar subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];
    backgroundView.layer.cornerRadius = 18;
    backgroundView.clipsToBounds = YES;
    backgroundView.layer.borderColor = UIColorMakeWithHex(@"#91CEC0").CGColor;
    backgroundView.layer.borderWidth = 1;
    [contentView addSubview:_mySearchBar];
    
    QMUIButton *cancelBtn = [QMUIButton new];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:UIColorMakeWithHex(@"#999999") forState:0];
    [contentView addSubview:cancelBtn];
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.sectionIndexColor = UIColorMakeWithHex(@"#999999");
    mainTableView.emptyDataSetSource = self;
    mainTableView.emptyDataSetDelegate = self;
    [mainTableView registerClass:[TopicSearchCell class] forCellReuseIdentifier:NSStringFromClass([TopicSearchCell class])];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:mainTableView];
    
    self.mainTableView = mainTableView;
    
    [self setContentView:contentView];
    
    __weak __typeof (self)weakSelf = self;
    [self setLayoutBlock:^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentView.frame = CGRectMake(0, BaseStatusViewHeight + BaseNavViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseStatusViewHeight - BaseNavViewHeight);
        
        weakSelf.mySearchBar.sd_layout
        .leftSpaceToView(contentView, 15)
        .topSpaceToView(contentView, 0)
        .rightSpaceToView(contentView, 80)
        .heightIs(BaseNavViewHeight + 10);
        
        cancelBtn.sd_layout
        .leftSpaceToView(weakSelf.mySearchBar, 5)
        .centerYEqualToView(weakSelf.mySearchBar)
        .rightSpaceToView(contentView, 5)
        .heightIs(30);
        
        mainTableView.sd_layout
        .leftEqualToView(contentView)
        .topSpaceToView(weakSelf.mySearchBar, 0)
        .bottomSpaceToView(contentView, 0)
        .widthIs(SCREEN_WIDTH);
    }];
    
    [self setShowingAnimation:^(UIView * _Nullable dimmingView, CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewFrame, void (^ _Nonnull completion)(BOOL)) {
        contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        dimmingView.alpha = 0;
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 1;
            contentView.frame = contentViewFrame;
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    }];
    
    [self setHidingAnimation:^(UIView * _Nullable dimmingView, CGRect containerBounds, CGFloat keyboardHeight, void (^ _Nonnull completion)(BOOL)) {
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 0.0;
            contentView.frame = CGRectSetY(contentView.frame, CGRectGetHeight(containerBounds));
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    }];
    
    
    _requestManager = [TopicRequestManagerClass new];
    _requestManager.delegate = self;

    [_requestManager getTopicListWithIsHot:@"1" isNew:@"" requestName:GET_TOPIC_LIST];
}

-(void)cancelClick
{
    [self hideWithAnimated:YES completion:nil];
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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        [_topicArray removeAllObjects];
        [_requestManager getTopicListWithIsHot:@"1" isNew:@"" requestName:GET_TOPIC_LIST];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_mySearchBar resignFirstResponder];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    for (NSDictionary *dic in info) {
        TopicListModel *model = [[TopicListModel alloc] initModelWithDict:dic];
        [_topicArray addObject:model];
    }
    
    [_mainTableView reloadData];
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = UIColorMakeWithHex(@"#F0FCF9");
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TopicSearchCell";
    TopicSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.model = _topicArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTopic(_topicArray[indexPath.row], _topicArray);
    [self cancelClick];
}


@end
