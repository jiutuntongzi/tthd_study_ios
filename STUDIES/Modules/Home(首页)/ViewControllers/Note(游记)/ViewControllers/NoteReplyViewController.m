//
//  NoteReplyViewController.m
//  STUDIES
//
//  Created by happyi on 2019/6/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteReplyViewController.h"
#import "DynamicUserViewController.h"
#import <TZImagePickerController.h>
#import "DynamicTopicViewController.h"
#import "UserModel.h"
#import "TopicListModel.h"
#import "DynamicNoteViewController.h"
#import "NoteSearchModel.h"
#import "DynamicRequestManagerClass.h"
#import "CommonRequestManagerClass.h"
#import "ObserverClass.h"
#import "YYTextBindingParser.h"
#import "NoteRequestManagerClass.h"
@interface NoteReplyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, YYTextViewDelegate, QMUIKeyboardManagerDelegate, RequestManagerDelegate>

/** 数字提示 */
@property(nonatomic, strong) QMUILabel *numTips;
/** 工具栏 */
@property(nonatomic, strong) UIView *toolsView;
/** 选择图片视图 */
@property(nonatomic, strong) UICollectionView *collectionView;
/** 已选择的图片 */
@property(nonatomic, strong) NSMutableArray *selectedImageArray;
@property(nonatomic, strong) NSMutableArray *selectedAssetArray;
/** 内容输入栏 */
@property(nonatomic, strong) YYTextView *contentTextView;
/** 带有标签的字符串 */
@property (nonatomic, strong) NSString *tagString;
/** 选择过的用户数据 */
@property (nonatomic, strong) NSMutableArray <UserModel *> *userArray;
/** 选择过的话题数据 */
@property (nonatomic, strong) NSMutableArray <TopicListModel *> *topicArray;
/** 选择过的游记数据 */
@property (nonatomic, strong) NoteSearchModel *noteModel;
/** 请求类 */
@property (nonatomic, strong) DynamicRequestManagerClass *requestManager;
/** 话题集 */
@property (nonatomic, strong) NSMutableArray *topicIdsArray;
/** 用于监听的数组类 */
@property (nonatomic, strong) ObserverClass *observerClass;
/** 游记类 */
@property (nonatomic, strong) NoteRequestManagerClass *noteRequestManager;
@end

@implementation NoteReplyViewController

#pragma mark - lazy
-(UIView *)toolsView
{
    if (!_toolsView) {
        _toolsView = [UIView new];
        _toolsView.backgroundColor = UIColorMakeWithHex(@"#F6F5F5");
        
        NSArray *images = @[@"dynamic_icon_image", @"dynamic_icon_@", @"dynamic_icon_#", @"dynamic_icon_note"];
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < images.count; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:UIImageMake(images[i]) forState:0];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i + 1000;
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 5;
            button.layer.borderColor = UIColorMakeWithHex(@"#DCDCDC").CGColor;
            [_toolsView addSubview:button];
            [temp addObject:button];
            button.sd_layout.autoHeightRatio(1);
        }
        
        [_toolsView setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:4 itemWidth:40  verticalMargin:5 verticalEdgeInset:5 horizontalEdgeInset:30];
        
    }
    
    return _toolsView;
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

-(YYTextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [YYTextView new];
        _contentTextView.placeholderText = @"请输入您回复的内容";
        _contentTextView.placeholderFont = UIFontMake(16);
        _contentTextView.backgroundColor = UIColorMakeWithHex(@"#EEEEEE");
        _contentTextView.layer.borderWidth = 0.8;
        _contentTextView.layer.borderColor = UIColorMakeWithHex(@"#EEEEEE").CGColor;
        _contentTextView.font = UIFontMake(16);
        _contentTextView.delegate = self;
        _contentTextView.inputAccessoryView = [UIView new];
        _contentTextView.textParser = [YYTextBindingParser new];
        
        QMUIKeyboardManager *manager = [[QMUIKeyboardManager alloc] initWithDelegate:self];
        [manager addTargetResponder:_contentTextView];
    }
    
    return _contentTextView;
}

-(DynamicRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [DynamicRequestManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
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
    
    _tagString          = [[NSString alloc] init];
    _userArray          = [NSMutableArray array];
    _topicArray         = [NSMutableArray array];
    _topicIdsArray      = [NSMutableArray array];
    _selectedImageArray = [NSMutableArray array];
    _selectedAssetArray = [NSMutableArray array];
    
    _observerClass = [ObserverClass new];
    [_observerClass addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionNew context:nil];
    
    self.titleLabel.text = @"我的回复";
    
    [self.leftButton setImage:UIImageMake(@"teacher_icon_close") forState:0];
    [self.rightButton setImage:UIImageMake(@"note_icon_confirm") forState:0];
    [self.rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.toolsView];
    
    _toolsView.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    

    
    _contentTextView.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight + 15)
    .rightSpaceToView(self.view, 10)
    .heightIs(120);
    
    _collectionView.sd_layout
    .topSpaceToView(_contentTextView, 15)
    .leftEqualToView(_contentTextView)
    .rightEqualToView(_contentTextView)
    .heightIs(200);
}

-(void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClick
{
    __weak __typeof (self)weakSelf = self;
    _tagString = @"";
    [_contentTextView.attributedText enumerateAttribute:YYTextBindingAttributeName
                                                inRange:NSMakeRange(0, _contentTextView.attributedText.string.length)
                                                options:0
                                             usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                                                 NSString *temp = [self->_contentTextView.attributedText.string substringWithRange:range];
                                                 
                                                 if ([value isKindOfClass:[YYTextBinding class]]) {
                                                     if ([temp containsString:@"@"]) {
                                                         for (UserModel *model in weakSelf.userArray) {
                                                             if ([model.nickname isEqualToString:[temp substringWithRange:NSMakeRange(1, temp.length - 1)]]) {
                                                                 NSString *string = [NSString stringWithFormat:@"<user id='%@' name='%@' userType='%@'>@%@</user>", model.ub_id, model.nickname, model.user_type, model.nickname];
                                                                 weakSelf.tagString = [weakSelf.tagString stringByAppendingString:string];
                                                             }
                                                         }
                                                     }
                                                     if ([temp containsString:@"#"]) {
                                                         for (TopicListModel *model in weakSelf.topicArray) {
                                                             if ([model.title isEqualToString:temp]) {
                                                                 NSLog(@"这是添加的话题  %@", temp);
                                                                 NSString *string = [NSString stringWithFormat:@"<tag id='%@' name='%@'>%@</tag>", model.topicId, model.title, model.title];
                                                                 weakSelf.tagString = [weakSelf.tagString stringByAppendingString:string];
                                                                 [weakSelf.topicIdsArray addObject:model.topicId];
                                                             }
                                                         }
                                                     }
                                                     if ([temp containsString:@"《"]) {
                                                         NSString *string = [NSString stringWithFormat:@"<travel id='%@' name='%@'>《%@》</travel>", weakSelf.noteModel.noteId, weakSelf.noteModel.title, weakSelf.noteModel.title];
                                                         weakSelf.tagString = [weakSelf.tagString stringByAppendingString:string];
                                                     }
                                                 }else{
                                                     weakSelf.tagString = [weakSelf.tagString stringByAppendingString:temp];
                                                 }
                                                 
                                             }];
    
    //用户选择了图片或视频
    if (_selectedAssetArray.count > 0) {
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
        [self submit];
    }
}

-(void)submit
{
    NSString *imgUrls = [_observerClass.dataArray componentsJoinedByString:@","];
    [self.noteRequestManager postNoteCommentWithNoteId:_noteId
                                               replyId:_replyId
                                                  type:_type
                                               content:_tagString
                                                   img:imgUrls
                                                 token:Token
                                           requestName:POST_NOTE_COMMENT];
}

#pragma mark -- 监听调用方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"dataArray"]) {
        if (_observerClass.dataArray.count == _selectedImageArray.count) {
            [self submit];
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
    if ([requestName isEqualToString:POST_NOTE_COMMENT]) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - 键盘监听
- (void)keyboardDidChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo
{
    CGFloat height = keyboardUserInfo.endFrame.size.height;
    [UIView animateWithDuration:0.1 animations:^{
        self->_toolsView.frame = CGRectMake(0, SCREEN_HEIGHT - 50 - height, SCREEN_WIDTH, 50);
    }];
    [UIView commitAnimations];
}

-(void)keyboardWillHideWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo
{
    [UIView animateWithDuration:0.2 animations:^{
        self->_toolsView.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    }];
    [UIView commitAnimations];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - tools event
-(void)buttonClicked:(UIButton *)button
{
    [_contentTextView resignFirstResponder];
    __weak __typeof (self)weakSelf = self;
    if (button.tag == 1000) {
        [self collectionView:_collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedImageArray.count inSection:0]];
    }
    if (button.tag == 1001) {
        
        DynamicUserViewController *vc = [DynamicUserViewController new];
        vc.selectUserBlock = ^(UserModel *model, NSMutableArray<UserModel *> *userArray) {
            
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@@%@ ", weakSelf.contentTextView.text, model.nickname]];
            text.font = [UIFont systemFontOfSize:17];
            text.lineSpacing = 5;
            text.color = [UIColor blackColor];
            weakSelf.contentTextView.attributedText = text;
            
            weakSelf.userArray = userArray;
        };
        [vc showWithAnimated:YES completion:nil];
    }
    if (button.tag == 1002) {
        DynamicTopicViewController *vc = [DynamicTopicViewController new];
        vc.selectedTopic = ^(TopicListModel *model, NSMutableArray <TopicListModel *> *topicArray) {
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@ ", weakSelf.contentTextView.text, model.title]];
            text.font = [UIFont systemFontOfSize:17];
            text.lineSpacing = 5;
            text.color = [UIColor blackColor];
            weakSelf.contentTextView.attributedText = text;
            
            weakSelf.topicArray = topicArray;
        };
        [vc showWithAnimated:YES completion:nil];
    }
    if (button.tag == 1003) {
        __block BOOL isFinished = NO;
        
        [_contentTextView.attributedText enumerateAttribute:YYTextBindingAttributeName
                                                    inRange:NSMakeRange(0, _contentTextView.attributedText.string.length)
                                                    options:0
                                                 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                                                     NSString *temp = [self->_contentTextView.attributedText.string substringWithRange:range];
                                                     
                                                     if ([value isKindOfClass:[YYTextBinding class]]) {
                                                         if ([temp containsString:@"《"]) {
                                                             [SVProgressHUD showErrorWithStatus:@"只能选择一篇游记，请先删除后再选择"];
                                                             isFinished = YES;
                                                         }
                                                     }
                                                 }];
        
        if (isFinished == YES) {
            return;
        }
        
        DynamicNoteViewController *vc = [DynamicNoteViewController new];
        vc.selectedNoteBlock = ^(NoteSearchModel *model) {
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@《%@》 ", weakSelf.contentTextView.text, model.title]];
            text.font = [UIFont systemFontOfSize:17];
            text.lineSpacing = 5;
            text.color = [UIColor blackColor];
            weakSelf.contentTextView.attributedText = text;
            
            weakSelf.noteModel = model;
        };
        [vc showWithAnimated:YES completion:nil];
    }
}

#pragma mark -- collectionViewDelegate & dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    for (PHAsset *asset in _selectedAssetArray) {
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            return _selectedImageArray.count;
        }
    }
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
        
        PHAsset *asset = _selectedAssetArray[indexPath.item];
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            UIImageView *playIcon = [UIImageView new];
            playIcon.image = UIImageMake(@"dynamic_icon_play");
            [cell.contentView addSubview:playIcon];
            
            playIcon.sd_layout
            .centerYEqualToView(cell.contentView)
            .centerXEqualToView(cell.contentView)
            .widthIs(30)
            .heightEqualToWidth();
        }
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
        imagePickerVc.maxImagesCount = 1;
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
