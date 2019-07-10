//
//  BaseViewController.m
//  STUDIES
//
//  Created by happyi on 2019/3/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - lazy
-(UIView *)statusView
{
    if (!_statusView) {
        _statusView = [UIView new];
        _statusView.backgroundColor = BaseStatusBarColor;
    }
    
    return _statusView;
}

-(UIView *)navView
{
    if (!_navView) {
        _navView = [UIView new];
        _navView.backgroundColor = BaseNavBarColor;
        _navView.userInteractionEnabled = YES;
    }
    
    return _navView;
}

-(QMUILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [MyTools labelWithText:@"" textColor:UIColorWhite textFont:UIFontMake(22) textAlignment:NSTextAlignmentCenter];
    }
    
    return _titleLabel;
}

-(QMUIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [QMUIButton new];
        [_leftButton setImage:nil  forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setImage:UIImageMake(@"base_icon_back") forState:0];
        [_leftButton setTitleColor:UIColorWhite forState:0];
        _leftButton.titleLabel.font = UIFontMake(18);
        _leftButton.hidden = NO;
    }
    
    return _leftButton;
}

-(QMUIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [QMUIButton new];
        [_rightButton setImage:nil  forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColorWhite forState:0];
        _rightButton.titleLabel.font = UIFontMake(18);
        _rightButton.hidden = NO;
    }
    
    return _rightButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BaseBackgroundColor;
    
    [self.view addSubview:self.statusView];
    [self.view addSubview:self.navView];
    [_navView addSubview:self.titleLabel];
    [_navView addSubview:self.leftButton];
    [_navView addSubview:self.rightButton];
}

-(void)viewDidLayoutSubviews
{
    _statusView.frame   = CGRectMake(0, 0, SCREEN_WIDTH, BaseStatusViewHeight);
    _navView.frame      = CGRectMake(0, BaseStatusViewHeight, SCREEN_WIDTH, BaseNavViewHeight);
    _titleLabel.frame   = CGRectMake(SCREEN_WIDTH / 2 - 80, BaseNavViewHeight / 2 - 15, 160, 30);
    _leftButton.frame   = CGRectMake(0, BaseNavViewHeight / 2 - 22, 44, 44);
    _rightButton.frame  = CGRectMake(SCREEN_WIDTH - 60, BaseNavViewHeight / 2 - 15, 60, 30);
}

#pragma mark - 左边按钮统一做返回上一页面处理
-(void)leftBtnClick:(QMUIButton *)button
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
