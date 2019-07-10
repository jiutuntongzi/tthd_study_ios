//
//  NoteSearchCell.m
//  STUDIES
//
//  Created by happyi on 2019/4/24.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteSearchCell.h"

@implementation NoteSearchCell

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
    _noteImageView = [UIImageView new];
    _noteImageView.layer.cornerRadius = 5;
    _noteImageView.layer.masksToBounds = YES;
    _noteImageView.image = UIImageMake(@"content7.jpg");
    [self.contentView addSubview:_noteImageView];
    
    _siftLabel = [MyTools labelWithText:@"精选" textColor:UIColorMakeWithHex(@"#DE0606") textFont:UIFontMake(12) textAlignment:NSTextAlignmentCenter];
    _siftLabel.backgroundColor = UIColorMakeWithHex(@"#FFDD4F");
    [_noteImageView addSubview:_siftLabel];
    
    _titleLabel = [MyTools labelWithText:@"我是游记内容标题" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_titleLabel];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar9.jpg");
    _avatarImageView.layer.cornerRadius = 20;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [MyTools labelWithText:@"我是游记发布者" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    UIView *container = [UIView new];
    container.backgroundColor = UIColorMakeWithHex(@"#F4F4F4");
    [self.contentView addSubview:container];

    UIView *line1 = [UIView new];
    line1.backgroundColor = UIColorMakeWithHex(@"#999999");
    [container addSubview:line1];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = UIColorMakeWithHex(@"#999999");
    [container addSubview:line2];
    
    _timeLabel = [MyTools labelWithText:@"发布于2019-03-18" textColor:UIColorMakeWithHex(@"#999999")
                                       textFont:UIFontMake(13) textAlignment:NSTextAlignmentCenter];
    [container addSubview:_timeLabel];
    
    _praiseButton = [[QMUIButton alloc] init];
    [_praiseButton setImage:UIImageMake(@"teacher_icon_praise_normal") forState:UIControlStateNormal];
    [_praiseButton setImage:UIImageMake(@"teacher_icon_praise_selected") forState:UIControlStateSelected];
    [_praiseButton setTitle:@"180" forState:UIControlStateNormal];
    [_praiseButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:UIControlStateNormal];
    _praiseButton.imagePosition = QMUIButtonImagePositionLeft;
    _praiseButton.spacingBetweenImageAndTitle = 5;
    _praiseButton.titleLabel.font = UIFontMake(14);
    [container addSubview:_praiseButton];
    
    _collectButton = [[QMUIButton alloc] init];
    [_collectButton setImage:UIImageMake(@"note_icon_follow") forState:UIControlStateNormal];
    [_collectButton setTitle:@"12w" forState:UIControlStateNormal];
    [_collectButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:UIControlStateNormal];
    _collectButton.imagePosition = QMUIButtonImagePositionLeft;
    _collectButton.spacingBetweenImageAndTitle = 5;
    _collectButton.titleLabel.font = UIFontMake(14);
    [container addSubview:_collectButton];
    
    
    _noteImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .widthIs(SCREEN_WIDTH / 3)
    .heightIs(100);
    
    _siftLabel.sd_layout
    .leftEqualToView(_noteImageView)
    .topEqualToView(_noteImageView)
    .widthIs(40)
    .heightIs(20);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_noteImageView, 10)
    .topEqualToView(_noteImageView)
    .rightSpaceToView(self.contentView, 20)
    .autoHeightRatio(0);
    
    _avatarImageView.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomEqualToView(_noteImageView)
    .heightIs(40)
    .widthIs(40);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_avatarImageView, 10)
    .centerYEqualToView(_avatarImageView)
    .widthIs(120)
    .autoHeightRatio(0);
    
    container.sd_layout
    .xIs(10)
    .widthIs(SCREEN_WIDTH - 20)
    .topSpaceToView(_noteImageView, 10)
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
    
    _timeLabel.sd_layout
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
    
    [self setupAutoHeightWithBottomView:container bottomMargin:15];
}

-(void)setModel:(NoteSearchModel *)model
{
    _siftLabel.hidden   = [model.sift isEqualToString:@"0"] ? YES : NO;
    _titleLabel.text    = model.title;
    _nameLabel.text     = model.nickname;
    _timeLabel.text     = [KyoDateTools prettyDateWithDateString:[MyTools getDateStringWithTimeInterval:model.add_time]];

    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:UIImageMake(@"common_icon_avatar")];
    [_noteImageView sd_setImageWithURL:[NSURL URLWithString:model.imgs.count > 0 ? model.imgs[0] : @""] placeholderImage:UIImageMake(@"common_icon_placeholderImage")];
    [_praiseButton setTitle:model.live_number forState:0];
    [_collectButton setTitle:model.collect_number forState:0];
    _collectButton.selected = [model.is_collect intValue] == 0 ? NO : YES;
}

@end
