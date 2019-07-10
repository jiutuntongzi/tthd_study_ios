//
//  HomeTeacherContentCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/19.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeTeacherContentCell.h"
@implementation HomeTeacherContentCell

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
    
    _femaleImageView = [UIImageView new];
    _femaleImageView.image = UIImageMake(@"teacher_icon_women");
    [self.contentView addSubview:_femaleImageView];
    
    _starView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    _starView.maximumValue = 5;
    _starView.minimumValue = 0;
    _starView.userInteractionEnabled = NO;
    _starView.value = 3.5;
    _starView.tintColor = [UIColor redColor];
    _starView.allowsHalfStars = YES;
    _starView.filledStarImage = UIImageMake(@"home_icon_star_fill");
    _starView.emptyStarImage = UIImageMake(@"home_icon_star_empty");
    _starView.halfStarImage = UIImageMake(@"home_icon_star_half");
    [self.contentView addSubview:_starView];
    
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
    
    _femaleImageView.sd_layout
    .centerYEqualToView(_nameLabel)
    .leftSpaceToView(_nameLabel, 15)
    .widthIs(15)
    .heightEqualToWidth();
    
    _starView.sd_layout
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

-(void)setModel:(TeacherModel *)model
{
    _model = model;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                        placeholderImage:UIImageMake(@"common_icon_avatar")];
    _nameLabel.text = model.nickname;
    _femaleImageView.hidden = [model.sex intValue] == 0 ? YES : NO;
    _femaleImageView.image = [model.sex intValue] == 1 ? UIImageMake(@"teacher_icon_man") : UIImageMake(@"teacher_icon_women");
    _starView.value = [model.star intValue];
    _desLabel.text = model.bio;
    _followButton.selected = [model.is_follow intValue] == 0 ? NO : YES;
    if (_followButton.selected == YES) {
        [_followButton setBackgroundColor:UIColorWhite];
        _followButton.layer.borderColor = UIColorMakeWithHex(@"#666666").CGColor;
        _followButton.layer.borderWidth = 1;
    }else{
        [_followButton setBackgroundColor:UIColorMakeWithHex(@"#34BCB4")];
        _followButton.layer.borderColor = UIColorClear.CGColor;
    }
    _followButton.hidden = model.is_follow == nil ? YES : NO;
}

@end
