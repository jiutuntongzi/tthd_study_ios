//
//  LineDetailImagesViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineDetailImagesViewController.h"
#import "LineDetailImageCell.h"

@interface LineDetailImagesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, QMUIImagePreviewViewDelegate>

/** 主视图 */
@property(nonatomic, strong) UICollectionView *collectionView;
/** 图片浏览 */
@property(nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;

@end

@implementation LineDetailImagesViewController

#pragma mark - lazy
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH / 2, 170);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[LineDetailImageCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColorWhite;
    }
    
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"所有图片";
    [self.view addSubview:self.collectionView];
    
    _collectionView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight);
}

#pragma mark -- collectionViewDelegate & dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imgsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LineDetailImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageUrl = _imgsArray[indexPath.item];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.imagePreviewViewController) {
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        self.imagePreviewViewController.presentingStyle = QMUIImagePreviewViewControllerTransitioningStyleZoom;// 将 present 动画改为 zoom，也即从某个位置放大到屏幕中央。默认样式为 fade。
        self.imagePreviewViewController.imagePreviewView.delegate = self;// 将内部的图片查看器 delegate 指向当前 viewController，以获取要查看的图片数据
        self.imagePreviewViewController.imagePreviewView.currentImageIndex = indexPath.item;// 默认展示的图片 index
        
//        __weak __typeof(self)weakSelf = self;
        
        // 如果使用 zoom 动画，则需要在 sourceImageView 里返回一个 UIView，由这个 UIView 的布局位置决定动画的起点/终点，如果用 fade 则不需要使用 sourceImageView。
        // 另外当 sourceImageView 返回 nil 时会强制使用 fade 动画，常见的使用场景是 present 时 sourceImageView 还在屏幕内，但 dismiss 时 sourceImageView 已经不在可视区域，即可通过返回 nil 来改用 fade 动画。
//        self.imagePreviewViewController.sourceImageView = ^UIView *{
//            return weakSelf.imageButton;
//        };
        
        // 当需要在退出大图预览时做一些事情的时候，可配合 UIViewController (QMUI) 的 qmui_visibleStateDidChangeBlock 来实现。
        self.imagePreviewViewController.qmui_visibleStateDidChangeBlock = ^(QMUIImagePreviewViewController *viewController, QMUIViewControllerVisibleState visibleState) {
            if (visibleState == QMUIViewControllerWillDisappear) {
                UIImage *currentImage = [viewController.imagePreviewView zoomImageViewAtIndex:viewController.imagePreviewView.currentImageIndex].image;
                if (currentImage) {
//                    [weakSelf.imageButton setImage:currentImage forState:UIControlStateNormal];
                }
            }
        };
    }
    [self.navigationController pushViewController:self.imagePreviewViewController animated:YES];
}

#pragma mark - <QMUIImagePreviewViewDelegate>

- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return _imgsArray.count;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    zoomImageView.reusedIdentifier = @(index);
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:[NSURL URLWithString:_imgsArray[index]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        [zoomImageView showLoading];
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        zoomImageView.image = image;
        [zoomImageView hideEmptyView];
    }];
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

#pragma mark - <QMUIZoomImageViewDelegate>
- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    // 退出图片预览
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)longPressInZoomingImageView:(QMUIZoomImageView *)zoomImageView
{    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:action2];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:NULL];
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
