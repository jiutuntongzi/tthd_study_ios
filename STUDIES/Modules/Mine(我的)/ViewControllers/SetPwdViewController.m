//
//  SetPwdViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "SetPwdViewController.h"
#import "LoginView.h"
#import "LoginRequestManagerClass.h"
@interface SetPwdViewController ()<RequestManagerDelegate>
/** 登录视图 */
@property(nonatomic, strong) LoginView *loginView;
/** 请求类 */
@property(nonatomic, strong) LoginRequestManagerClass *requestManager;

@end

@implementation SetPwdViewController

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
    
    self.titleLabel.text = @"设置密码";
    self.rightButton.hidden = YES;
    self.navView.backgroundColor = UIColorMakeWithHex(@"#4EE5DE");
    self.statusView.backgroundColor = UIColorMakeWithHex(@"#4EE5DE");
    self.view.backgroundColor = [UIColor colorWithPatternImage:UIImageMake(@"bg_login")];
    
    //添加白色盖板
    [self setCoverView];
    //登录视图
    [self setLoginView];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_loginView textFieldResignFirstResponder];
}

#pragma mark - 盖板
-(void)setCoverView
{
    UIView *view = [UIView new];
    view.backgroundColor = UIColorMakeWithHex(@"#F9F9F9");
    [self.view addSubview:view];
    
    view.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, 250)
    .bottomEqualToView(self.view)
    .rightEqualToView(self.view);
}

#pragma mark - 子视图
-(void)setLoginView
{
    __weak __typeof (self)weakSelf = self;
    _loginView = [[LoginView alloc] initWithFrame:CGRectMake(15, 170, SCREEN_WIDTH - 30, 320)];
    _loginView.msgBtn.hidden = YES;
    _loginView.accountBtn.hidden = YES;
    _loginView.bottomLine.hidden = YES;
    _loginView.topLabel.text = @"设置密码保证账号财产安全";
    _loginView.topLabel.hidden = NO;
    _loginView.type = Type_Password_Password;
    _loginView.codeBtn.hidden = YES;
    [_loginView.loginBtn setTitle:@"登录" forState:0];
    _loginView.loginBlock = ^(NSString *phone, NSString *code, LoginMode mode) {
        if ([weakSelf checkPassword] == NO) {
            [SVProgressHUD showErrorWithStatus:@"您两次输入的密码不一致"];
            return;
        }
        [weakSelf.requestManager getSetUserPwdWithPhone:weakSelf.phoneNumber password:code code:weakSelf.authCode requestName:GET_SETPWD];
    };
    [self.view addSubview:_loginView];
}

-(BOOL)checkPassword
{
    if (_loginView.phoneTextField.text != _loginView.codeTextField.text) {
        return NO;
    }
    return YES;
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_SETPWD]) {
        //密码设置成功，默认用户已登录，向登录页面发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_loginView.codeTextField.text, @"password", _phoneNumber, @"phone", nil]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

-(void)dealloc
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
