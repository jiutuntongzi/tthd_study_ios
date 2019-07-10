//
//  MineBindCodeViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineBindCodeViewController.h"
#import <JHVerificationCodeView.h>
#import "LoginRequestManagerClass.h"
#import "UserInfoModel.h"

@interface MineBindCodeViewController ()<QMUITextFieldDelegate, RequestManagerDelegate>

/** 验证码页面 */
@property (nonatomic, strong) UIView *codeView;
/** 绑定成功页面 */
@property (nonatomic, strong) UIView *successView;
/** 设置手机页面 */
@property (nonatomic, strong) UIView *phoneView;
/** 请求类 */
@property (nonatomic, strong) LoginRequestManagerClass *requestManager;
/** 验证码 */
@property (nonatomic, strong) NSString *code;
@end

@implementation MineBindCodeViewController

#pragma mark - lazy
-(UIView *)codeView
{
    if (!_codeView) {
        _codeView = [UIView new];
        _codeView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight);
        
        QMUILabel *label1 = [MyTools labelWithText:@"验证码已发送到您的手机" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentCenter];
        label1.frame = CGRectMake(0, 30, SCREEN_WIDTH, 30);
        [_codeView addSubview:label1];
        
        QMUILabel *label2 = [MyTools labelWithText:self.phoneNumber textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentCenter];
        label2.frame = CGRectMake(0, label1.bottom + 10, SCREEN_WIDTH, 30);
        [_codeView addSubview:label2];
        
        JHVCConfig *config     = [[JHVCConfig alloc] init];
        config.inputBoxBorderWidth = 0;
        config.inputBoxNumber  = 6;
        config.inputBoxSpacing = 10;
        config.inputBoxWidth   = 50;
        config.inputBoxHeight  = 45;
        config.tintColor       = [UIColor blackColor];
        config.secureTextEntry = NO;
        config.font            = [UIFont boldSystemFontOfSize:20];
        config.textColor       = UIColorMakeWithHex(@"#04BCB2");
        config.inputType       = JHVCConfigInputType_Number; // Default
        config.showUnderLine   = YES;
        config.underLineSize   = CGSizeMake(50, 1);
        config.underLineColor  = UIColorMakeWithHex(@"#DCDCDC");
        config.underLineHighlightedColor = UIColorMakeWithHex(@"#04BCB2");
        
        JHVerificationCodeView *vcView = [[JHVerificationCodeView alloc] initWithFrame:CGRectMake(30, label2.bottom + 30, SCREEN_WIDTH - 60, 50) config:config];
        vcView.finishBlock = ^(NSString *code) {
            self.code = code;
        };
        [_codeView addSubview:vcView];

        QMUIButton *sureButton = [QMUIButton new];
        [sureButton setTitle:@"下一步" forState:0];
        [sureButton setTitleColor:UIColorWhite forState:0];
        [sureButton setBackgroundColor:UIColorMakeWithHex(@"#04BCB2")];
        sureButton.titleLabel.font = UIFontMake(18);
        sureButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 75, vcView.bottom + 30, 150, 45);
        sureButton.layer.cornerRadius = 3;
        [sureButton addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
        [_codeView addSubview:sureButton];
    }
    
    return _codeView;
}

-(UIView *)phoneView
{
    if (!_phoneView) {
        _phoneView = [UIView new];
        _phoneView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight);
        
        QMUITextField *passwordTextField = [QMUITextField new];
        passwordTextField.placeholder = @"请输入您需要绑定的手机号码";
        passwordTextField.font = UIFontMake(15);
        passwordTextField.layer.cornerRadius = 5;
        passwordTextField.layer.borderColor = UIColorGray.CGColor;
        passwordTextField.layer.borderWidth = 0.5;
        passwordTextField.delegate = self;
        passwordTextField.backgroundColor = UIColorMakeWithHex(@"#E5E5E5");
        passwordTextField.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 40);
        [_phoneView addSubview:passwordTextField];
        
        QMUIButton *sureButton = [QMUIButton new];
        [sureButton setTitle:@"确定" forState:0];
        [sureButton setTitleColor:UIColorWhite forState:0];
        [sureButton setBackgroundColor:UIColorMakeWithHex(@"#04BCB2")];
        sureButton.titleLabel.font = UIFontMake(18);
        sureButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 75, passwordTextField.bottom + 30, 150, 45);
        sureButton.layer.cornerRadius = 3;
        [sureButton addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
        [_phoneView addSubview:sureButton];
    }
    
    return _phoneView;
}

-(UIView *)successView
{
    if (!_successView) {
        _successView = [UIView new];
        _successView.frame = CGRectMake(0, BaseNavViewHeight + BaseStatusViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BaseNavViewHeight - BaseStatusViewHeight);
        
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(SCREEN_WIDTH / 2 - 50, 40, 100, 100);
        imageView.image = UIImageMake(@"mine_bind_success");
        [_successView addSubview:imageView];
        
        QMUILabel *label = [MyTools labelWithText:@"更换成功！" textColor:UIColorMakeWithHex(@"#04BCB2") textFont:UIFontMake(20) textAlignment:NSTextAlignmentCenter];
        label.frame = CGRectMake(0, imageView.bottom + 10, SCREEN_WIDTH, 30);
        [_successView addSubview:label];
        
        QMUILabel *tips1 = [MyTools labelWithText:@"手机号码绑定成功，" textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(16) textAlignment:NSTextAlignmentCenter];
        tips1.frame = CGRectMake(0, label.bottom + 20, SCREEN_WIDTH, 30);
        [_successView addSubview:tips1];
        
        QMUILabel *tips2 = [MyTools labelWithText:[NSString stringWithFormat:@"您下次可以使用%@登录", self.phoneNumber]
                                        textColor:UIColorMakeWithHex(@"#666666")
                                         textFont:UIFontMake(16)
                                    textAlignment:NSTextAlignmentCenter];
        tips2.frame = CGRectMake(0, tips1.bottom + 10, SCREEN_WIDTH, 30);
        [_successView addSubview:tips2];
        
        QMUIButton *sureButton = [QMUIButton new];
        [sureButton setTitle:@"完成" forState:0];
        [sureButton setTitleColor:UIColorWhite forState:0];
        [sureButton setBackgroundColor:UIColorMakeWithHex(@"#04BCB2")];
        sureButton.titleLabel.font = UIFontMake(18);
        sureButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 75, tips2.bottom + 30, 150, 45);
        sureButton.layer.cornerRadius = 3;
        [sureButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [_successView addSubview:sureButton];
    }
    
    return _successView;
}

-(LoginRequestManagerClass *)requestManager
{
    if (!_requestManager) {
        _requestManager = [LoginRequestManagerClass new];
        _requestManager.delegate = self;
    }
    
    return _requestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"验证手机";
    
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.successView];
    
    _codeView.hidden = NO;
    _phoneView.hidden = YES;
    _successView.hidden = YES;
}

-(void)nextStepClick
{
    [self.requestManager getEditUserPhoneWithMobile:self.phoneNumber
                                               code:self.code
                                              token:Token
                                        requestName:GET_CHANGE_MOBILE];
}

-(void)completeClick
{
    _codeView.hidden = YES;
    _phoneView.hidden = YES;
    _successView.hidden = NO;
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_CHANGE_MOBILE]) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        _codeView.hidden = YES;
        _phoneView.hidden = YES;
        _successView.hidden = NO;
        
        UserInfoModel *model = [UserInfoModel bg_findAll:T_USERINFO][0];
        model.mobile = self.phoneNumber;
        [model bg_saveOrUpdate];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_CHANGE_MOBILE]) {
        [SVProgressHUD showErrorWithStatus:info];
    }
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
