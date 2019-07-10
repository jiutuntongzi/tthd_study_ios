//
//  MineBindPhoneViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineBindPhoneViewController.h"
#import "MineBindCodeViewController.h"
#import "LoginRequestManagerClass.h"

@interface MineBindPhoneViewController ()<QMUITextFieldDelegate, RequestManagerDelegate>

/** 编辑框 */
@property (nonatomic, strong) QMUITextField *phoneTextField;
/** 获取验证码按钮 */
@property (nonatomic, strong) QMUIButton *codeButton;
/** 请求类 */
@property (nonatomic, strong) LoginRequestManagerClass *requestManager;

@end

@implementation MineBindPhoneViewController

#pragma mark - lazy
-(QMUITextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [QMUITextField new];
        _phoneTextField.placeholder = @"请输入手机号码";
        _phoneTextField.font = UIFontMake(15);
        _phoneTextField.layer.cornerRadius = 5;
        _phoneTextField.layer.borderColor = UIColorGray.CGColor;
        _phoneTextField.layer.borderWidth = 0.5;
        _phoneTextField.delegate = self;
        _phoneTextField.backgroundColor = UIColorMakeWithHex(@"#E5E5E5");
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return _phoneTextField;
}

-(QMUIButton *)codeButton
{
    if (!_codeButton) {
        _codeButton = [QMUIButton new];
        [_codeButton setTitle:@"获取验证码" forState:0];
        [_codeButton setTitleColor:UIColorWhite forState:0];
        [_codeButton setBackgroundColor:UIColorMakeWithHex(@"#04BCB2")];
        _codeButton.titleLabel.font = UIFontMake(16);
        _codeButton.layer.cornerRadius = 3;
        [_codeButton addTarget:self action:@selector(bindCodeClick) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _codeButton;
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
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"绑定手机";
    
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.codeButton];
    
    _phoneTextField.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 10 + BaseNavViewHeight + BaseStatusViewHeight)
    .rightSpaceToView(self.view, 10)
    .heightIs(40);
    
    _codeButton.sd_layout
    .topSpaceToView(_phoneTextField, 20)
    .centerXEqualToView(self.view)
    .heightIs(45)
    .widthIs(150);
}

-(void)bindCodeClick
{
    [_phoneTextField resignFirstResponder];
    [self.requestManager getUserAuthCodeWithPhoneNumber:_phoneTextField.text requestName:GET_AUTHCODE];
}


#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_AUTHCODE]) {
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        MineBindCodeViewController *vc = [MineBindCodeViewController new];
        vc.phoneNumber = _phoneTextField.text;
        [self.navigationController pushViewController:vc animated:YES];
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
