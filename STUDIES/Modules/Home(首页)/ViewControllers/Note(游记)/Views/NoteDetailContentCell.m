//
//  NoteDetailImageCell.m
//  STUDIES
//
//  Created by happyi on 2019/4/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteDetailContentCell.h"
#import "KyoDateTools.h"

@implementation NoteDetailContentCell

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

#pragma mark - 子视图
-(void)setSubViews
{
    _topImageView = [UIImageView new];
    _topImageView.image = UIImageMake(@"default6.jpg");
    [self.contentView addSubview:_topImageView];
    
    _titleLabel = [MyTools labelWithText:@"我是游记的标题" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_titleLabel];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar7.jpg");
    _avatarImageView.layer.cornerRadius = 20;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [MyTools labelWithText:@"花想容" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _tagButton = [QMUIButton new];
    [_tagButton setBackgroundImage:UIImageMake(@"teacher_icon_identifier_empty") forState:UIControlStateNormal];
    [self.contentView addSubview:_tagButton];
    
    _timeLabel = [MyTools labelWithText:@"3分钟前" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_timeLabel];
    
    _followButton = [QMUIButton new];
    [_followButton setBackgroundImage:UIImageMake(@"note_icon_follow_add") forState:0];
    [_followButton setBackgroundImage:UIImageMake(@"note_icon_follow_remove") forState:UIControlStateSelected];
    [_followButton setTitle:@"+关注" forState:0];
    _followButton.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [_followButton setTitleColor:UIColorMakeWithHex(@"#333333") forState:0];
    _followButton.titleLabel.font = UIFontMake(15);
    [_followButton addTarget:self action:@selector(followClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_followButton];
    
    UIView *container = [UIView new];
    container.backgroundColor = UIColorMakeWithHex(@"#F4F4F4");
    [self.contentView addSubview:container];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = UIColorMakeWithHex(@"#999999");
    [container addSubview:line1];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = UIColorMakeWithHex(@"#999999");
    [container addSubview:line2];
    
    _commentButton = [[QMUIButton alloc] init];
    [_commentButton setImage:UIImageMake(@"teacher_icon_comment") forState:UIControlStateNormal];
    [_commentButton setTitle:@"180" forState:UIControlStateNormal];
    [_commentButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:UIControlStateNormal];
    _commentButton.imagePosition = QMUIButtonImagePositionLeft;
    _commentButton.spacingBetweenImageAndTitle = 5;
    _commentButton.titleLabel.font = UIFontMake(14);
    [container addSubview:_commentButton];
    
    _praiseButton = [[QMUIButton alloc] init];
    [_praiseButton setImage:UIImageMake(@"teacher_icon_praise_normal") forState:UIControlStateNormal];
    [_praiseButton setTitle:@"180" forState:UIControlStateNormal];
    [_praiseButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:UIControlStateNormal];
    _praiseButton.imagePosition = QMUIButtonImagePositionLeft;
    _praiseButton.spacingBetweenImageAndTitle = 5;
    _praiseButton.titleLabel.font = UIFontMake(14);
    [container addSubview:_praiseButton];
    
    _collectButton = [[QMUIButton alloc] init];
    [_collectButton setImage:UIImageMake(@"note_icon_follow") forState:UIControlStateNormal];
    [_collectButton setTitle:@"12w" forState:UIControlStateNormal];
    [_collectButton setTitleColor:UIColorGray forState:UIControlStateSelected];
    [_collectButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:UIControlStateNormal];
    _collectButton.imagePosition = QMUIButtonImagePositionLeft;
    _collectButton.spacingBetweenImageAndTitle = 5;
    _collectButton.titleLabel.font = UIFontMake(14);
    [container addSubview:_collectButton];
    
    _contentLabel = [MyTools labelWithText:@"雨下好乱\n半個夜晚\n你不在身邊怎麼\n晚安\n天好藍\n要和你一起看\n起风時由你來溫暖\n心事簡單\n一句說完\n要我們永遠不會\n分開\n有眼淚\n也因為你灿烂\n你微笑因為我盛開" textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_contentLabel];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorClear;
    [self.contentView addSubview:line];
    
    _topImageView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(180);
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_topImageView, 15)
    .autoHeightRatio(0);
    
    _avatarImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(_titleLabel, 15)
    .widthIs(40)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_avatarImageView, 10)
    .topEqualToView(_avatarImageView)
    .heightIs(25);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:120];
    
    _tagButton.sd_layout
    .leftSpaceToView(_nameLabel, 10)
    .topEqualToView(_nameLabel)
    .bottomEqualToView(_nameLabel)
    .widthIs(60);
    
    _timeLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel, 5)
    .widthIs(150)
    .autoHeightRatio(0);

    _followButton.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(_avatarImageView)
    .widthIs(80)
    .heightIs(30);
    
    container.sd_layout
    .xIs(10)
    .widthIs(SCREEN_WIDTH - 20)
    .topSpaceToView(_avatarImageView, 10)
    .heightIs(30);
    
    line1.sd_layout
    .xIs(container.width / 3)
    .centerYEqualToView(container)
    .heightIs(20)
    .widthIs(1);
    
    line2.sd_layout
    .leftSpaceToView(container, container.width / 3 * 2)
    .centerYEqualToView(container)
    .heightIs(20)
    .widthIs(1);
    
    _commentButton.sd_layout
    .leftEqualToView(container)
    .rightEqualToView(line1)
    .centerYEqualToView(container)
    .heightIs(30);
    
    _praiseButton.sd_layout
    .leftEqualToView(line1)
    .rightEqualToView(line2)
    .centerYEqualToView(container)
    .heightIs(30);
    
    _collectButton.sd_layout
    .leftEqualToView(line2)
    .rightEqualToView(container)
    .centerYEqualToView(container)
    .heightIs(30);
    
    _contentLabel.sd_layout
    .leftEqualToView(container)
    .rightEqualToView(container)
    .topSpaceToView(container, 15)
    .autoHeightRatio(0);
    
    line.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(_contentLabel, 10)
    .rightEqualToView(self.contentView)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:15];
}

-(void)followClick:(QMUIButton *)sender
{
    if ([self respondsToSelector:@selector(followClick:)]) {
        self.followBlock(sender.titleLabel.text);
    }
}

-(void)setIsFollowed:(BOOL)isFollowed
{
    if (isFollowed) {
        _followButton.selected = YES;
        [_followButton setTitle:@"已关注" forState:0];
        [_followButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:0];
    }else{
        _followButton.selected = NO;
        [_followButton setTitle:@"+关注" forState:0];
        [_followButton setTitleColor:UIColorMakeWithHex(@"#333333") forState:0];
    }
}

-(void)setModel:(NoteDetailModel *)model
{
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:model.imgs.count > 0 ? model.imgs[0] : @""] placeholderImage:UIImageMake(@"common_icon_placeholderImage")];
    
    _titleLabel.text = model.title;
    _nameLabel.text = model.nickname;
    _timeLabel.text = [KyoDateTools prettyDateWithDateString:[MyTools getDateStringWithTimeInterval:model.add_time]];
    _contentLabel.text = model.content;
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:UIImageMake(@"common_icon_avatar")];
    [_commentButton setTitle:model.reply_number forState:0];
    [_praiseButton setTitle:model.live_number forState:0];
    [_collectButton setTitle:model.collect_number forState:0];
    
    _tagButton.hidden = [model.user_type intValue] == 1 ? YES : NO;
    
    if ([model.is_follow intValue] == 1) {
        _followButton.selected = YES;
        [_followButton setTitle:@"已关注" forState:0];
        [_followButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:0];
    }else{
        _followButton.selected = NO;
        [_followButton setTitle:@"+关注" forState:0];
        [_followButton setTitleColor:UIColorMakeWithHex(@"#333333") forState:0];
    }
}

@end
