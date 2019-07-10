//
//  TopicSubmitViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/5.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TopicSubmitViewController.h"
#import <TZImagePickerController.h>

@interface TopicSubmitViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, QMUITextViewDelegate>
/** 内容输入栏 */
@property(nonatomic, strong) QMUITextView *contentTextView;
/** 选择图片视图 */
@property(nonatomic, strong) UICollectionView *collectionView;
/** 已选择的图片 */
@property(nonatomic, strong) NSMutableArray *selectedImageArray;
@property(nonatomic, strong) NSMutableArray *selectedAssetArray;

@end

@implementation TopicSubmitViewController

#pragma mark - lazy
-(QMUITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [QMUITextView new];
        _contentTextView.placeholder = @"请输入帖子内容";
        _contentTextView.backgroundColor = UIColorMakeWithHex(@"#EEEEEE");
        _contentTextView.layer.borderWidth = 0.8;
        _contentTextView.layer.borderColor = UIColorMakeWithHex(@"#EEEEEE").CGColor;
        _contentTextView.font = UIFontMake(18);
    }
    
    return _contentTextView;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.itemSize = CGSizeMake((self.view.width - 40) / 4, (self.view.width - 40) / 4);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorWhite;
    }
    
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"发布话题";
    
    [self.leftButton setImage:UIImageMake(@"teacher_icon_close") forState:0];
    [self.leftButton addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setImage:UIImageMake(@"note_icon_confirm") forState:0];
    [self.rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.collectionView];
    
    _selectedImageArray = [NSMutableArray array];
    _selectedAssetArray = [NSMutableArray array];
    
    _contentTextView.sd_layout
    .leftSpaceToView(self.view, 15)
    .topSpaceToView(self.view, 15 + BaseNavViewHeight + BaseStatusViewHeight)
    .rightSpaceToView(self.view, 15)
    .heightIs(200);
    
    _collectionView.sd_layout
    .leftEqualToView(_contentTextView)
    .topSpaceToView(_contentTextView, 20)
    .rightEqualToView(_contentTextView)
    .heightIs(280);
}

-(void)leftBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- collectionViewDelegate & dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _selectedImageArray.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = UIColorMakeWithHex(@"#666666").CGColor;
    border.fillColor = [UIColor clearColor].CGColor;
    border.path = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    border.frame = cell.bounds;
    border.lineWidth = 0.5;;
    border.lineDashPattern = @[@4, @2];
    [cell.layer addSublayer:border];
    
    if (indexPath.item < _selectedImageArray.count) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = _selectedImageArray[indexPath.item];
        [cell.contentView addSubview:imageView];
        
        imageView.sd_layout
        .leftSpaceToView(cell.contentView, 5)
        .topSpaceToView(cell.contentView, 5)
        .rightSpaceToView(cell.contentView, 5)
        .bottomSpaceToView(cell.contentView, 5);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIImageMake(@"teacher_icon_deleteimage") forState:0];
        [button addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10000 + indexPath.item;
        [cell.contentView addSubview:button];
        
        button.sd_layout
        .topEqualToView(cell.contentView)
        .rightEqualToView(cell.contentView)
        .widthIs(20)
        .heightIs(20);
    }
    
    if (indexPath.item == _selectedImageArray.count) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = UIImageMake(@"teacher_icon_addimage");
        [cell.contentView addSubview:imageView];
        
        QMUILabel *label = [MyTools labelWithText:@"点击上传" textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(14) textAlignment:NSTextAlignmentCenter];
        [cell.contentView addSubview:label];
        
        imageView.sd_layout
        .centerXEqualToView(cell.contentView)
        .topSpaceToView(cell.contentView, 20)
        .widthIs(25)
        .heightEqualToWidth();
        
        label.sd_layout
        .topSpaceToView(imageView, 10)
        .centerXEqualToView(cell.contentView)
        .widthIs(60)
        .autoHeightRatio(0);
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == _selectedImageArray.count) {
        //选择照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:6 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
        imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
        imagePickerVc.selectedAssets = _selectedAssetArray;
        imagePickerVc.navigationBar.barTintColor = UIColorMakeWithHex(@"#91CEC0");
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.showSelectBtn = NO;
        imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
        imagePickerVc.showSelectedIndex = YES;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else{
        //预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssetArray selectedPhotos:_selectedImageArray index:indexPath.item];
        imagePickerVc.maxImagesCount = 6;
        imagePickerVc.showSelectedIndex = YES;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self->_selectedImageArray = [NSMutableArray arrayWithArray:photos];
            self->_selectedAssetArray = [NSMutableArray arrayWithArray:assets];
            [self->_collectionView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedImageArray = [NSMutableArray arrayWithArray:photos];
    _selectedAssetArray = [NSMutableArray arrayWithArray:assets];
    [_collectionView reloadData];
}

-(void)deleteImage:(UIButton *)button
{
    [_selectedAssetArray removeObjectAtIndex:button.tag - 10000];
    [_selectedImageArray removeObjectAtIndex:button.tag - 10000];
    [_collectionView reloadData];
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
