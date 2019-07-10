//
//  EvaluateViewController.m
//  STUDIES
//
//  Created by happyi on 2019/3/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherEvaluateViewController.h"
#import "HCSStarRatingView.h"
#import <TZImagePickerController.h>
#import "CommonRequestManagerClass.h"
#import "TeacherRequestManagerClass.h"
#import "ObserverClass.h"
@interface TeacherEvaluateViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, QMUITextViewDelegate, RequestManagerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedImageArray;
@property (nonatomic, strong) NSMutableArray *selectedAssetArray;
@property (nonatomic, strong) QMUILabel *numLabel;
@property (nonatomic, strong) QMUITextView *textView;

@property (nonatomic, strong) CommonRequestManagerClass *commonRequestManager;
@property (nonatomic, strong) TeacherRequestManagerClass *teacherRequestManager;
/** 用于监听的数组类 */
@property (nonatomic, strong) ObserverClass *observerClass;

@property (nonatomic, strong) HCSStarRatingView *starRatingView;

@end

@implementation TeacherEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectedImageArray = [NSMutableArray array];
    _selectedAssetArray = [NSMutableArray array];
    
    _commonRequestManager = [CommonRequestManagerClass new];
    _commonRequestManager.delegate = self;
    
    _teacherRequestManager = [TeacherRequestManagerClass new];
    _teacherRequestManager.delegate = self;
    
    _observerClass = [ObserverClass new];
    [_observerClass addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionNew context:nil];
    
    //设置背景
    [self setBgLayer];
    //主视图
    [self setMainView];
}

-(void)popVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 提交
-(void)submit
{
    if (_selectedImageArray.count > 0) {
        for (int i = 0; i < _selectedImageArray.count; i ++) {
            [SVProgressHUD showWithStatus:@"正在发布"];
            //用户选择的图片
            NSMutableArray *fileNamesArray = [NSMutableArray array];
            NSMutableArray *imagesArray = [NSMutableArray array];
            UIImage *image = self->_selectedImageArray[i];
            NSString *fileName = [NSString stringWithFormat:@"image%d.png", i];
            [imagesArray addObject:image];
            [fileNamesArray addObject:fileName];
            
            BAImageDataEntity *entity = [BAImageDataEntity new];
            entity.imageArray = imagesArray;
            entity.imageType = @"jpeg/png";
            entity.urlString = [NSString stringWithFormat:@"%@%@", BaseUrl, GET_UPLOAD_IMAGE];
            entity.imageScale = 0.5;
            entity.fileNames = fileNamesArray;
            BANetManagerShare.isOpenLog = YES;
            [BANetManager ba_uploadImageWithEntity:entity successBlock:^(id response) {
                if ([response[@"code"] intValue] == 1) {
                    [[self->_observerClass mutableArrayValueForKeyPath:@"dataArray"] addObject:response[@"data"][@"url"]];
                }
            } failurBlock:^(NSError *error) {
                
            } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
            }];
        }
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:self.tutor_id forKey:@"evaluate[tutor_id]"];
        [dic setObject:[NSString stringWithFormat:@"%f", _starRatingView.value] forKey:@"evaluate[star]"];
        [dic setObject:_selectedImageArray.count == 0 ? @"" : [_observerClass.dataArray componentsJoinedByString:@","] forKey:@"evaluate[images]"];
        [dic setObject:_textView.text forKey:@"evaluate[evaluate]"];
        [dic setObject:Token forKey:@"token"];
        [self.teacherRequestManager postEvaluateTeacherWithEvaluate:dic token:Token requestName:POST_TEACHER_EVALUTE];
    }
}

#pragma mark -- 监听调用方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"dataArray"]) {
        if (_observerClass.dataArray.count == _selectedImageArray.count) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:self.tutor_id forKey:@"evaluate[tutor_id]"];
            [dic setObject:[NSString stringWithFormat:@"%f", _starRatingView.value] forKey:@"evaluate[star]"];
            [dic setObject:[_observerClass.dataArray componentsJoinedByString:@","] forKey:@"evaluate[images]"];
            [dic setObject:_textView.text forKey:@"evaluate[evaluate]"];
            [dic setObject:Token forKey:@"token"];
            [self.teacherRequestManager postEvaluateTeacherWithEvaluate:dic token:Token requestName:POST_TEACHER_EVALUTE];
        }
    }
}

-(void)dealloc
{
    [_observerClass removeObserver:self forKeyPath:@"dataArray"];
}

-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    [SVProgressHUD showSuccessWithStatus:@"已评价"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - 设置背景
-(void)setBgLayer
{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.view.bounds;
    gl.startPoint = CGPointMake(1, 1);
    gl.endPoint = CGPointMake(0, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:39/255.0 green:205/255.0 blue:235/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:133/255.0 green:251/255.0 blue:200/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.6f),@(1.0f)];
    [self.view.layer addSublayer:gl];
}

#pragma mark - 主视图
-(void)setMainView
{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:UIImageMake(@"teacher_icon_close") forState:0];
    closeBtn.frame = CGRectMake(10, BaseStatusViewHeight + 10, 40, 40);
    [closeBtn addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    UIImageView *avatar = [UIImageView new];
    avatar.image = UIImageMake(@"avatar10.jpg");
    avatar.layer.cornerRadius = 35;
    avatar.layer.masksToBounds = YES;
    avatar.frame = CGRectMake(SCREEN_WIDTH / 2 - 35, closeBtn.bottom + 5, 70, 70);
    [avatar sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:UIImageMake(@"common_icon_avatar")];
    [self.view addSubview:avatar];
    
    QMUILabel *name = [MyTools labelWithText:self.name textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentCenter];
    name.frame = CGRectMake(0, avatar.bottom + 5, SCREEN_WIDTH, 25);
    [self.view addSubview:name];
    
    _starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 70, name.bottom + 5, 140, 35)];
    _starRatingView.maximumValue = 5;
    _starRatingView.minimumValue = 0;
    _starRatingView.value = [_star intValue];
    _starRatingView.tintColor = [UIColor redColor];
    _starRatingView.allowsHalfStars = YES;
    _starRatingView.filledStarImage = UIImageMake(@"home_icon_star_fill");
    _starRatingView.emptyStarImage = UIImageMake(@"home_icon_star_empty");
    _starRatingView.halfStarImage = UIImageMake(@"home_icon_star_half");
    _starRatingView.backgroundColor = UIColorClear;
    [self.view addSubview:_starRatingView];
    
    QMUIButton *submitBtn = [QMUIButton new];
    [submitBtn setTitle:@"发表评价" forState:0];
    [submitBtn setBackgroundColor:UIColorMakeWithHex(@"#FFD800")];
    [submitBtn setTitleColor:UIColorBlack forState:0];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.titleLabel.font = UIFontMake(16);
    submitBtn.frame = CGRectMake(SCREEN_WIDTH - 90, BaseStatusViewHeight + 10, 80, 30);
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    UIView *container = [UIView new];
    container.backgroundColor = UIColorWhite;
    container.layer.cornerRadius = 8;
    container.frame = CGRectMake(10, _starRatingView.bottom + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - _starRatingView.bottom - 70);
    [self.view addSubview:container];
    
    _textView = [QMUITextView new];
    _textView.placeholder = @"请输入200字以内的评论";
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = UIColorGray.CGColor;
    _textView.font = UIFontMake(16);
    _textView.frame = CGRectMake(15, 15, container.width - 30, 150);
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    [container addSubview:_textView];
    
    _numLabel = [MyTools labelWithText:@"0/200" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(14) textAlignment:NSTextAlignmentRight];
    _numLabel.frame = CGRectMake(container.width - 15 - 80, _textView.bottom + 5, 80, 20);
    [container addSubview:_numLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake((container.width - 40) / 4, (container.width - 40) / 4);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, _numLabel.bottom + 10, container.width - 20, (container.width - 20) / 2) collectionViewLayout:layout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = UIColorWhite;
    [container addSubview:_collectionView];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [_textView resignFirstResponder];
        return NO;
    }
    if([textView.text length]+[text length]-range.length>200)
    {
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length>=200)
    {
        textView.text = [textView.text substringToIndex:200];
    }
    _numLabel.text=[NSString stringWithFormat:@"%lu/200",_textView.text.length];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [_textView resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

- (BOOL)textViewShouldReturn:(QMUITextView *)textView
{
    [_textView resignFirstResponder];
    return YES;
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
