//
//  TopicHeaderView.m
//  STUDIES
//
//  Created by happyi on 2019/4/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TopicDetailHeaderView.h"

@implementation TopicDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseNavBarColor;
        [self addSubViews];
    }
    
    return self;
}

-(void)addSubViews
{
    _coverImageView = [UIImageView new];
    _coverImageView.image = UIImageMake(@"content1.jpg");
    _coverImageView.layer.cornerRadius = 5;
    _coverImageView.layer.masksToBounds = YES;
    [self addSubview:_coverImageView];
    
    _titleLabel = [MyTools labelWithText:@"#娱乐圈大地震的话题 关系身边你我他#" textColor:UIColorWhite textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self addSubview:_titleLabel];
    
    _tagImageView = [UIImageView new];
    _tagImageView.image = UIImageMake(@"topic_icon_hot");
    [self addSubview:_tagImageView];
    
    _nameLabel = [MyTools labelWithText:@"发起人：一个小柠檬" textColor:UIColorWhite textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self addSubview:_nameLabel];
    
    _discussLabel = [MyTools labelWithText:@"讨论：12w" textColor:UIColorWhite textFont:UIFontMake(13) textAlignment:NSTextAlignmentLeft];
    [self addSubview:_discussLabel];
    
    _readLabel = [MyTools labelWithText:@"阅读：8888" textColor:UIColorWhite textFont:UIFontMake(13) textAlignment:NSTextAlignmentLeft];
    [self addSubview:_readLabel];
    
    _followButton = [QMUIButton new];
    [_followButton setTitle:@"+关注" forState:0];
    [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_followButton setTitleColor:UIColorBlack forState:0];
    [_followButton setTitleColor:UIColorGray forState:UIControlStateSelected];
    [_followButton setBackgroundColor:UIColorMake(254, 219, 92)];
    _followButton.layer.cornerRadius = 5;
    _followButton.titleLabel.font = UIFontMake(14);
    [_followButton addTarget:self action:@selector(followClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followButton];
    
    _coverImageView.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, 15)
    .widthIs(110)
    .heightEqualToWidth();
    
    _tagImageView.sd_layout
    .topEqualToView(_coverImageView)
    .rightSpaceToView(self, 10)
    .widthIs(50)
    .heightIs(20);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_coverImageView, 10)
    .rightSpaceToView(_tagImageView, 10)
    .topEqualToView(_coverImageView)
    .autoHeightRatio(0);
    
    _discussLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomEqualToView(_coverImageView)
    .widthIs(75)
    .autoHeightRatio(0);
    
    _readLabel.sd_layout
    .leftSpaceToView(_discussLabel, 10)
    .bottomEqualToView(_discussLabel)
    .widthIs(75)
    .autoHeightRatio(0);
    
    _followButton.sd_layout
    .bottomEqualToView(_coverImageView)
    .rightEqualToView(_tagImageView)
    .widthIs(55)
    .heightIs(25);
    
    _nameLabel.sd_layout
    .bottomSpaceToView(_discussLabel, 15)
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .autoHeightRatio(0);
}

-(void)setModel:(TopicListModel *)model
{
    NSArray *imgs = [model.images componentsSeparatedByString:@","];
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:imgs.count > 0 ? imgs[0] : @""]
                       placeholderImage:UIImageMake(@"common_icon_placeholderImage")];
    _titleLabel.text = model.title;
    _tagImageView.hidden = [model.is_hot intValue] == 0 ? YES : NO;
    _discussLabel.text = [NSString stringWithFormat:@"讨论：%@", model.discuss];
    _readLabel.text = [NSString stringWithFormat:@"阅读：%@", model.clicks];
    _nameLabel.text = [NSString stringWithFormat:@"发起人：%@", model.user[@"nickname"]];
}

-(void)setDetailModel:(TopicDetailModel *)detailModel
{
    _detailModel = detailModel;
    NSArray *imgs = [detailModel.images componentsSeparatedByString:@","];
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:imgs.count > 0 ? imgs[0] : @""]
                       placeholderImage:UIImageMake(@"common_icon_placeholderImage")];
    _titleLabel.text = detailModel.title;
    _tagImageView.hidden = [detailModel.is_hot intValue] == 0 ? YES : NO;
    _discussLabel.text = [NSString stringWithFormat:@"讨论：%@", detailModel.discuss];
    _readLabel.text = [NSString stringWithFormat:@"阅读：%@", detailModel.clicks];
    _nameLabel.text = [NSString stringWithFormat:@"发起人：%@", detailModel.user[@"nickname"]];
    _followButton.selected = [detailModel.follow intValue] == 0 ? NO : YES;
}

-(void)followClick:(QMUIButton *)button
{
    button.selected = !button.selected;
    self.followTopicBlock(_detailModel);
}

@end
