//
//  LinePlaceDetailViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LinePlaceDetailViewController.h"
#import "HomeLineItemCell.h"
#import "LineDetailNewViewController.h"
#import "LineRequestManagerClass.h"
#import "LineThemeItemModel.h"

@interface LinePlaceDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, RequestManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** banner图 */
@property(nonatomic, strong) UIImageView *topImageView;
/** 主视图 */
@property(nonatomic, strong) UICollectionView *collectionView;
/** 目的地请求类 */
@property(nonatomic, strong) LineRequestManagerClass *lineRequestManager;
/** 数据 */
@property(nonatomic, strong) NSMutableArray <LineThemeItemModel *> *pathArray;
@end

@implementation LinePlaceDetailViewController

#pragma mark - lazy
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH / 2, Home_Line_Height);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[HomeLineItemCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColorWhite;
    }
    
    return _collectionView;
}

-(UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView = [UIImageView new];
    }
    
    return _topImageView;
}

-(LineRequestManagerClass *)lineRequestManager
{
    if (!_lineRequestManager) {
        _lineRequestManager = [[LineRequestManagerClass alloc] init];
        _lineRequestManager.delegate = self;
    }
    
    return _lineRequestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"详情";
    
    _pathArray = [NSMutableArray array];
    
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.collectionView];
    
    _topImageView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, 180);
    _collectionView.frame = CGRectMake(0, _topImageView.bottom + 10, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight - 190);
    
    [self.lineRequestManager getDestinationLineWithDId:self.dId offset:@"1" limit:@"10" requestName:GET_LINE_DESTINATIONLINE];
}

#pragma mark - 数据处理
-(void)handleDestinationLineDataWithData:(NSDictionary *)dataDic
{
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]] placeholderImage:nil];
    
    for (NSDictionary *dic in dataDic[@"path"]) {
        LineThemeItemModel *model = [[LineThemeItemModel alloc] initModelWithDict:dic];
        [_pathArray addObject:model];
    }
    
    [_collectionView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_LINE_DESTINATIONLINE]) {
        [self handleDestinationLineDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"提示";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"当前目的地暂无路线";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
    return _pathArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeLineItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = (HomePathModel *)_pathArray[indexPath.item];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LineDetailNewViewController *vc = [LineDetailNewViewController new];
    LineThemeItemModel *model = _pathArray[indexPath.item];
    vc.lineId = model.pId;
    vc.tutorId = model.tutor_id;
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
