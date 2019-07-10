//
//  ThirdLoginView.m
//  STUDIES
//
//  Created by happyi on 2019/4/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "ThirdLoginView.h"

@implementation ThirdLoginView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    
    return self;
}

#pragma mark - 子视图
-(void)setSubViews
{
    UILabel *label = [MyTools labelWithText:@"第三方登录" textColor:UIColorWhite textFont:UIFontMake(18) textAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
    
    UIImageView *leftImageView = [UIImageView new];
    leftImageView.image = UIImageMake(@"login_line_left");
    [self addSubview:leftImageView];
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageMake(@"login_line_right");
    [self addSubview:rightImageView];
    
    UIButton *sinaButton = [UIButton new];
    [sinaButton setImage:UIImageMake(@"login_icon_sina") forState:0];
    [sinaButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    sinaButton.tag = 10001;
    [self addSubview:sinaButton];
    
    UIButton *wechatButton = [UIButton new];
    [wechatButton setImage:UIImageMake(@"login_icon_wechat") forState:0];
    [wechatButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    wechatButton.tag = 10002;
    [self addSubview:wechatButton];
    
    UIButton *qqButton = [UIButton new];
    [qqButton setImage:UIImageMake(@"login_icon_qq") forState:0];
    [qqButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    qqButton.tag = 10003;
    [self addSubview:qqButton];
    
    label.sd_layout
    .topSpaceToView(self, 0)
    .centerXEqualToView(self)
    .heightIs(25)
    .widthIs(100);
    
    leftImageView.sd_layout
    .leftSpaceToView(self, 10)
    .centerYEqualToView(label)
    .rightSpaceToView(label, 10)
    .heightIs(2);
    
    rightImageView.sd_layout
    .leftSpaceToView(label, 10)
    .centerYEqualToView(label)
    .rightSpaceToView(self, 10)
    .heightIs(2);
    
    sinaButton.sd_layout
    .centerXEqualToView(label)
    .topSpaceToView(label, 30)
    .widthIs(80)
    .heightEqualToWidth();
    
    wechatButton.sd_layout
    .rightSpaceToView(sinaButton, 30)
    .topEqualToView(sinaButton)
    .widthIs(80)
    .heightEqualToWidth();
    
    qqButton.sd_layout
    .leftSpaceToView(sinaButton, 30)
    .topEqualToView(sinaButton)
    .widthIs(80)
    .heightEqualToWidth();
}

#pragma mark - Events
-(void)buttonClicked:(UIButton *)button
{
    if ([self respondsToSelector:@selector(buttonClicked:)]) {
        if (button.tag == 10001) {
            self.weiboLoginBlock();
        }
        if (button.tag == 10002) {
            self.wechatLoginBlock();
        }
        if (button.tag == 10003) {
            self.qqLoginBlock();
        }
    }
}
@end
