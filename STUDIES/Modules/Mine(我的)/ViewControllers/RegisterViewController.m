//
//  RegisterViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginView.h"
#import "SetPwdViewController.h"
#import "LoginRequestManagerClass.h"
#import "UserInfoModel.h"
@interface RegisterViewController ()<RequestManagerDelegate>
/** 登录视图 */
@property(nonatomic, strong) LoginView *loginView;
/** 请求类 */
@property(nonatomic, strong) LoginRequestManagerClass *requestManager;
/** 验证码 */
@property(nonatomic, strong) NSString *authCode;
/** 手机号码 */
@property(nonatomic, strong) NSString *phoneNumber;

@end

@implementation RegisterViewController

-(LoginRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [[LoginRequestManagerClass alloc] init];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"注册";
    self.rightButton.hidden = YES;
    self.navView.backgroundColor = UIColorMakeWithHex(@"#4EE5DE");
    self.statusView.backgroundColor = UIColorMakeWithHex(@"#4EE5DE");
    self.view.backgroundColor = [UIColor colorWithPatternImage:UIImageMake(@"bg_login")];
    
    [self setLoginView];
}

#pragma mark - 登录视图
-(void)setLoginView
{
    __weak __typeof (self)weakSlef = self;
    
    UIView *bg = [UIView new];
    bg.backgroundColor = UIColorMakeWithHex(@"#9EC6C6");
    bg.layer.cornerRadius = 5;
    [self.view addSubview:bg];
    
    bg.sd_layout
    .leftSpaceToView(self.view, 35)
    .rightSpaceToView(self.view, 25)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight + 80)
    .heightIs(320);
    
    _loginView = [[LoginView alloc] initWithFrame:CGRectMake(30, BaseNavViewHeight + BaseStatusViewHeight + 75, SCREEN_WIDTH - 60, 320)];
    _loginView.type = Type_Phone_Code;
    _loginView.msgBtn.hidden = YES;
    _loginView.accountBtn.hidden = YES;
    _loginView.bottomLine.hidden = YES;
    [_loginView.loginBtn setTitle:@"下一步" forState:0];
    _loginView.forgetPwdBlock = ^{
        
    };
    _loginView.loginBlock = ^(NSString *phone, NSString *code, LoginMode mode) {
        weakSlef.authCode = code;
        weakSlef.phoneNumber = phone;
        [weakSlef.requestManager getUserLoginWithAuthCode:code phoneNumber:phone requestName:GET_LOGIN_CODE];
    };
    _loginView.getCodeBlock = ^(NSString *phone) {
        [weakSlef getCodeWithPhone:phone];
    };
    [self.view addSubview:_loginView];
    
    UIView *topView1 = [UIView new];
    topView1.backgroundColor = UIColorMakeWithHex(@"#29E0F0");
    topView1.layer.cornerRadius = 5;
    [self.view addSubview:topView1];
    
    UIView *topView2 = [UIView new];
    topView2.backgroundColor = UIColorMakeWithHex(@"#29E0F0");
    topView2.layer.cornerRadius = 5;
    [self.view addSubview:topView2];
    
    topView1.sd_layout
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight + 55)
    .leftSpaceToView(self.view, 120)
    .widthIs(10)
    .heightIs(30);
    
    topView2.sd_layout
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight + 55)
    .rightSpaceToView(self.view, 120)
    .widthIs(10)
    .heightIs(30);
}

#pragma mark - 获取验证码
-(void)getCodeWithPhone:(NSString *)phone
{
    [self.requestManager getUserAuthCodeWithPhoneNumber:phone requestName:GET_AUTHCODE];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_LOGIN_CODE]) {
        UserInfoModel *model = [[UserInfoModel alloc] initModelWithDict:info];
        model.bg_tableName = T_USERINFO;
        [model bg_saveOrUpdate];
        
        SetPwdViewController *vc = [SetPwdViewController new];
        vc.authCode = self.authCode;
        vc.phoneNumber = self.phoneNumber;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //发送验证码
    if ([requestName isEqualToString:GET_AUTHCODE]) {
        [SVProgressHUD showSuccessWithStatus:@"验证码已发送到您的手机，请注意查收"];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    //发送验证码
    if ([requestName isEqualToString:GET_AUTHCODE]) {
        [SVProgressHUD showErrorWithStatus:@"发送失败，请检查您的号码和网络"];
    }
    //登录
    if ([requestName isEqualToString:GET_LOGIN_CODE]) {
        [SVProgressHUD showErrorWithStatus:@"登录失败，请检查您的验证码是否正确"];
    }
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
