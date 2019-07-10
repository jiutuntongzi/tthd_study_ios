//
//  LoginViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LoginViewController.h"
#import "FindPwdViewController.h"
#import "ThirdLoginView.h"
#import "LoginView.h"
#import "RegisterViewController.h"
#import "LoginRequestManagerClass.h"
#import "UserInfoModel.h"
@interface LoginViewController ()<UITextFieldDelegate, RequestManagerDelegate>

/** 下划线 */
@property(nonatomic, strong) UIView *bottomLine;
/** 第三方登录UI */
@property(nonatomic, strong) ThirdLoginView *thirdLoginView;
/** 登录视图 */
@property(nonatomic, strong) LoginView *loginView;
/** 登录相关请求类 */
@property(nonatomic, strong) LoginRequestManagerClass *requestManager;

@end

@implementation LoginViewController

#pragma mark - lazy
-(ThirdLoginView *)thirdLoginView
{
    if (!_thirdLoginView) {
        _thirdLoginView = [[ThirdLoginView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 160, SCREEN_WIDTH, 160)];
    }
    
    return _thirdLoginView;
}

-(LoginRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [[LoginRequestManagerClass alloc] init];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOGIN object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"登录";
    [self.leftButton setImage:UIImageMake(@"teacher_icon_close") forState:0];
    [self.rightButton setTitle:@"注册" forState:0];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navView.backgroundColor = UIColorMakeWithHex(@"#4EE5DE");
    self.statusView.backgroundColor = UIColorMakeWithHex(@"#4EE5DE");
    self.view.backgroundColor = [UIColor colorWithPatternImage:UIImageMake(@"bg_login")];
    
//    [self.view addSubview:self.thirdLoginView];
    
    [self setLoginView];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:NOTIFICATION_LOGIN object:nil];
}

-(void)leftButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 注册
-(void)rightButtonClicked
{
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_loginView textFieldResignFirstResponder];
}

#pragma mark - 接收到登录的通知
-(void)receiveMessage:(NSNotification *)noti
{
    [self.requestManager getUserLoginWthPassword:noti.userInfo[@"password"]
                                           phone:noti.userInfo[@"phone"]
                                     requestName:GET_LOGIN_PWD];
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
    if ([UserInfoModel bg_findAll:T_USERINFO].count == 0) {
        _loginView.phoneTextField.text = @"";
    }else{
        _loginView.phoneTextField.text = [[UserInfoModel bg_findAll:T_USERINFO][0] mobile];
    }
    _loginView.forgetPwdBlock = ^{
        [weakSlef.navigationController pushViewController:[FindPwdViewController new] animated:YES];
    };
    _loginView.getCodeBlock = ^(NSString *phone) {
        [weakSlef getCodeWithPhone:phone];
    };
    _loginView.loginBlock = ^(NSString *phone, NSString *code, LoginMode mode) {
        [weakSlef loginWithPhone:phone code:code mode:mode];
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

#pragma mark - 处理登录成功后的数据
-(void)handleUserDataWithInfo:(NSDictionary *)dict
{    
    UserInfoModel *model = [[UserInfoModel alloc] initModelWithDict:dict];
    model.bg_tableName = T_USERINFO;
    [model bg_saveOrUpdate];
    
    NSLog(@"%@", [UserInfoModel bg_findAll:T_USERINFO]);
}

#pragma mark - 获取验证码
-(void)getCodeWithPhone:(NSString *)phone
{
    [self.requestManager getUserAuthCodeWithPhoneNumber:phone requestName:GET_AUTHCODE];
}

#pragma mark - 登录
-(void)loginWithPhone:(NSString *)phone code:(NSString *)code mode:(LoginMode)mode
{
    if (mode == Mode_Code) {
        [self.requestManager getUserLoginWithAuthCode:code phoneNumber:phone requestName:GET_LOGIN_CODE];
    }
    if (mode == Mode_Password) {
        [self.requestManager getUserLoginWthPassword:code phone:phone requestName:GET_LOGIN_PWD];
    }
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    //发送验证码
    if ([requestName isEqualToString:GET_AUTHCODE]) {
        [SVProgressHUD showSuccessWithStatus:@"验证码已发送到您的手机，请注意查收"];
    }
    //登录
    if ([requestName isEqualToString:GET_LOGIN_CODE] || [requestName isEqualToString:GET_LOGIN_PWD]) {
        [self handleUserDataWithInfo:info];
        self.loginSuccessBlock();
        [self dismissViewControllerAnimated:YES completion:nil];
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
    if ([requestName isEqualToString:GET_LOGIN_PWD]) {
        [SVProgressHUD showErrorWithStatus:@"登录失败，请检查您的密码是否正确"];
    }
}

@end
