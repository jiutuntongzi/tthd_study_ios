//
//  MineUserInfoViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineUserInfoViewController.h"
#import <TZImagePickerController.h>
#import "MineEditNameViewController.h"
#import "MineEditDesViewController.h"
#import "UserReqeustManagerClass.h"
#import "CommonRequestManagerClass.h"
#import "UserInfoModel.h"
@interface MineUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, RequestManagerDelegate>

/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;
/** 选择的图片 */
@property (nonatomic, strong) UIImage *selectedPhoto;
/** 选择的性别 */
@property (nonatomic, strong) NSString *selectedIndex;
/** 个人请求类 */
@property (nonatomic, strong) UserReqeustManagerClass *userRequestManager;
/** 公共请求类 */
@property (nonatomic, strong) CommonRequestManagerClass *commonRequestManager;
/** 头像地址 */
@property (nonatomic, strong) NSString *avatarUrl;

@end

@implementation MineUserInfoViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight + BaseStatusViewHeight) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    return _mainTableView;
}

-(UserReqeustManagerClass *)userRequestManager
{
    if (!_userRequestManager) {
        _userRequestManager = [UserReqeustManagerClass new];
        _userRequestManager.delegate = self;
    }
    
    return _userRequestManager;
}

-(CommonRequestManagerClass *)commonRequestManager
{
    if (!_commonRequestManager) {
        _commonRequestManager = [CommonRequestManagerClass new];
        _commonRequestManager.delegate = self;
    }
    
    return _commonRequestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"个人信息";

    [self.view addSubview:self.mainTableView];
}

#pragma mark - 处理结果
-(void)handleUploadResultWithData:(NSDictionary *)dic
{

}

-(void)handleUserInfoWithData:(NSDictionary *)dic
{
    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
    if (_avatarUrl.length > 0) {
        model.avatar = _avatarUrl;
    }
    if (_selectedIndex.length > 0) {
        model.gender = _selectedIndex;
    }
    [model bg_saveOrUpdate];
    
    [_mainTableView reloadData];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    //上传图片
    if ([requestName isEqualToString:GET_UPLOAD_IMAGE]) {
        [self handleUploadResultWithData:info];
    }
    //修改用户信息
    if ([requestName isEqualToString:POST_USER_INFO]) {
        [self handleUserInfoWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
    
    NSArray *titles = @[@"头像", @"昵称", @"简介", @"性别"];
    
    QMUILabel *title = [MyTools labelWithText:titles[indexPath.row] textColor:UIColorBlack textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    [cell.contentView addSubview:title];
    
    QMUILabel *content = [MyTools labelWithText:@"" textColor:UIColorMakeWithHex(@"#333333") textFont:UIFontMake(14) textAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview:content];
    
    if (indexPath.row == 0) {
        content.hidden = YES;
        
        UIImageView *avatar = [UIImageView new];
        [avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
        avatar.layer.cornerRadius = 35;
        avatar.layer.masksToBounds = YES;
        [cell.contentView addSubview:avatar];
        
        avatar.sd_layout
        .rightSpaceToView(cell.contentView, 15)
        .centerYEqualToView(cell.contentView)
        .widthIs(70)
        .heightEqualToWidth();
    }
    if (indexPath.row == 1) {
        content.text = model.nickname;
    }
    if (indexPath.row == 2) {
        content.text = model.bio;
        if (model.bio.length == 0) {
            content.text = @"修改您的简介";
            content.textColor = UIColorGray;
        }
    }
    if (indexPath.row == 3) {
        content.text = [model.gender intValue] == 0 ? @"保密" : [model.gender intValue] == 1 ? @"男" : @"女";
    }
    
    title.sd_layout
    .leftSpaceToView(cell.contentView, 15)
    .centerYEqualToView(cell.contentView)
    .widthIs(60)
    .heightIs(40);
    
    content.sd_layout
    .rightSpaceToView(cell.contentView, 15)
    .centerYEqualToView(cell.contentView)
    .widthIs(250)
    .heightIs(40);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof (self)weakSelf = self;
    
    if (indexPath.row == 0) {
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self selectPhoto];
        }];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:action2];
        [alertController addAction:action1];
        [alertController addAction:action3];
        [self presentViewController:alertController animated:YES completion:NULL];
        
    }
    if (indexPath.row == 1) {
        MineEditNameViewController *vc = [MineEditNameViewController new];
        vc.editNicknameSuccessBlock = ^{
            [weakSelf.mainTableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        MineEditDesViewController *vc = [MineEditDesViewController new];
        vc.editDesSuccessBlock = ^{
            [weakSelf.mainTableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 3) {
        [self selectFemale];
    }
}

#pragma mark - 选择照片
-(void)selectPhoto
{
    //选择照片
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:6 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.navigationBar.barTintColor = UIColorMakeWithHex(@"#91CEC0");
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    imagePickerVc.showSelectedIndex = YES;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    self.selectedPhoto = photos[0];
    [_mainTableView reloadData];
    
    //用户选择的图片
    NSMutableArray *fileNamesArray = [NSMutableArray array];
    NSMutableArray *imagesArray = [NSMutableArray array];
    UIImage *image = photos[0];
    NSString *fileName = [NSString stringWithFormat:@"image%d.png", 0];
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
            self->_avatarUrl = response[@"data"][@"url"];
            [self.userRequestManager postUserInfoWithAvatar:response[@"data"][@"url"]
                                                   username:@""
                                                   nickname:@""
                                                        bio:@""
                                                   password:@""
                                                     gender:@""
                                                      token:Token
                                                requestName:POST_USER_INFO];
        }else{
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
    } failurBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}

#pragma mark - 选择性别
-(void)selectFemale
{
    NSArray *items = @[@"保密", @"男", @"女"];
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"选择性别";
    dialogViewController.items = items;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        QMUIDialogSelectionViewController *d = (QMUIDialogSelectionViewController *)aDialogViewController;
        if (d.selectedItemIndex == QMUIDialogSelectionViewControllerSelectedItemIndexNone) {
            [QMUITips showError:@"请至少选一个" inView:d.qmui_modalPresentationViewController.view hideAfterDelay:1.2];
            return;
        }
        self.selectedIndex = StringWithInt((int)d.selectedItemIndex);
        [aDialogViewController hide];
        
        [self.userRequestManager postUserInfoWithAvatar:@""
                                               username:@""
                                               nickname:@""
                                                    bio:@""
                                               password:@""
                                                 gender:self.selectedIndex
                                                  token:Token
                                            requestName:POST_USER_INFO];
    }];
    [dialogViewController show];
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
