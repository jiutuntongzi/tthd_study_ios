

//
//  TopicContentCell.m
//  STUDIES
//
//  Created by happyi on 2019/4/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TopicContentCell.h"

@implementation TopicContentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = BaseBackgroundColor;
        
        [self setSubViews];
    }
    
    return self;
}

-(void)setSubViews
{
    UIImageView *hotIcon = [UIImageView new];
    hotIcon.image = UIImageMake(@"topic_icon_hot");
    [self.contentView addSubview:hotIcon];
    
    _titleLabel = [MyTools labelWithText:@"#我是话题的标题#" textColor:UIColorMakeWithHex(@"#91CEC0") textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_titleLabel];
    
    _discussLabel = [MyTools labelWithText:@"120条讨论 >" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(14) textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_discussLabel];
    
    _contentLabel = [MyTools labelWithText:@"我收话题的内容，我可能会有很多很多的文字，但我只会显示两行" textColor:UIColorMakeWithHex(@"#333333") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    _contentLabel.numberOfLines = 2;
    [self.contentView addSubview:_contentLabel];
    
    _coverIamgeView = [UIImageView new];
    _coverIamgeView.image = UIImageMake(@"content4.jpg");
    _coverIamgeView.layer.cornerRadius = 5;
    _coverIamgeView.layer.masksToBounds = YES;
    [self.contentView addSubview:_coverIamgeView];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar5.jpg");
    _avatarImageView.layer.cornerRadius = 15;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [MyTools labelWithText:@"话题发起人" textColor:UIColorMakeWithHex(@"#000000") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [MyTools labelWithText:@"2019-03-30" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(13) textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_timeLabel];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorGray;
    [self.contentView addSubview:line];
    
    hotIcon.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 15)
    .widthIs(40)
    .heightIs(15);
    
    _discussLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(hotIcon)
    .widthIs(100)
    .autoHeightRatio(0);
    
    _titleLabel.sd_layout
    .leftSpaceToView(hotIcon, 15)
    .centerYEqualToView(hotIcon)
    .rightSpaceToView(_discussLabel, 15)
    .heightIs(30);
    
    _coverIamgeView.sd_layout
    .rightEqualToView(_discussLabel)
    .topSpaceToView(_discussLabel, 10)
    .widthIs(120)
    .heightIs(100);
    
    _contentLabel.sd_layout
    .leftEqualToView(hotIcon)
    .topSpaceToView(hotIcon, 10)
    .rightSpaceToView(_coverIamgeView, 10)
    .autoHeightRatio(0);
    
    _avatarImageView.sd_layout
    .leftEqualToView(hotIcon)
    .bottomEqualToView(_coverIamgeView)
    .widthIs(30)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_avatarImageView, 10)
    .centerYEqualToView(_avatarImageView)
    .widthIs(100)
    .autoHeightRatio(0);
    
    _timeLabel.sd_layout
    .rightSpaceToView(_coverIamgeView, 10)
    .centerYEqualToView(_avatarImageView)
    .widthIs(100)
    .autoHeightRatio(0);
    
    line.sd_layout
    .topSpaceToView(_avatarImageView, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:5];
}

-(void)setModel:(TopicListModel *)model
{
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    _discussLabel.text = [NSString stringWithFormat:@"%@条讨论>", model.discuss];
    _contentLabel.text = model.describe;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.user[@"avatar"]]
                        placeholderImage:UIImageMake(@"common_icon_avatar")];
    _nameLabel.text = model.user[@"nickname"];
    _timeLabel.text = [KyoDateTools prettyDateWithDateString:[MyTools getDateStringWithTimeInterval:model.createtime]];
    NSArray *imgs = [model.images componentsSeparatedByString:@","];
    if (imgs.count == 0) {
        return;
    }
    [_coverIamgeView sd_setImageWithURL:[NSURL URLWithString:imgs[0]]
                       placeholderImage:UIImageMake(@"common_icon_placeholderImage")];
}

@end
