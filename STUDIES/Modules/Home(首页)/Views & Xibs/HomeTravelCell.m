//
//  HomeTravelCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/16.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeTravelCell.h"

@implementation HomeTravelCell

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

- (void)prepareForReuse
{
    [super prepareForReuse];
}

-(void)initLayout
{
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar4.jpg");
    _avatarImageView.layer.cornerRadius = 25;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [MyTools labelWithText:@"花想容" textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _siftImageView = [UIImageView new];
    _siftImageView.image = UIImageMake(@"note_icon_handpick");
    [self.contentView addSubview:_siftImageView];
    
    _timeLabel = [MyTools labelWithText:@"2019-03-26" textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(14) textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_timeLabel];
    
    _contentLabel = [MyTools labelWithText:@"云想衣裳花想容，春风拂槛露华浓，若非群玉山头见，会向瑶台月下逢" textColor:UIColorBlack textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    
    _viewButton = [[QMUIButton alloc] init];
    [_viewButton setImage:UIImageMake(@"home_icon_view") forState:UIControlStateNormal];
    [_viewButton setTitle:@"12w" forState:UIControlStateNormal];
    [_viewButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    _viewButton.imagePosition = QMUIButtonImagePositionLeft;
    _viewButton.spacingBetweenImageAndTitle = 5;
    _viewButton.titleLabel.font = UIFontMake(14);
    [self.contentView addSubview:_viewButton];
    
    _commentButton = [[QMUIButton alloc] init];
    [_commentButton setImage:UIImageMake(@"home_icon_comment") forState:UIControlStateNormal];
    [_commentButton setTitle:@"355" forState:UIControlStateNormal];
    [_commentButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    _commentButton.imagePosition = QMUIButtonImagePositionLeft;
    _commentButton.spacingBetweenImageAndTitle = 5;
    _commentButton.titleLabel.font = UIFontMake(14);
    [self.contentView addSubview:_commentButton];
    
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorMakeWithHex(@"#AEAEAE");
    [self.contentView addSubview:line];
    
    _avatarImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .widthIs(50)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_avatarImageView, 10)
    .topEqualToView(_avatarImageView)
    .heightIs(20);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _siftImageView.sd_layout
    .leftSpaceToView(_nameLabel, 5)
    .centerYEqualToView(_nameLabel)
    .widthIs(55)
    .heightIs(20);
    
    _timeLabel.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .bottomEqualToView(_nameLabel)
    .widthIs(100)
    .autoHeightRatio(0);
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel, 5)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    _container.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_contentLabel, 5)
    .rightSpaceToView(self.contentView, 15);
    
    _commentButton.sd_layout
    .rightEqualToView(_timeLabel)
    .topSpaceToView(_container, 20)
    .widthIs(60)
    .heightIs(20);
    
    _viewButton.sd_layout
    .rightSpaceToView(_commentButton, 30)
    .topEqualToView(_commentButton)
    .widthIs(60)
    .heightIs(20);
    
    line.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .topSpaceToView(_viewButton, 10)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:0];
}

-(void)setModel:(NoteListModel *)model
{
    _model = model;
    _nameLabel.text = model.nickname;
    _timeLabel.text = [KyoDateTools prettyDateWithDateString:[MyTools getDateStringWithTimeInterval:model.add_time]];
    _contentLabel.text = model.title;
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                        placeholderImage:UIImageMake(@"common_icon_avatar")];
    [_viewButton setTitle:model.hits forState:0];
    [_commentButton setTitle:model.reply_number forState:0];
    
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < model.imgs.count; i ++) {
        UIImageView *imageView = [UIImageView new];
        [imageView sd_setImageWithURL:model.imgs[i] placeholderImage:UIImageMake(@"commom_icon_placeholderImage")];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageView addGestureRecognizer:tgr];
        [_container addSubview:imageView];
        imageView.sd_layout.autoHeightRatio(0.8);
        [temp addObject:imageView];
    }
    
    [_container setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:3 itemWidth:SCREEN_WIDTH / 4 verticalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
    
    if (model.imgs.count == 0) {
        _container.sd_layout.heightIs(0);
    }
    
    _siftImageView.hidden = [model.sift isEqualToString:@"0"] ? YES : NO;
}

-(void)tapImage:(UITapGestureRecognizer *)tgr
{
    UIImageView *imageView = (UIImageView *)tgr.view;
    self.tapImageBlock(_model.imgs, imageView.tag);
}

@end
