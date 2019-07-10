//
//  SubmitViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteSubmitViewController.h"
#import <TZImagePickerController.h>
#import "CommonRequestManagerClass.h"
#import "ObserverClass.h"
#import "NoteRequestManagerClass.h"
#import "TrackSubmitViewController.h"

@interface NoteSubmitViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, QMUITextViewDelegate, RequestManagerDelegate>

/** 标题 */
@property(nonatomic, strong) UIView *titleView;
/** 标题输入栏 */
@property(nonatomic, strong) QMUITextField *titleTextField;
/** 内容输入栏 */
@property(nonatomic, strong) QMUITextView *contentTextView;
/** 勾选按钮 */
@property(nonatomic, strong) QMUIButton *checkButton;
/** 提示语 */
@property(nonatomic, strong) QMUILabel *tipLabel;
/** 选择图片视图 */
@property(nonatomic, strong) UICollectionView *collectionView;
/** 已选择的图片 */
@property(nonatomic, strong) NSMutableArray *selectedImageArray;
@property(nonatomic, strong) NSMutableArray *selectedAssetArray;
/** 公共请求类 */
@property(nonatomic, strong) CommonRequestManagerClass *commonRequestManager;
/** 请求类 */
@property(nonatomic, strong) NoteRequestManagerClass *noteRequestManager;
/** 用于监听的数组类 */
@property(nonatomic, strong) ObserverClass *observerClass;
@end

@implementation NoteSubmitViewController

#pragma mark - lazy
-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [UIView new];
        _titleView.layer.borderWidth = 0.8;
        _titleView.layer.borderColor = UIColorMakeWithHex(@"#EEEEEE").CGColor;
        _titleView.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
        
        QMUITextField *textFiled = [QMUITextField new];
        textFiled.placeholder = @"请输入标题";
        textFiled.font = UIFontMake(18);
        textFiled.textColor = UIColorBlack;
        textFiled.maximumTextLength = 40;
        [_titleView addSubview:textFiled];
        
        _titleTextField = textFiled;

        textFiled.sd_layout
        .leftSpaceToView(_titleView, 3)
        .topSpaceToView(_titleView, 10)
        .rightSpaceToView(_titleView, 10)
        .bottomSpaceToView(_titleView, 10);
    }
    
    return _titleView;
}

-(QMUITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [QMUITextView new];
        _contentTextView.placeholder = @"请输入帖子内容";
        _contentTextView.backgroundColor = UIColorMakeWithHex(@"#EEEEEE");
        _contentTextView.layer.borderWidth = 0.8;
        _contentTextView.layer.borderColor = UIColorMakeWithHex(@"#EEEEEE").CGColor;
        _contentTextView.font = UIFontMake(17);
    }
    
    return _contentTextView;
}

-(QMUIButton *)checkButton
{
    if (!_checkButton) {
        _checkButton = [QMUIButton new];
        _checkButton.layer.borderColor = UIColorMakeWithHex(@"#EEEEEE").CGColor;
        _checkButton.layer.borderWidth = 1;
        _checkButton.layer.cornerRadius = 12;
        [_checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _checkButton;
}

-(QMUILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [MyTools labelWithText:@"发布到我的动态中" textColor:UIColorMakeWithHex(@"#292929") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    }
    
    return _tipLabel;
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

-(CommonRequestManagerClass *)commonRequestManager
{
    if (!_commonRequestManager) {
        _commonRequestManager = [CommonRequestManagerClass new];
        _commonRequestManager.delegate = self;
    }
    
    return _commonRequestManager;
}

-(NoteRequestManagerClass *)noteRequestManager
{
    if (!_noteRequestManager) {
        _noteRequestManager = [NoteRequestManagerClass new];
        _noteRequestManager.delegate = self;
    }
    
    return _noteRequestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"发布游记";
    _observerClass = [ObserverClass new];
    [_observerClass addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.leftButton setImage:UIImageMake(@"teacher_icon_close") forState:0];
    [self.rightButton setImage:UIImageMake(@"note_icon_confirm") forState:0];
    [self.rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.titleView];
    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.checkButton];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.collectionView];
    
    _selectedImageArray = [NSMutableArray array];
    _selectedAssetArray = [NSMutableArray array];
    
    _titleView.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 15 + BaseNavViewHeight + BaseStatusViewHeight)
    .rightSpaceToView(self.view, 10)
    .heightIs(50);
    
    _contentTextView.sd_layout
    .leftEqualToView(_titleView)
    .topSpaceToView(_titleView, 15)
    .rightEqualToView(_titleView)
    .heightIs(200);
    
    _checkButton.sd_layout
    .leftEqualToView(_contentTextView)
    .topSpaceToView(_contentTextView, 15)
    .widthIs(24)
    .heightEqualToWidth();
    
    _tipLabel.sd_layout
    .leftSpaceToView(_checkButton, 10)
    .centerYEqualToView(_checkButton)
    .widthIs(150)
    .autoHeightRatio(0);
    
    _collectionView.sd_layout
    .leftEqualToView(_titleView)
    .topSpaceToView(_checkButton, 20)
    .rightEqualToView(_titleView)
    .heightIs(280);
}

-(void)rightBtnClick
{
    if (_titleTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先输入标题"];
        return;
    }
    if (_contentTextView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }
    

    if (_selectedImageArray.count > 0) {
        
        [_selectedImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            [SVProgressHUD showWithStatus:@"正在发布"];
            NSMutableArray *fileNamesArray = [NSMutableArray array];
            NSMutableArray *imagesArray = [NSMutableArray array];
            UIImage *image = self->_selectedImageArray[idx];
            NSString *fileName = [NSString stringWithFormat:@"image%lu.png", (unsigned long)idx];
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
                    
                    NSLog(@"11111111111111111111111");
                    [[self->_observerClass mutableArrayValueForKeyPath:@"dataArray"] addObject:response[@"data"][@"url"]];
                }
            } failurBlock:^(NSError *error) {
                
            } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
            }];
            
        }];
        
        
    }else{
        NSDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"1" forKey:@"user_type"];
        [dict setValue:_titleTextField.text forKey:@"title"];
        [dict setValue:_contentTextView.text forKey:@"content"];
        [dict setValue:@"" forKey:@"imgs"];
        
        [self.noteRequestManager postSubmitNoteWithTravels:dict userType:@"1" token:Token requestName:POST_NOTE_SUBMIT];
    }
}

-(void)checkButtonClicked:(QMUIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderWidth = 5;
        sender.layer.borderColor = UIColorMakeWithHex(@"#91CEC0").CGColor;
    }else{
        _checkButton.layer.borderColor = UIColorMakeWithHex(@"#EEEEEE").CGColor;
        _checkButton.layer.borderWidth = 1;
    }
}

#pragma mark -- 监听调用方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"dataArray"]) {
        if (_observerClass.dataArray.count == _selectedImageArray.count) {
            NSLog(@"%@", _observerClass.dataArray);
            
            NSDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:@"1" forKey:@"user_type"];
            [dict setValue:_titleTextField.text forKey:@"title"];
            [dict setValue:_contentTextView.text forKey:@"content"];
            [dict setValue:[_observerClass.dataArray componentsJoinedByString:@","] forKey:@"imgs"];
            
            [self.noteRequestManager postSubmitNoteWithTravels:dict userType:@"1" token:Token requestName:POST_NOTE_SUBMIT];
        }
    }
}

-(void)dealloc
{
    [_observerClass removeObserver:self forKeyPath:@"dataArray"];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:POST_NOTE_SUBMIT]) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        if (_checkButton.selected == YES) {
            TrackSubmitViewController *vc = [TrackSubmitViewController new];
            vc.noteId = info[@"travels_id"];
            vc.noteTitle = _titleTextField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
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
