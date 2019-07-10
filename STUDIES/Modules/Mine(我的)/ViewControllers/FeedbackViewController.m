//
//  FeedbackViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"留言反馈";
    self.rightButton.hidden = YES;
    self.navView.backgroundColor = UIColorMakeWithHex(@"#4EE5DE");
    self.statusView.backgroundColor = UIColorMakeWithHex(@"#4EE5DE");
    self.view.backgroundColor = [UIColor colorWithPatternImage:UIImageMake(@"bg_login")];
    
    [self setLabels];
}

#pragma mark - 文本
-(void)setLabels
{
    UILabel *label1 = [MyTools labelWithText:@"无法登录？手机号码不存在？" textColor:UIColorWhite textFont:UIFontBoldMake(17) textAlignment:NSTextAlignmentCenter];
    UILabel *label2 = [MyTools labelWithText:@"无法找回密码？收不到验证码？" textColor:UIColorWhite textFont:UIFontBoldMake(17) textAlignment:NSTextAlignmentCenter];
    UILabel *label3 = [MyTools labelWithText:@"留下您的联系方式，我们会尽快回复您~" textColor:UIColorWhite textFont:UIFontBoldMake(17) textAlignment:NSTextAlignmentCenter];
    [self.view sd_addSubviews:@[label1, label2, label3]];
    
    label1.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight + 40)
    .rightEqualToView(self.view)
    .autoHeightRatio(0);
    
    label2.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(label1, 10)
    .rightEqualToView(self.view)
    .autoHeightRatio(0);
    
    label3.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(label2, 10)
    .rightEqualToView(self.view)
    .autoHeightRatio(0);
    
    [self setContactInfoViewWithView:label3];

}

#pragma mark - 联系方式视图
-(void)setContactInfoViewWithView:(UILabel *)label
{
    UIView *container = [UIView new];
    container.backgroundColor = UIColorWhite;
    container.layer.cornerRadius = 8;
    [self.view addSubview:container];
    
    UILabel *title = [MyTools labelWithText:@"联系方式" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    [container addSubview:title];
    
    UITextField *infoTextField = [UITextField new];
    infoTextField.placeholder = @"留下邮箱/微信/QQ号，我们尽快回复您~";
    infoTextField.font = UIFontMake(16);
    [container addSubview:infoTextField];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorMakeWithHex(@"#DCDCDC");
    [container addSubview:line];
    
    UIButton *submitBtn = [UIButton new];
    [submitBtn setTitle:@"提交" forState:0];
    [submitBtn setBackgroundColor:UIColorMakeWithHex(@"06BDB3")];
    [submitBtn setTitleColor:UIColorWhite forState:0];
    submitBtn.titleLabel.font = UIFontMake(18);
    submitBtn.layer.cornerRadius = 10;
    [submitBtn addTarget:self action:@selector(submitInfo) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:submitBtn];
    
    UILabel *text = [MyTools labelWithText:@"您也可以直接联系客服" textColor:UIColorBlack textFont:UIFontMake(17) textAlignment:NSTextAlignmentCenter];
    [container addSubview:text];
    
    UILabel *phone = [MyTools labelWithText:@"18117014625" textColor:UIColorBlack textFont:UIFontBoldMake(18) textAlignment:NSTextAlignmentCenter];
    [container addSubview:phone];
    
    UIButton *callBtn = [UIButton new];
    [callBtn setImage:UIImageMake(@"login_icon_call") forState:0];
    [callBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:callBtn];
    
    container.sd_layout
    .leftSpaceToView(self.view, 15)
    .topSpaceToView(label, 20)
    .rightSpaceToView(self.view, 15)
    .heightIs(320);
    
    title.sd_layout
    .leftSpaceToView(container, 25)
    .topSpaceToView(container, 25)
    .widthIs(80)
    .autoHeightRatio(0);
    
    infoTextField.sd_layout
    .leftEqualToView(title)
    .topSpaceToView(title, 20)
    .rightSpaceToView(container, 25)
    .heightIs(35);
    
    line.sd_layout
    .leftEqualToView(infoTextField)
    .rightEqualToView(infoTextField)
    .topSpaceToView(infoTextField, 5)
    .heightIs(0.5);
    
    submitBtn.sd_layout
    .leftSpaceToView(container, 40)
    .rightSpaceToView(container, 40)
    .topSpaceToView(line, 50)
    .heightIs(50);
    
    text.sd_layout
    .leftEqualToView(container)
    .topSpaceToView(submitBtn, 20)
    .rightEqualToView(container)
    .autoHeightRatio(0);
    
    phone.sd_layout
    .topSpaceToView(text, 15)
    .centerXEqualToView(container)
    .widthIs(120)
    .autoHeightRatio(0);
    
    callBtn.sd_layout
    .centerYEqualToView(phone)
    .rightSpaceToView(container, 60)
    .widthIs(50)
    .heightIs(50);
}

#pragma mark - 拨打电话
-(void)call
{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [aAlertController hideWithAnimated:YES];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确认拨打？" message:@"18117014625" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
    
}

#pragma mark - 提交
-(void)submitInfo
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
