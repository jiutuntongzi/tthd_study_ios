//
//  TeacherLineViewController.m
//  STUDIES
//
//  Created by happyi on 2019/3/25.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherDetailLineViewController.h"
#import "HomeLineItemCell.h"
#import "TeacherRequestManagerClass.h"
#import "HomePathModel.h"

@interface TeacherDetailLineViewController ()<RequestManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
/** 主视图 */
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/** 请求类 */
@property (nonatomic, strong) TeacherRequestManagerClass *requestManager;
/** 数据 */
@property (nonatomic, strong) NSMutableArray <HomePathModel *> *lineArray;
/** 请求页 */
@property (nonatomic, assign) int offset;
@end

@implementation TeacherDetailLineViewController

#pragma mark - lazy
-(TeacherRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [[TeacherRequestManagerClass alloc] init];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _offset = 1;
    self.view.backgroundColor = UIColorWhite;
    
    _lineArray = [NSMutableArray array];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 2, Home_Line_Height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight - 50 - 60) collectionViewLayout:layout];
    [_collectionView registerClass:[HomeLineItemCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.scrollEnabled = YES;
    _collectionView.backgroundColor = UIColorWhite;
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.view addSubview:_collectionView];
    

}

#pragma mark - 加载更多
-(void)loadMore
{
    _offset ++;
    [self getList];
}

#pragma mark - 获取列表
-(void)getList
{
    [self.requestManager getTeacherLineWithUbId:self.ub_id
                                         offset:StringWithInt(_offset)
                                          limit:@"10"
                                    requestName:GET_TEACHER_LINE];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - 数据处理
-(void)handleLineDataWithData:(NSArray *)dataArray
{
    if (_offset == 1) {
        [_lineArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        HomePathModel *model = [[HomePathModel alloc] initModelWithDict:dic];
        [_lineArray addObject:model];
    }
    [_collectionView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];
    
    if ([requestName isEqualToString:GET_TEACHER_LINE]) {
        [self handleLineDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"TA正在规划路线";
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

#pragma mark -- collectionViewDelegate & dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _lineArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeLineItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = _lineArray[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"11111");
    if (self.selectedLineBlock) {
        self.selectedLineBlock();
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
