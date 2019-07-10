//
//  MineEditNameViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineEditNameViewController.h"
#import "UserReqeustManagerClass.h"
#import "UserInfoModel.h"

@interface MineEditNameViewController ()<QMUITextFieldDelegate, RequestManagerDelegate>
/** 编辑框 */
@property (nonatomic, strong) QMUITextField *nameTextField;
/** 确定按钮 */
@property (nonatomic, strong) QMUIButton *sureButton;
/** 个人请求类 */
@property (nonatomic, strong) UserReqeustManagerClass *userRequestManager;
@end

@implementation MineEditNameViewController

#pragma mark - lazy
-(QMUITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [QMUITextField new];
        _nameTextField.placeholder = @"输入您修改的名称";
        _nameTextField.font = UIFontMake(17);
        _nameTextField.layer.cornerRadius = 5;
        _nameTextField.layer.borderColor = UIColorGray.CGColor;
        _nameTextField.layer.borderWidth = 0.5;
        _nameTextField.delegate = self;
        _nameTextField.maximumTextLength = 8;
        _nameTextField.backgroundColor = UIColorMakeWithHex(@"#E5E5E5");
//        UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
//        _nameTextField.text = model.nickname;
    }
    
    return _nameTextField;
}

-(QMUIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [QMUIButton new];
        [_sureButton setTitle:@"确定" forState:0];
        [_sureButton setTitleColor:UIColorBlack forState:0];
        [_sureButton setBackgroundColor:UIColorMakeWithHex(@"#FFDD4F")];
        _sureButton.titleLabel.font = UIFontMake(16);
        _sureButton.layer.cornerRadius = 5;
        [_sureButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sureButton;
}

-(UserReqeustManagerClass *)userRequestManager
{
    if (!_userRequestManager) {
        _userRequestManager = [UserReqeustManagerClass new];
        _userRequestManager.delegate = self;
    }
    
    return _userRequestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"修改昵称";
    
    [self.navView addSubview:self.sureButton];
    [self.view addSubview:self.nameTextField];
    
    _sureButton.sd_layout
    .rightSpaceToView(self.navView, 15)
    .centerYEqualToView(self.navView)
    .widthIs(70)
    .heightIs(30);
    
    _nameTextField.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 10 + BaseNavViewHeight + BaseStatusViewHeight)
    .rightSpaceToView(self.view, 10)
    .heightIs(50);
}

-(void)submit
{
    [_nameTextField resignFirstResponder];
    [self.userRequestManager postUserInfoWithAvatar:@""
                                           username:@""
                                           nickname:_nameTextField.text
                                                bio:@""
                                           password:@""
                                             gender:@""
                                              token:Token
                                        requestName:POST_USER_INFO];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:POST_USER_INFO]) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
        model.nickname = _nameTextField.text;
        [model bg_saveOrUpdate];
        self.editNicknameSuccessBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
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
