//
//  StudyDetailViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "StudyDetailViewController.h"
#import "HomeLineItemCell.h"
#import "LineThemeItemModel.h"
#import "HomePathModel.h"
#import "LineDetailNewViewController.h"
@interface StudyDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, ImagePlayerViewDelegate>

/** banner图 */
@property(nonatomic, strong) ImagePlayerView *imagePlayerView;
/** 主视图 */
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation StudyDetailViewController

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
        _collectionView.scrollEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColorWhite;
    }
    
    return _collectionView;
}

-(ImagePlayerView *)imagePlayerView
{
    if (!_imagePlayerView) {
        _imagePlayerView = [ImagePlayerView new];
        _imagePlayerView.imagePlayerViewDelegate = self;
        _imagePlayerView.backgroundColor = [UIColor clearColor];
        _imagePlayerView.scrollInterval = 3;
        _imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
        _imagePlayerView.hidePageControl = NO;
        _imagePlayerView.endlessScroll = YES;
    }
    
    return _imagePlayerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"主题详情";
    
    [self.view addSubview:self.imagePlayerView];
    [self.view addSubview:self.collectionView];
    
    _imagePlayerView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, 180);
    _collectionView.frame = CGRectMake(0, _imagePlayerView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight);
    
     [_imagePlayerView reloadData];
}

#pragma mark - UIScrollViewDelegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"%f,", scrollView.contentOffset.y);
//    
//    __weak __typeof(self) weakSelf = self;
//    if (scrollView.contentOffset.y > 0) {
//        [UIView animateWithDuration:0.2 animations:^{
//            weakSelf.collectionView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight);
//        }];
//    }else{
//        [UIView animateWithDuration:0.2 animations:^{
//            weakSelf.collectionView.frame = CGRectMake(0, weakSelf.imagePlayerView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight);
//        }];
//    }
//    
//    [UIView commitAnimations];
//}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return 1;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    if (_themeModel == nil) {
        return;
    }
    NSArray *array = @[_themeModel.img];
    [imageView sd_setImageWithURL:[NSURL URLWithString:array[index]] placeholderImage:nil];;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didScorllIndex:(NSInteger)index
{
    
}

#pragma mark -- collectionViewDelegate & dataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _themeModel.path.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeLineItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LineThemeItemModel *model = _themeModel.path[indexPath.item];
    cell.model = (HomePathModel *)model;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LineDetailNewViewController *vc = [LineDetailNewViewController new];
    LineThemeItemModel *model = _themeModel.path[indexPath.item];
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
