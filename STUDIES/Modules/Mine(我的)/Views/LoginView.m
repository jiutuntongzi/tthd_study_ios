//
//  LoginView.m
//  STUDIES
//
//  Created by happyi on 2019/4/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        self.layer.cornerRadius = 5;
        
        [self setSubViews];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self textFieldResignFirstResponder];
}

-(void)textFieldResignFirstResponder
{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
}

#pragma mark - 子视图
-(void)setSubViews
{
    _msgBtn = [UIButton new];
    [_msgBtn setTitle:@"短信快捷登录" forState:0];
    [_msgBtn setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    [_msgBtn setTitleColor:UIColorMakeWithHex(@"#06BDB3") forState:UIControlStateSelected];
    [_msgBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _msgBtn.tag = 10001;
    _msgBtn.frame = CGRectMake(0, 15, self.width / 2, 35);
    _msgBtn.selected = YES;
    [self addSubview:_msgBtn];
    
    _accountBtn = [UIButton new];
    [_accountBtn setTitle:@"账号登录" forState:0];
    [_accountBtn setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    [_accountBtn setTitleColor:UIColorMakeWithHex(@"#06BDB3") forState:UIControlStateSelected];
    [_accountBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _accountBtn.tag = 10002;
    _accountBtn.frame = CGRectMake(self.width / 2, 15, self.width / 2, 35);
    [self addSubview:_accountBtn];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = UIColorMakeWithHex(@"#06BDB3");
    _bottomLine.frame = CGRectMake(5, _accountBtn.bottom, _accountBtn.width - 10, 3);
    [self addSubview:_bottomLine];
    
    _topLabel = [MyTools labelWithText:@"验证注册手机号码，为您找回密码" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentCenter];
    _topLabel.hidden = YES;
    _topLabel.frame = CGRectMake(0, 20, self.width, 25);
    [self addSubview:_topLabel];
    
    _phoneTextField = [QMUITextField new];
    _phoneTextField.font = UIFontMake(16);
    _phoneTextField.delegate = self;
//    _phoneTextField.text = @"18117014625";
    [self addSubview:_phoneTextField];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = UIColorMakeWithHex(@"#BEBEBE");
    [self addSubview:line1];
    
    _codeTextField = [QMUITextField new];
    _codeTextField.font = UIFontMake(16);
    _codeTextField.delegate = self;
    _codeTextField.secureTextEntry = YES;
    [self addSubview:_codeTextField];
    
    _codeBtn = [UIButton new];
    [_codeBtn setTitle:@"获取验证码" forState:0];
    [_codeBtn setTitleColor:UIColorMakeWithHex(@"#06BDB3") forState:0];
    _codeBtn.titleLabel.font = UIFontMake(16);
    [_codeBtn addTarget:self action:@selector(countDown:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_codeBtn];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = UIColorMakeWithHex(@"#BEBEBE");
    [self addSubview:line2];
    
    _forgetPwdBtn = [UIButton new];
    [_forgetPwdBtn setTitle:@"忘记密码？" forState:0];
    [_forgetPwdBtn setTitleColor:UIColorMakeWithHex(@"#06BDB3") forState:0];
    _forgetPwdBtn.titleLabel.font = UIFontMake(14);
    _forgetPwdBtn.hidden = YES;
    [_forgetPwdBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _forgetPwdBtn.tag = 10004;
    [self addSubview:_forgetPwdBtn];
    
    _loginBtn = [UIButton new];
    [_loginBtn setTitle:@"登录" forState:0];
    [_loginBtn setTitleColor:UIColorWhite forState:0];
    [_loginBtn setBackgroundColor:UIColorMakeWithHex(@"#06BDB3")];
    _loginBtn.titleLabel.font = UIFontMake(18);
    _loginBtn.layer.cornerRadius = 10;
    _loginBtn.tag = 10003;
    [_loginBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginBtn];
    
    _phoneTextField.sd_layout
    .leftSpaceToView(self, 30)
    .topSpaceToView(_bottomLine, 30)
    .rightSpaceToView(self, 30)
    .heightIs(30);
    
    line1.sd_layout
    .leftEqualToView(_phoneTextField)
    .topSpaceToView(_phoneTextField, 0)
    .rightSpaceToView(self, 30)
    .heightIs(0.5);
    
    _codeTextField.sd_layout
    .leftEqualToView(line1)
    .topSpaceToView(line1, 30)
    .rightSpaceToView(self, 120)
    .heightIs(30);
    
    _codeBtn.sd_layout
    .rightSpaceToView(self, 30)
    .topEqualToView(_codeTextField)
    .widthIs(90)
    .heightIs(30);
    
    line2.sd_layout
    .leftEqualToView(line1)
    .topSpaceToView(_codeTextField, 0)
    .rightSpaceToView(self, 30)
    .heightIs(0.5);
    
    _forgetPwdBtn.sd_layout
    .rightEqualToView(line2)
    .topSpaceToView(line2, 10)
    .heightIs(20)
    .widthIs(80);
    
    _loginBtn.sd_layout
    .leftSpaceToView(self, 40)
    .rightSpaceToView(self, 40)
    .topSpaceToView(line2, 50)
    .heightIs(50);
}

#pragma mark - Events
-(void)buttonClicked:(UIButton *)button
{
    [self textFieldResignFirstResponder];
    
    __weak __typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        if (button.tag == 10001) {
            [weakSelf setType:Type_Phone_Code];
            
            weakSelf.msgBtn.selected = YES;
            weakSelf.accountBtn.selected = NO;
            weakSelf.bottomLine.frame = CGRectMake(5, weakSelf.msgBtn.bottom, weakSelf.msgBtn.width - 10, 3);
            weakSelf.codeBtn.hidden = NO;
            weakSelf.forgetPwdBtn.hidden = YES;
            weakSelf.mode = Mode_Code;
        }
        if (button.tag == 10002) {
            [weakSelf setType:Type_Phone_Password];
            
            weakSelf.msgBtn.selected = NO;
            weakSelf.accountBtn.selected = YES;
            weakSelf.bottomLine.frame = CGRectMake(weakSelf.accountBtn.left + 5, weakSelf.accountBtn.bottom, weakSelf.accountBtn.width - 10, 3);
            weakSelf.codeBtn.hidden = YES;
            weakSelf.forgetPwdBtn.hidden = NO;
            weakSelf.mode = Mode_Password;
        }
        if (button.tag == 10003) {
            weakSelf.loginBlock(weakSelf.phoneTextField.text, weakSelf.codeTextField.text, weakSelf.mode);
        }
        if (button.tag == 10004) {
            weakSelf.forgetPwdBlock();
        }
    }];
    [UIView commitAnimations];
}

#pragma mark - 倒计时
-(void)countDown:(UIButton *)button
{
    if (_phoneTextField.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"请先输入正确的手机号码"];
        return;
    }
    self.getCodeBlock(_phoneTextField.text);
    //倒计时时间 - 60S
    __block NSInteger timeOut = 59;
    //执行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //计时器 -》 dispatch_source_set_timer自动生成
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时结束
                [button setTitle:@"重新发送" forState:UIControlStateNormal];
                [button setTitleColor:UIColorRed forState:UIControlStateNormal];
                [button setEnabled:YES];
                [button setUserInteractionEnabled:YES];
            });
        } else {
            //开始计时
            //剩余秒数 seconds
            NSInteger seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.1ld", seconds];
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1.0];
                NSString *title = [NSString stringWithFormat:@"%@",strTime];
                [button setTitle:title forState:UIControlStateNormal];
                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [UIView commitAnimations];
                //计时器间不允许点击
                [button setUserInteractionEnabled:NO];
            });
            timeOut--;
        }
    });
    dispatch_resume(timer);
}

#pragma mark - 分类型处理
-(void)setType:(TextFieldType)type
{
    switch (type) {
            /** 手机号码与验证码 */
        case Type_Phone_Code:
            //提示语
            _phoneTextField.placeholder = @"请输入您的手机号码";
            _codeTextField.placeholder = @"请输入验证码";
            
            //限制字符长度
            _phoneTextField.maximumTextLength = 11;
            _codeTextField.maximumTextLength = 6;
            
            //修改键盘类型
            _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
            _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
            /** 手机号码与密码 */
        case Type_Phone_Password:
            //提示语
            _phoneTextField.placeholder = @"请输入您的手机号码";
            _codeTextField.placeholder = @"请输入密码";
            
            //限制字符长度
            _phoneTextField.maximumTextLength = 11;
            _codeTextField.maximumTextLength = 20;
            
            //修改键盘类型
            _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
            _codeTextField.keyboardType = UIKeyboardTypeDefault;
            
            break;
        
            /** 密码与密码 */
        case Type_Password_Password:
            //提示语
            _phoneTextField.placeholder = @"请输入至少6位数密码";
            _codeTextField.placeholder = @"请再次输入密码";
            
            //限制字符长度
            _phoneTextField.maximumTextLength = 20;
            _codeTextField.maximumTextLength = 20;
            
            //修改键盘类型
            _phoneTextField.keyboardType = UIKeyboardTypeDefault;
            _codeTextField.keyboardType = UIKeyboardTypeDefault;
            
            break;
        default:
            break;
    }
}

@end
