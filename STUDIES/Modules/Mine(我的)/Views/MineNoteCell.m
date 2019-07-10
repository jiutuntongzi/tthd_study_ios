//
//  MineNoteCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineNoteCell.h"

@implementation MineNoteCell

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
    _coverImageView = [UIImageView new];
    _coverImageView.layer.cornerRadius = 5;
    _coverImageView.layer.masksToBounds = YES;
    _coverImageView.image = UIImageMake(@"content7.jpg");
    [self.contentView addSubview:_coverImageView];
    
    _titleLabel = [MyTools labelWithText:@"我是游记的标题" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [MyTools labelWithText:@"2019-05-17" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(13) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_timeLabel];
    
    _praiseButton = [[QMUIButton alloc] init];
    [_praiseButton setImage:UIImageMake(@"teacher_icon_praise_normal") forState:UIControlStateNormal];
    [_praiseButton setTitle:@"180" forState:UIControlStateNormal];
    [_praiseButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:UIControlStateNormal];
    _praiseButton.imagePosition = QMUIButtonImagePositionLeft;
    _praiseButton.spacingBetweenImageAndTitle = 5;
    _praiseButton.titleLabel.font = UIFontMake(13);
    [self.contentView addSubview:_praiseButton];
    
    _collectButton = [[QMUIButton alloc] init];
    [_collectButton setImage:UIImageMake(@"note_icon_follow") forState:UIControlStateNormal];
    [_collectButton setTitle:@"12w" forState:UIControlStateNormal];
    [_collectButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:UIControlStateNormal];
    _collectButton.imagePosition = QMUIButtonImagePositionLeft;
    _collectButton.spacingBetweenImageAndTitle = 5;
    _collectButton.titleLabel.font = UIFontMake(13);
    [self.contentView addSubview:_collectButton];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorGray;
    [self.contentView addSubview:line];
    
    _coverImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .widthIs(SCREEN_WIDTH /3)
    .heightIs(100);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_coverImageView, 10)
    .topEqualToView(_coverImageView)
    .rightSpaceToView(self.contentView, 20)
    .autoHeightRatio(0);
    
    _timeLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomEqualToView(_coverImageView)
    .heightIs(20)
    .widthIs(80);
    
    _collectButton.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .centerYEqualToView(_timeLabel)
    .heightIs(20)
    .widthIs(70);
    
    line.sd_layout
    .rightSpaceToView(_collectButton, 10)
    .heightIs(20)
    .widthIs(0.5)
    .centerYEqualToView(_timeLabel);
    
    _praiseButton.sd_layout
    .rightSpaceToView(line, 10)
    .centerYEqualToView(_timeLabel)
    .heightIs(20)
    .widthIs(70);
    
    [self setupAutoHeightWithBottomView:_coverImageView bottomMargin:15];
}

-(void)setModel:(NoteSearchModel *)model
{
    _titleLabel.text    = model.title;
    _timeLabel.text     = [KyoDateTools prettyDateWithDateString:[MyTools getDateStringWithTimeInterval:model.add_time]];
    if (model.imgs.count > 0) {
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.imgs[0]] placeholderImage:UIImageMake(@"common_icon_placeholderImage")];
    }
    [_praiseButton setTitle:model.live_number forState:0];
    [_collectButton setTitle:model.collect_number forState:0];
}

@end
