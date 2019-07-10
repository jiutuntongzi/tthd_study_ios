//
//  DynamicContentCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicContentCell.h"
#import <UILabel+YBAttributeTextTapAction.h>
#import "TFHpple.h"
#import "NoteDetailModel.h"
@implementation DynamicContentCell

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
    _avatarImageView.image = UIImageMake(@"avatar9.jpg");
    _avatarImageView.layer.cornerRadius = 22.5;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [MyTools labelWithText:@"花想容" textColor:UIColorBlack textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _tagButton = [QMUIButton new];
    [_tagButton setBackgroundImage:UIImageMake(@"teacher_icon_identifier_empty") forState:UIControlStateNormal];
    [self.contentView addSubview:_tagButton];
    
    _followButton = [QMUIButton new];
    [_followButton setBackgroundImage:UIImageMake(@"note_icon_follow_add") forState:0];
    [_followButton setBackgroundImage:UIImageMake(@"note_icon_follow_remove") forState:UIControlStateSelected];
    [_followButton setTitle:@"+关注" forState:0];
    _followButton.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [_followButton setTitleColor:UIColorMakeWithHex(@"#333333") forState:0];
    _followButton.titleLabel.font = UIFontMake(14);
    [_followButton addTarget:self action:@selector(followClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_followButton];
    
    _timeLabel = [MyTools labelWithText:@"3分钟前" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_timeLabel];
    
    _contentLabel = [YYLabel new];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    _container = [UIView new];
    [self.contentView addSubview:_container];

    _videoImageView = [UIImageView new];
    _videoImageView.backgroundColor = UIColorBlack;
    _videoImageView.contentMode = UIViewContentModeScaleAspectFit;
    _videoImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_videoImageView];
    
    QMUIButton *playButton = [QMUIButton new];
    [playButton setImage:UIImageMake(@"dynamic_icon_play") forState:0];
    [playButton addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    [_videoImageView addSubview:playButton];
    
    _noteButton = [QMUIButton new];
    [_noteButton setBackgroundColor:UIColorMakeWithHex(@"#FCF8F8")];
    [_noteButton addTarget:self action:@selector(noteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_noteButton];
    
    _noteImageView = [UIImageView new];
    [_noteButton addSubview:_noteImageView];
    
    _noteTitle = [MyTools labelWithText:@"标题"
                              textColor:UIColorBlack
                               textFont:UIFontMake(17)
                          textAlignment:NSTextAlignmentLeft];
    [_noteButton addSubview:_noteTitle];
    
    _noteContentLabel = [MyTools labelWithText:@"内容"
                                     textColor:UIColorMakeWithHex(@"#666666")
                                      textFont:UIFontMake(15)
                                 textAlignment:NSTextAlignmentLeft];
    [_noteButton addSubview:_noteContentLabel];
    
    
    _icon = [UIImageView new];
    _icon.image = UIImageMake(@"track_icon_location_green");
    [self.contentView addSubview:_icon];
    
    _location = [QMUIButton new];
    [_location setTitle:@"长沙市开福区政府" forState:UIControlStateNormal];
    [_location setTitleColor:UIColorMakeWithHex(@"#91CEC0") forState:UIControlStateNormal];
    _location.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _location.titleLabel.font = UIFontMake(13);
    [self.contentView addSubview:_location];
    
    _commentsButton= [[QMUIButton alloc] init];
    [_commentsButton setImage:UIImageMake(@"teacher_icon_comment") forState:UIControlStateNormal];
    [_commentsButton setTitle:@"12w" forState:UIControlStateNormal];
    [_commentsButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    _commentsButton.imagePosition = QMUIButtonImagePositionLeft;
    _commentsButton.spacingBetweenImageAndTitle = 5;
    _commentsButton.titleLabel.font = UIFontMake(14);
    [self.contentView addSubview:_commentsButton];
    
    _praiseButton = [[QMUIButton alloc] init];
    [_praiseButton setImage:UIImageMake(@"teacher_icon_praise_normal") forState:UIControlStateNormal];
    [_praiseButton setImage:UIImageMake(@"teacher_icon_praise_selected") forState:UIControlStateSelected];
    [_praiseButton setTitle:@"12w" forState:UIControlStateNormal];
    [_praiseButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    _praiseButton.imagePosition = QMUIButtonImagePositionLeft;
    _praiseButton.spacingBetweenImageAndTitle = 5;
    _praiseButton.titleLabel.font = UIFontMake(14);
    [self.contentView addSubview:_praiseButton];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorMakeWithHex(@"#AEAEAE");
    [self.contentView addSubview:line];
    
    _avatarImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(45)
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
    .widthIs(65);
    
    _followButton.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(_avatarImageView)
    .widthIs(100)
    .heightIs(30);
    
    _timeLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel, 5)
    .widthIs(150)
    .autoHeightRatio(0);
    
    _contentLabel.sd_layout
    .leftEqualToView(_avatarImageView)
    .topSpaceToView(_avatarImageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(40);
    
    _container.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 10)
    .rightSpaceToView(self.contentView, 15);
    
    _videoImageView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_contentLabel, 10)
    .heightIs(150);
    
    playButton.sd_layout
    .centerXEqualToView(_videoImageView)
    .centerYEqualToView(_videoImageView)
    .widthIs(50)
    .heightIs(50);
    
    _noteButton.sd_layout
    .leftEqualToView(_avatarImageView)
    .topSpaceToView(_container, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(90);
    
    _noteImageView.sd_layout
    .leftSpaceToView(_noteButton, 5)
    .topSpaceToView(_noteButton, 5)
    .bottomSpaceToView(_noteButton, 5)
    .widthIs(100);
    
    _noteTitle.sd_layout
    .leftSpaceToView(_noteImageView, 10)
    .topEqualToView(_noteImageView)
    .rightSpaceToView(_noteButton, 10)
    .heightIs(25);
    
    _noteContentLabel.sd_layout
    .leftSpaceToView(_noteImageView, 10)
    .bottomEqualToView(_noteImageView)
    .rightSpaceToView(_noteButton, 10)
    .heightIs(50);
    
    _icon.sd_layout
    .leftEqualToView(_avatarImageView)
    .topSpaceToView(_noteButton, 10)
    .widthIs(10)
    .heightIs(15);
    
    _location.sd_layout
    .leftSpaceToView(_icon, 5)
    .centerYEqualToView(_icon)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(20);
    
    _commentsButton.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(_location, 10)
    .widthIs(60)
    .heightIs(20);
    
    _praiseButton.sd_layout
    .leftSpaceToView(_commentsButton, 80)
    .centerYEqualToView(_commentsButton)
    .widthIs(60)
    .heightIs(20);
    
    line.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(_commentsButton, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:0];
}

#pragma mark - 点击关注
-(void)followClick:(QMUIButton *)button
{
    self.followBlock(button, _model);
}

#pragma mark - 点击游记
-(void)noteClick
{
    NoteDetailModel *noteModel = [[NoteDetailModel alloc] initModelWithDict:_model.travel];
    self.noteBlock(noteModel.noteId);
}

#pragma mark - 播放视频
-(void)playClick
{
    self.playVideoBlock(_model.video);
}

-(void)setModel:(DynamicListModel *)model
{
    __weak __typeof (self)weakSelf = self;
    _model = model;
    
    //是否有视频
    if (model.video.length == 0) {
        _videoImageView.hidden = YES;
        _container.hidden = NO;
    }else{
        _videoImageView.hidden = NO;
        [_videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?vframe/jpg/offset/1", model.video]] placeholderImage:nil];
        _container.hidden = YES;
        
        _noteButton.sd_layout
        .leftEqualToView(_avatarImageView)
        .topSpaceToView(_videoImageView, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(90);
    }
    
    //用户信息
    NSDictionary *userDic = model.user;
    [_avatarImageView sd_setImageWithURL:userDic[@"avatar"] placeholderImage:nil];
    _nameLabel.text = userDic[@"nickname"];
    _tagButton.hidden = [userDic[@"is_tutor"] intValue] == 0 ? YES : NO;
    _timeLabel.text = [KyoDateTools prettyDateWithDateString:[MyTools getDateStringWithTimeInterval:model.createtime]];
    
    //内容
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:@{NSFontAttributeName: UIFontMake(16)} range:NSMakeRange(0, attr.string.length)];
    // 将html字符串转为NSData
    NSData *data = [model.content dataUsingEncoding:NSUTF8StringEncoding];
    // 创建Hpple对象
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    // 搜索XPath寻找标签
    NSArray *userElements  = [xpathParser searchWithXPathQuery:@"//user"];
    NSArray *topicElements  = [xpathParser searchWithXPathQuery:@"//tag"];
    NSArray *noteElements  = [xpathParser searchWithXPathQuery:@"//travel"];
    
    if (userElements.count > 0) {
        for (TFHppleElement *element in userElements) {
            YYTextHighlight *lawHightLight = [YYTextHighlight new];
            lawHightLight.userInfo = element.attributes;

            [attr enumerateAttributesInRange:NSMakeRange(0, attr.string.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                [attr setAttribute:NSForegroundColorAttributeName value:BaseNavBarColor range:[attr.string rangeOfString:[element content]]];
                [attr setTextHighlight:lawHightLight range:[attr.string rangeOfString:[element content]]];
            }];
        }
    }
    if (topicElements.count > 0) {
        for (TFHppleElement *element in topicElements) {
            YYTextHighlight *lawHightLight = [YYTextHighlight new];
            lawHightLight.userInfo = element.attributes;
            [attr setAttribute:NSForegroundColorAttributeName value:BaseNavBarColor range:[attr.string rangeOfString:[element content]]];
            [attr setTextHighlight:lawHightLight range:[attr.string rangeOfString:[element content]]];
        }
    }
    if (noteElements.count > 0) {
        for (TFHppleElement *element in noteElements) {
            YYTextHighlight *lawHightLight = [YYTextHighlight new];
            lawHightLight.userInfo = element.attributes;
            [attr setAttribute:NSForegroundColorAttributeName value:BaseNavBarColor range:[attr.string rangeOfString:[element content]]];
            [attr setTextHighlight:lawHightLight range:[attr.string rangeOfString:[element content]]];
        }
    }
    [_contentLabel setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {

        YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:range.location];
        weakSelf.tapContent(highlight.userInfo, [text.string substringWithRange:range]);
    }];
    
    _contentLabel.attributedText = attr;
    
    CGSize size = [attr.string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:UIFontMake(16)}
                                          context:nil].size;
    _contentLabel.sd_layout.heightIs(size.height);

    //图片
    if (model.images.length > 0) {
        NSMutableArray *temp = [NSMutableArray new];
        NSArray *array = [model.images componentsSeparatedByString:@","];
        for (int i = 0; i < array.count; i ++) {
            UIImageView *imageView = [UIImageView new];
            [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:UIImageMake(@"common_icon_placeholderImage")];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [imageView addGestureRecognizer:tgr];
            [_container addSubview:imageView];
            imageView.sd_layout.autoHeightRatio(0.8);
            [temp addObject:imageView];
        }
        
        [_container setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:3 itemWidth:SCREEN_WIDTH / 3.5
                             verticalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
    }else{
        _container.sd_layout.heightIs(0);
    }
    
    //游记
    if ([model.travel isKindOfClass:[NSDictionary class]]) {
        NoteDetailModel *noteModel = [[NoteDetailModel alloc] initModelWithDict:model.travel];
        [_noteImageView sd_setImageWithURL:[NSURL URLWithString:noteModel.imgs.count > 0 ? noteModel.imgs[0] : @""] placeholderImage:UIImageMake(@"common_icon_placeholderImage")];
        _noteTitle.text = noteModel.title;
        _noteContentLabel.text = noteModel.content;
    }else{
        _noteButton.sd_layout.heightIs(0);
        _noteButton.hidden = YES;
    }
    
    [_commentsButton setTitle:model.comments forState:0];
    [_praiseButton setTitle:model.likes forState:0];
    
    //位置
    if (model.position.length == 0) {
        _icon.hidden = YES;
        _location.hidden = YES;
        _icon.sd_layout.heightIs(0);
        _location.sd_layout.heightIs(0);
    }else{
        [_location setTitle:model.position forState:0];
    }
    
    //关注
    BOOL isFollow = [model.is_follow intValue] == 0 ? NO : YES;
    if (isFollow == YES) {
        _followButton.selected = YES;
        [_followButton setTitle:@"取消关注" forState:0];
        [_followButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:0];
    }else{
        _followButton.selected = NO;
        [_followButton setTitle:@"+关注" forState:0];
        [_followButton setTitleColor:UIColorMakeWithHex(@"#333333") forState:0];
    }
}

-(void)tapImage:(UITapGestureRecognizer *)tgr
{
    UIImageView *imageView = (UIImageView *)tgr.view;
    self.tapImageBlock([_model.images componentsSeparatedByString:@","], imageView.tag);
}

@end
