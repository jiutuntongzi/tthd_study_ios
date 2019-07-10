//
//  MineSetPasswordViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineSetPasswordViewController.h"
#import "UserInfoModel.h"
#import "UserReqeustManagerClass.h"
@interface MineSetPasswordViewController ()<QMUITextFieldDelegate, RequestManagerDelegate>

@property (nonatomic, strong) QMUITextField *pwdOldTextField;
@property (nonatomic, strong) QMUITextField *pwdNewTextField;
/** 确定按钮 */
@property (nonatomic, strong) QMUIButton *sureButton;
/** 请求类 */
@property (nonatomic, strong) UserReqeustManagerClass *requestManager;
@end

@implementation MineSetPasswordViewController

#pragma mark - lazy
-(QMUITextField *)pwdOldTextField
{
    if (!_pwdOldTextField) {
        _pwdOldTextField = [QMUITextField new];
        _pwdOldTextField.placeholder = @"请输入密码";
        _pwdOldTextField.font = UIFontMake(15);
        _pwdOldTextField.layer.cornerRadius = 5;
        _pwdOldTextField.layer.borderColor = UIColorGray.CGColor;
        _pwdOldTextField.layer.borderWidth = 0.5;
        _pwdOldTextField.delegate = self;
        _pwdOldTextField.backgroundColor = UIColorMakeWithHex(@"#E5E5E5");
    }
    
    return _pwdOldTextField;
}

-(QMUITextField *)pwdNewTextField
{
    if (!_pwdNewTextField) {
        _pwdNewTextField = [QMUITextField new];
        _pwdNewTextField.placeholder = @"请输入至少6位数新密码";
        _pwdNewTextField.font = UIFontMake(15);
        _pwdNewTextField.layer.cornerRadius = 5;
        _pwdNewTextField.layer.borderColor = UIColorGray.CGColor;
        _pwdNewTextField.layer.borderWidth = 0.5;
        _pwdNewTextField.delegate = self;
        _pwdNewTextField.backgroundColor = UIColorMakeWithHex(@"#E5E5E5");
    }
    
    return _pwdNewTextField;
}

-(QMUIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [QMUIButton new];
        [_sureButton setTitle:@"完成" forState:0];
        [_sureButton setTitleColor:UIColorWhite forState:0];
        [_sureButton setBackgroundColor:UIColorMakeWithHex(@"#04BCB2")];
        _sureButton.titleLabel.font = UIFontMake(18);
        _sureButton.layer.cornerRadius = 3;
        [_sureButton addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sureButton;
}

-(UserReqeustManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [UserReqeustManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"修改密码";
    
    [self.view addSubview:self.pwdOldTextField];
//    [self.view addSubview:self.pwdNewTextField];
    [self.view addSubview:self.sureButton];
    
    _pwdOldTextField.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight + 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(40);
    
//    _pwdNewTextField.sd_layout
//    .leftEqualToView(_pwdOldTextField)
//    .rightEqualToView(_pwdOldTextField)
//    .topSpaceToView(_pwdOldTextField, 20)
//    .heightIs(40);
    
    _sureButton.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(_pwdOldTextField, 30)
    .widthIs(150)
    .heightIs(50);
}

-(void)completeClick
{
    [self.requestManager postUserInfoWithAvatar:@""
                                       username:@""
                                       nickname:@""
                                            bio:@""
                                       password:_pwdOldTextField.text
                                         gender:@""
                                          token:Token
                                    requestName:POST_USER_INFO];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:POST_USER_INFO]) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
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
