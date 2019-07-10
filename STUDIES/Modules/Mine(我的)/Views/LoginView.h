//
//  LoginView.h
//  STUDIES
//
//  Created by happyi on 2019/4/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 输入框类型

 - Type_Phone_Code: 手机号码与验证码
 - Type_Phone_Password: 手机号码与密码
 - Type_Password_Password: 密码与密码
 */
typedef NS_OPTIONS(NSInteger, TextFieldType) {
    Type_Phone_Code       = 0,
    Type_Phone_Password ,
    Type_Password_Password
};

/**
 登录方式

 - Mode_Code: 验证码登录
 - Mode_Password: 密码登录
 */
typedef NS_OPTIONS(NSInteger, LoginMode) {
    Mode_Code       = 0,
    Mode_Password
};

@interface LoginView : UIView<QMUITextFieldDelegate>

/** 下划线 */
@property(nonatomic, strong) UIView *bottomLine;
/** 账号按钮 */
@property(nonatomic, strong) UIButton *accountBtn;
/** 短信登录按钮 */
@property(nonatomic, strong) UIButton *msgBtn;
/** 发送验证码按钮 */
@property(nonatomic, strong) UIButton *codeBtn;
/** 忘记密码按钮 */
@property(nonatomic, strong) UIButton *forgetPwdBtn;
/** 密码和验证码输入框 */
@property(nonatomic, strong) QMUITextField *codeTextField;
/** 手机号码输入框 */
@property(nonatomic, strong) QMUITextField *phoneTextField;
/** 登录按钮 */
@property(nonatomic, strong) UIButton *loginBtn;
/** 顶部标题 */
@property(nonatomic, strong) UILabel *topLabel;
/** 登录的block */
@property(nonatomic, copy) void(^loginBlock)(NSString *phone, NSString *code, LoginMode mode);
/** 忘记密码的block */
@property(nonatomic, copy) void(^forgetPwdBlock)(void);
/** 获取验证码block */
@property(nonatomic, copy) void(^getCodeBlock)(NSString *phone);
/** 输入框类型 */
@property(nonatomic, assign) TextFieldType type;
/** 登录方式 */
@property(nonatomic, assign) LoginMode mode;

/**
 键盘失焦
 */
-(void)textFieldResignFirstResponder;

@end

