//
//  TeacherFansOrFollowsCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherFansOrFollowsCell.h"

@implementation TeacherFansOrFollowsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = BaseBackgroundColor;
        
        [self initLayout];
    }
    
    return self;
}

-(void)initLayout
{
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar5.jpg");
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [MyTools labelWithText:@"张小花" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _tagImageView = [UIImageView new];
    _tagImageView.image = UIImageMake(@"teacher_icon_identifier_fill");
    [self.contentView addSubview:_tagImageView];
    
    _fansLabel = [MyTools labelWithText:@"粉丝：122" textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_fansLabel];
    
    _desLabel = [MyTools labelWithText:@"风趣幽默，经验丰富" textColor:UIColorMakeWithHex(@"#646566") textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_desLabel];
    
    _followButton = [QMUIButton new];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_followButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
    [_followButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateSelected];
    [_followButton setBackgroundColor:UIColorMakeWithHex(@"#34BCB4")];
    _followButton.layer.cornerRadius = 7;
    [_followButton addTarget:self action:@selector(followClick:) forControlEvents:UIControlEventTouchUpInside];
    _followButton.titleLabel.font = UIFontMake(15);
    [self.contentView addSubview:_followButton];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorMakeWithHex(@"#E4E5E6");
    [self.contentView addSubview:line];
    
    _avatarImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(70)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_avatarImageView, 10)
    .topEqualToView(_avatarImageView)
    .heightIs(25);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _tagImageView.sd_layout
    .centerYEqualToView(_nameLabel)
    .leftSpaceToView(_nameLabel, 15)
    .widthIs(60)
    .heightIs(20);
    
    _fansLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .centerYEqualToView(self.contentView)
    .heightIs(25)
    .widthIs(100);
    
    _desLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .bottomEqualToView(_avatarImageView)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(20);
    
    _followButton.sd_layout
    .topEqualToView(_avatarImageView)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(28)
    .widthIs(65);
    
    line.sd_layout
    .leftEqualToView(_avatarImageView)
    .topSpaceToView(_avatarImageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:0];
}

-(void)followClick:(QMUIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        [button setBackgroundColor:UIColorWhite];
        button.layer.borderColor = UIColorMakeWithHex(@"#666666").CGColor;
        button.layer.borderWidth = 1;
    }else{
        [button setBackgroundColor:UIColorMakeWithHex(@"#34BCB4")];
        button.layer.borderColor = UIColorClear.CGColor;
    }
    
    self.followBlock(_model);
}

-(void)setModel:(TeacherFansOrFollowsModel *)model
{
    _model = model;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:UIImageMake(@"common_icon_avatar")];
    _nameLabel.text = model.nickname;
    _tagImageView.hidden = [model.user_type intValue] == 1 ? YES : NO;
    _fansLabel.text = [NSString stringWithFormat:@"粉丝：%@", model.follow_number];
    _desLabel.text = model.bio;
    _followButton.selected = [model.is_follow intValue] == 0 ? NO : YES;
    if (_followButton.selected) {
        [_followButton setBackgroundColor:UIColorWhite];
        _followButton.layer.borderColor = UIColorMakeWithHex(@"#666666").CGColor;
        _followButton.layer.borderWidth = 1;
    }else{
        [_followButton setBackgroundColor:UIColorMakeWithHex(@"#34BCB4")];
        _followButton.layer.borderColor = UIColorClear.CGColor;
    }
}

@end
