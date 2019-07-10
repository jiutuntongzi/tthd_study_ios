//
//  HomeUserCell.m
//  STUDIES
//
//  Created by happyi on 2019/6/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeUserCell.h"

@implementation HomeUserCell

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
    
    _nameLabel = [MyTools labelWithText:@"张小花" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _fansLabel = [MyTools labelWithText:@"粉丝：0" textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_fansLabel];
    
    _desLabel = [MyTools labelWithText:@"风趣幽默，经验丰富" textColor:UIColorMakeWithHex(@"#646566") textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_desLabel];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorMakeWithHex(@"#E4E5E6");
    [self.contentView addSubview:line];
    
    _avatarImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(60)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_avatarImageView, 10)
    .topEqualToView(_avatarImageView)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    _fansLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .centerYEqualToView(_avatarImageView)
    .autoHeightRatio(0)
    .widthIs(100);
    
    _desLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .bottomEqualToView(_avatarImageView)
    .rightSpaceToView(self.contentView, 20)
    .autoHeightRatio(0);
        
    line.sd_layout
    .leftEqualToView(_avatarImageView)
    .topSpaceToView(_avatarImageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:0];
}

-(void)setModel:(HomeUserModel *)model
{
    _model = model;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:UIImageMake(@"common_icon_avatar")];
    _nameLabel.text = model.nickname;
//    _tagImageView.hidden = [model.user_type intValue] == 1 ? YES : NO;
//    _fansLabel.text = [NSString stringWithFormat:@"粉丝：%@", model.follow_number];
    _desLabel.text = model.bio;
//    _followButton.selected = [model.is_follow intValue] == 0 ? NO : YES;
}
@end
