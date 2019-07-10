//
//  MineFeedbackViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineFeedbackViewController.h"

@interface MineFeedbackViewController ()

@end

@implementation MineFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"帮助与反馈";
    
    QMUIButton *callButton = [QMUIButton new];
    [callButton setTitle:@"联系客服" forState:0];
    [callButton setTitleColor:UIColorWhite forState:0];
    callButton.titleLabel.font = UIFontMake(18);
    [self.navView addSubview:callButton];
    
    callButton.sd_layout
    .rightSpaceToView(self.navView, 15)
    .centerYEqualToView(self.navView)
    .widthIs(80)
    .heightIs(30);
    
    
    QMUILabel *label = [MyTools labelWithText:@"留下你的意见，帮助我们变得更好" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentCenter];
    label.frame = CGRectMake(0, BaseStatusViewHeight + BaseNavViewHeight + 20, SCREEN_WIDTH, 30);
    [self.view addSubview:label];
    
    QMUITextView *textView = [[QMUITextView alloc] initWithFrame:CGRectMake(10, label.bottom + 10, SCREEN_WIDTH - 20, 120)];
    textView.placeholder = @"请输入您的反馈l内容";
    textView.font = UIFontMake(17);
    textView.layer.borderColor = UIColorGray.CGColor;
    textView.layer.borderWidth = 0.5;
    textView.layer.cornerRadius = 5;
    textView.backgroundColor = UIColorMakeWithHex(@"#E5E5E5");
    [self.view addSubview:textView];
    
    QMUIButton *submitButton = [QMUIButton new];
    submitButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 75, textView.bottom + 50, 150, 50);
    [submitButton setTitle:@"提交" forState:0];
    [submitButton setTitleColor:UIColorWhite forState:0];
    [submitButton setBackgroundColor:UIColorMakeWithHex(@"#04BCB2")];
    submitButton.layer.cornerRadius = 3;
    submitButton.titleLabel.font = UIFontMake(18);
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

-(void)submitClick
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
