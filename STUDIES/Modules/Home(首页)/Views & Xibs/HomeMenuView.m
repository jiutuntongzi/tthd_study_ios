//
//  HomeMenuView.m
//  STUDIES
//
//  Created by happyi on 2019/4/22.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeMenuView.h"

@implementation HomeMenuView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setButtons];
    }
    
    return self;
}

-(void)setButtons
{
    QMUIButton *submitBtn = [QMUIButton new];
    [submitBtn setBackgroundImage:UIImageMake(@"home_iocn_border") forState:UIControlStateNormal];
    [submitBtn setImage:UIImageMake(@"home_icon_submit") forState:UIControlStateNormal];
    [submitBtn setTitle:@"发布动态" forState:UIControlStateNormal];
    [submitBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.imagePosition = QMUIButtonImagePositionLeft;
    submitBtn.spacingBetweenImageAndTitle = 5;
    submitBtn.titleLabel.font = UIFontMake(16);
    [submitBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 10, 0, 0)];
    [submitBtn setImageEdgeInsets:UIEdgeInsetsMake(7, -10, 0, 0)];
    submitBtn.tag = 10001;
    [self addSubview:submitBtn];
    
    QMUIButton *noteBtn = [QMUIButton new];
    [noteBtn setBackgroundColor:UIColorWhite];
    [noteBtn setImage:UIImageMake(@"home_icon_note") forState:UIControlStateNormal];
    [noteBtn setTitle:@"发布游记" forState:UIControlStateNormal];
    [noteBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
    [noteBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    noteBtn.imagePosition = QMUIButtonImagePositionLeft;
    noteBtn.spacingBetweenImageAndTitle = 5;
    noteBtn.titleLabel.font = UIFontMake(16);
    [noteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [noteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    noteBtn.layer.cornerRadius = 21;
    noteBtn.tag = 10002;
    [self addSubview:noteBtn];
    
//    QMUIButton *recruitBtn = [QMUIButton new];
//    [recruitBtn setBackgroundColor:UIColorWhite];
//    [recruitBtn setImage:UIImageMake(@"home_icon_recruit") forState:UIControlStateNormal];
//    [recruitBtn setTitle:@"招募导师" forState:UIControlStateNormal];
//    [recruitBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
//    [recruitBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//    recruitBtn.imagePosition = QMUIButtonImagePositionLeft;
//    recruitBtn.spacingBetweenImageAndTitle = 5;
//    recruitBtn.titleLabel.font = UIFontMake(16);
//    [recruitBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//    [recruitBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    recruitBtn.layer.cornerRadius = 21;
//    recruitBtn.tag = 10003;
//    [self addSubview:recruitBtn];
    
    submitBtn.sd_layout
    .topEqualToView(self)
    .rightEqualToView(self)
    .widthIs(140)
    .heightIs(55);
    
    noteBtn.sd_layout
    .leftEqualToView(submitBtn)
    .topSpaceToView(submitBtn, 5)
    .rightEqualToView(submitBtn)
    .heightIs(41);
    
//    recruitBtn.sd_layout
//    .leftEqualToView(noteBtn)
//    .topSpaceToView(noteBtn, 5)
//    .rightEqualToView(noteBtn)
//    .heightIs(41);
}

#pragma mark - 按钮点击事件
-(void)clickBtn:(QMUIButton *)sender
{
    if ([self respondsToSelector:@selector(clickBtn:)]) {
        NSInteger index = 0;
        if (sender.tag == 10001) {
            index = Index_Submit;
        }
        if (sender.tag == 10002) {
            index = Index_Note;
        }
        if (sender.tag == 10003) {
            index = Index_Recruit;
        }
        self.menuBlock(index);
    }
}

@end
