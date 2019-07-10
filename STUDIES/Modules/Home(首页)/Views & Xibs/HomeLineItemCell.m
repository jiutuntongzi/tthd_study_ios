//
//  HomeLineItemCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeLineItemCell.h"

@implementation HomeLineItemCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BaseBackgroundColor;
        
        [self initLayout];
    }
    
    return self;
}

-(void)initLayout
{
    _coverImageView = [UIImageView new];
    _coverImageView.image = UIImageMake(@"content2.jpg");
    _coverImageView.layer.cornerRadius = 6;
    _coverImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_coverImageView];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar3.jpg");
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.layer.cornerRadius = 25;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _titleLabel = [MyTools labelWithText:@"研学路线第一条进行时" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    
    _coverImageView.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 5)
    .heightIs(120);
    
    _avatarImageView.sd_layout
    .leftEqualToView(_coverImageView)
    .topSpaceToView(_coverImageView, 5)
    .widthIs(50)
    .heightEqualToWidth();
    
    _titleLabel.sd_layout
    .topEqualToView(_avatarImageView)
    .leftSpaceToView(_avatarImageView, 5)
    .rightEqualToView(_coverImageView)
    .bottomEqualToView(_avatarImageView);
    
}

-(void)setModel:(HomePathModel *)model
{
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_img]
                       placeholderImage:UIImageMake(@"commom_icon_placeholderImage")];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                        placeholderImage:UIImageMake(@"common_icon_avatar")];
    _titleLabel.text = model.title;
}

@end
