//
//  LineSearchCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineSearchCell.h"

@implementation LineSearchCell

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
    _imageView = [UIImageView new];
    _imageView.image = UIImageMake(@"content2.jpg");
    _imageView.layer.cornerRadius = 6;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    _titleLabel = [MyTools labelWithText:@"山映斜阳天接水，芳草无情，更在夕阳外" textColor:UIColorBlack textFont:UIFontMake(17) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_titleLabel];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar3.jpg");
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.layer.cornerRadius = 22.5;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [MyTools labelWithText:@"研学路线第一条进行时" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    _nameLabel.numberOfLines = 2;
    [self.contentView addSubview:_nameLabel];
    
    
    _imageView.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 10)
    .widthIs(SCREEN_WIDTH /3)
    .heightIs(100);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_imageView, 10)
    .topEqualToView(_imageView)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    
    _avatarImageView.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomEqualToView(_imageView)
    .widthIs(45)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .centerYEqualToView(_avatarImageView)
    .leftSpaceToView(_avatarImageView, 5)
    .rightEqualToView(_titleLabel)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_imageView bottomMargin:10];
}

-(void)setModel:(LineThemeItemModel *)model
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:nil];
    _titleLabel.text = model.title;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    _nameLabel.text = model.nickname;
}

@end
