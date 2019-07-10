//
//  NoteDetailReplyCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/23.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "NoteDetailReplyCell.h"

@implementation NoteDetailReplyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = BaseBackgroundColor;
        
        [self addSubviews];
    }
    
    return self;
}

-(void)addSubviews
{
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar7.jpg");
    _avatarImageView.layer.cornerRadius = 25;
    _avatarImageView.layer.masksToBounds = YES;
    
    _nameLabel = [MyTools labelWithText:@"花想容" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    
    _timeLabel = [MyTools labelWithText:@"3分钟前" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    
    _topButton = [QMUIButton new];
    [_topButton setBackgroundImage:UIImageMake(@"note_icon_top") forState:0];
    [_topButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _contentLabel = [YYLabel new];
    _contentLabel.numberOfLines = 0;
    
    _commentImageView = [UIImageView new];
    
    _praiseButton = [[QMUIButton alloc] init];
    [_praiseButton setImage:UIImageMake(@"teacher_icon_praise_normal") forState:UIControlStateNormal];
    [_praiseButton setImage:UIImageMake(@"teacher_icon_praise_selected") forState:UIControlStateSelected];
    [_praiseButton setTitle:@"12w" forState:UIControlStateNormal];
    [_praiseButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    _praiseButton.imagePosition = QMUIButtonImagePositionLeft;
    _praiseButton.spacingBetweenImageAndTitle = 5;
    _praiseButton.titleLabel.font = UIFontMake(14);
    [_praiseButton addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _commentButton = [[QMUIButton alloc] init];
    [_commentButton setImage:UIImageMake(@"teacher_icon_comment") forState:UIControlStateNormal];
    [_commentButton setTitle:@"12w" forState:UIControlStateNormal];
    [_commentButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    _commentButton.imagePosition = QMUIButtonImagePositionLeft;
    _commentButton.spacingBetweenImageAndTitle = 5;
    _commentButton.titleLabel.font = UIFontMake(14);
    
    _checkButton = [QMUIButton new];
    [_checkButton setTitle:@"查看原文" forState:0];
    [_checkButton setTitleColor:UIColorMakeWithHex(@"#5FB8A4") forState:0];
    _checkButton.titleLabel.font = UIFontMake(16);
    [_checkButton addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
    
    _line = [UIView new];
    _line.backgroundColor = UIColorGray;
    
    [self.contentView sd_addSubviews:@[_avatarImageView, _nameLabel, _timeLabel, _topButton, _contentLabel, _commentImageView, _praiseButton, _commentButton, _checkButton, _line]];
    
    [self layout];
}

-(void)layout
{
    _avatarImageView.sd_resetLayout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .widthIs(50)
    .heightEqualToWidth();
    
    _nameLabel.sd_resetLayout
    .leftSpaceToView(_avatarImageView, 10)
    .topEqualToView(_avatarImageView)
    .widthIs(150)
    .autoHeightRatio(0);
    
    _timeLabel.sd_resetLayout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel, 5)
    .widthIs(150)
    .autoHeightRatio(0);
    
    _topButton.sd_resetLayout
    .rightSpaceToView(self.contentView, 10)
    .centerYEqualToView(_nameLabel)
    .widthIs(20)
    .heightEqualToWidth();
    
    _praiseButton.sd_layout
    .centerYEqualToView(_topButton)
    .rightSpaceToView(_topButton, 10)
    .widthIs(60)
    .heightIs(20);
    
    _commentButton.sd_layout
    .centerYEqualToView(_topButton)
    .rightSpaceToView(_praiseButton, 15)
    .widthIs(60)
    .heightIs(20);
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_timeLabel, 10)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(50);
    
    _commentImageView.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_contentLabel, 10)
    .widthIs(130)
    .heightIs(90);
    
    _checkButton.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_commentImageView, 10)
    .widthIs(80)
    .heightIs(20);
    
    _line.sd_resetLayout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(_checkButton, 5)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(0.3);
    
    [self setupAutoHeightWithBottomView:_line bottomMargin:0];
    
}

-(void)setModel:(NoteDetailCommentModel *)model
{
    _model = model;
    //名称
    _nameLabel.text = model.nickname;
    //头像
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                        placeholderImage:UIImageMake(@"common_icon_avatar")];
    //时间
    _timeLabel.text = [KyoDateTools prettyDateWithDateString:[MyTools getDateStringWithTimeInterval:model.create_time]];
    //评论数
    [_commentButton setTitle:model.reply_number forState:0];
    //点赞数
    [_praiseButton setTitle:model.live_number forState:0];
    _praiseButton.selected = [model.is_live intValue] == 0 ? NO : YES;
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
    
    _contentLabel.attributedText = attr;
    CGSize size = [attr.string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:UIFontMake(16)}
                                            context:nil].size;
    _contentLabel.sd_layout.heightIs(size.height);
    
    @weakify(self)
    [_contentLabel setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self)
        YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:range.location];
        self.tapContent(highlight.userInfo, [text.string substringWithRange:range]);
    }];
    //图片
    [_commentImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    
    if (model.img.length == 0) {
        _commentImageView.sd_layout.heightIs(0);
    }else{
        _commentImageView.sd_layout.heightIs(90);
    }
}

-(void)checkClick
{
    self.checkBlock();
}

-(void)praiseClick:(QMUIButton *)button
{
    button.selected = !button.selected;
    self.praiseBlock(_model);
}

-(void)menuClick:(QMUIButton *)button
{
    self.menuBlock(_model, button);
}

@end
