//
//  StudyViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "StudyViewController.h"
#import "StudyContentCell.h"
#import "StudyDetailViewController.h"
#import "LineRequestManagerClass.h"
#import "LineThemeModel.h"
#import "LineThemeItemModel.h"

@interface StudyViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, RequestManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
/** 路线请求类 */
@property(nonatomic, strong) LineRequestManagerClass *lineRequestManager;
/** 数据 */
@property(nonatomic, strong) NSMutableArray <LineThemeModel *> *themeArray;

@end

@implementation StudyViewController

#pragma mark - lazy
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH / 2, 140);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorMakeWithHex(@"#EFEFF4");
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        [_collectionView registerClass:[StudyContentCell class] forCellWithReuseIdentifier:NSStringFromClass([StudyContentCell class])];
    }
    
    return _collectionView;
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
    
    _themeArray = [NSMutableArray array];

    self.titleLabel.text = @"研学主题";
    
    [self.view addSubview:self.collectionView];
    
    [self.lineRequestManager getHotThemeWithRequestName:GET_LINE_HOTTHEME];
}

#pragma mark - 处理数据
-(void)handleHotThemeDataWithData:(NSArray *)dataArray
{
    for (NSDictionary *dict in dataArray) {
        LineThemeModel *tModel = [[LineThemeModel alloc] initModelWithDict:dict];
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"path"]) {
            LineThemeItemModel *iModel = [[LineThemeItemModel alloc] initModelWithDict:dic];
            [itemArray addObject:iModel];
        }
        tModel.path = [itemArray copy];
        [_themeArray addObject:tModel];
    }
    
    [_collectionView reloadData];
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
    NSString *text = @"暂时还没有研学主题，敬请期待";
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

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_LINE_HOTTHEME]) {
        [self handleHotThemeDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark -- collectionViewDelegate & dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _themeArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StudyContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StudyContentCell" forIndexPath:indexPath];
    cell.model = _themeArray[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    StudyDetailViewController *vc = [StudyDetailViewController new];
    vc.themeModel = _themeArray[indexPath.item];
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
