//
//  FindPwdViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "FindPwdViewController.h"
#import "LoginView.h"
#import "FeedbackViewController.h"
#import "SetPwdViewController.h"
@interface FindPwdViewController ()
/** 登录视图 */
@property(nonatomic, strong) LoginView *loginView;

@end

@implementation FindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navView.backgroundColor = UIColorMakeWithHex(@"#4EE5DE");
    self.statusView.backgroundColor = UIColorMakeWithHex(@"#4EE5DE");
    self.view.backgroundColor = [UIColor colorWithPatternImage:UIImageMake(@"bg_login")];
    
    self.titleLabel.text = @"忘记密码";
    [self.rightButton removeFromSuperview];
    
    //右边按钮
    [self setRightButton];
    //添加白色盖板
    [self setCoverView];
    //登录视图
    [self setLoginView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_loginView textFieldResignFirstResponder];
}

#pragma mark - 右边按钮
-(void)setRightButton
{
    UIButton *button = [UIButton new];
    [button setTitle:@"留言反馈" forState:0];
    [button setTitleColor:UIColorWhite forState:0];
    button.titleLabel.font = UIFontMake(16);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:button];
    
    button.sd_layout
    .rightEqualToView(self.view)
    .bottomEqualToView(self.titleLabel)
    .widthIs(100)
    .heightIs(20);
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
    _loginView.type = Type_Phone_Code;
    _loginView.msgBtn.hidden = YES;
    _loginView.accountBtn.hidden = YES;
    _loginView.bottomLine.hidden = YES;
    _loginView.topLabel.hidden = NO;
    [_loginView.loginBtn setTitle:@"下一步" forState:0];
    _loginView.loginBlock = ^(NSString *phone, NSString *code, LoginMode mode) {
        SetPwdViewController *vc = [SetPwdViewController new];
        vc.phoneNumber = phone;
        vc.authCode = code;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:_loginView];
}

#pragma mark - 跳转留言反馈
-(void)buttonClick
{
    [self.navigationController pushViewController:[FeedbackViewController new] animated:YES];
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
