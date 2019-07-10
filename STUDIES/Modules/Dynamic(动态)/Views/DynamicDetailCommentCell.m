//
//  DynamicDetailCommentCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicDetailCommentCell.h"
#import <UILabel+YBAttributeTextTapAction.h>

@implementation DynamicDetailCommentCell

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
    _avatarImageView.image = UIImageMake(@"avatar7.jpg");
    _avatarImageView.layer.cornerRadius = 25;
    _avatarImageView.layer.masksToBounds = YES;
    
    _nameLabel = [MyTools labelWithText:@"花想容" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    
    _timeLabel = [MyTools labelWithText:@"3分钟前" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    
    _topButton = [QMUIButton new];
    [_topButton setBackgroundImage:UIImageMake(@"note_icon_top") forState:0];
    
    _downButton = [QMUIButton new];
    [_downButton setBackgroundImage:UIImageMake(@"note_icon_down") forState:0];
    [_downButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _contentLabel = [YYLabel new];
    _contentLabel.numberOfLines = 0;
    
    _commentImageView = [UIImageView new];
    
    _commentButton = [[QMUIButton alloc] init];
    [_commentButton setImage:UIImageMake(@"teacher_icon_comment") forState:UIControlStateNormal];
    [_commentButton setTitle:@"回复" forState:UIControlStateNormal];
    [_commentButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    _commentButton.imagePosition = QMUIButtonImagePositionLeft;
    _commentButton.spacingBetweenImageAndTitle = 5;
    [_commentButton addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    _commentButton.titleLabel.font = UIFontMake(14);
    
    _praiseButton = [[QMUIButton alloc] init];
    [_praiseButton setImage:UIImageMake(@"teacher_icon_praise_normal") forState:UIControlStateNormal];
    [_praiseButton setImage:UIImageMake(@"teacher_icon_praise_selected") forState:UIControlStateSelected];
    [_praiseButton setTitle:@"12w" forState:UIControlStateNormal];
    [_praiseButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
    _praiseButton.imagePosition = QMUIButtonImagePositionLeft;
    _praiseButton.spacingBetweenImageAndTitle = 5;
    _praiseButton.titleLabel.font = UIFontMake(14);
    [_praiseButton addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _replyButton = [QMUIButton new];
    [_replyButton setBackgroundColor:UIColorMakeWithHex(@"#E5E5E5")];
    [_replyButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:0];
    _replyButton.titleLabel.font = UIFontMake(14);
    _replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _replyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_replyButton addTarget:self action:@selector(replyClick) forControlEvents:UIControlEventTouchUpInside];
    
    _line = [UIView new];
    _line.backgroundColor = UIColorGray;
    
    [self.contentView sd_addSubviews:@[_avatarImageView, _nameLabel, _timeLabel, _topButton, _downButton, _contentLabel, _commentImageView, _commentButton, _praiseButton, _replyButton, _line]];
    
    _avatarImageView.sd_resetLayout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .widthIs(50)
    .heightEqualToWidth();
    
    _nameLabel.sd_resetLayout
    .leftSpaceToView(_avatarImageView, 10)
    .topEqualToView(_avatarImageView)
    .rightSpaceToView(self.contentView, 100)
    .autoHeightRatio(0);
    
    _timeLabel.sd_resetLayout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel, 5)
    .widthIs(150)
    .autoHeightRatio(0);
    
    _downButton.sd_resetLayout
    .rightSpaceToView(self.contentView, 20)
    .centerYEqualToView(_avatarImageView)
    .widthIs(20)
    .heightEqualToWidth();
    
    _topButton.sd_resetLayout
    .rightSpaceToView(_topButton, 10)
    .centerYEqualToView(_avatarImageView)
    .widthIs(20)
    .heightEqualToWidth();
    
    _contentLabel.sd_resetLayout
    .leftEqualToView(_avatarImageView)
    .topSpaceToView(_avatarImageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(40);
    
    _commentImageView.sd_resetLayout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 10)
    .widthIs(130)
    .heightIs(90);
    
    _replyButton.sd_resetLayout
    .leftSpaceToView(self.contentView, 30)
    .rightEqualToView(_downButton)
    .topSpaceToView(_commentImageView, 10)
    .heightIs(25);
    
    _commentButton.sd_resetLayout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(_replyButton, 10)
    .widthIs(60)
    .heightIs(20);
    
    _praiseButton.sd_resetLayout
    .leftSpaceToView(_commentButton, 80)
    .centerYEqualToView(_commentButton)
    .widthIs(60)
    .heightIs(20);
    
    _line.sd_resetLayout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(_commentButton, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(0.3);
    
    [self setupAutoHeightWithBottomView:_line bottomMargin:10];
}

-(void)setModel:(DynamicCommentModel *)model
{
    _model = model;
    //名称
    _nameLabel.text = model.user[@"nickname"];
    //时间
    _timeLabel.text = [KyoDateTools prettyDateWithDateString:[MyTools getDateStringWithTimeInterval:model.create_time]];
    //头像
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.user[@"avatar"]] placeholderImage:nil];
    

    NSString *content = [MyTools unicodeToString:model.content];
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:@{NSFontAttributeName: UIFontMake(16)} range:NSMakeRange(0, attr.string.length)];
    
    
    
    // 将html字符串转为NSData
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
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
    
    @weakify(self)
    [_contentLabel setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self)
        YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:range.location];
        self.tapContent(highlight.userInfo, [text.string substringWithRange:range]);
    }];
    
    //图片
    if (model.content_images.length > 0) {
        _commentImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [_commentImageView addGestureRecognizer:tgr];
        [_commentImageView sd_setImageWithURL:[NSURL URLWithString:model.content_images] placeholderImage:nil];
        _commentImageView.sd_layout.heightIs(90);
        _replyButton.sd_layout.topSpaceToView(_commentImageView, 10);
    }else{
        _commentImageView.sd_layout.heightIs(0);
        _replyButton.sd_layout.topSpaceToView(_contentLabel, 10);
    }
    //回复
    if ([model.reply[@"count"] intValue] == 0) {
        _replyButton.sd_layout.heightIs(0);
        _commentButton.sd_layout.topSpaceToView(_commentImageView, 10);
    }else{
        [_replyButton setTitle:[NSString stringWithFormat:@"%@等人共%@条回复", model.reply[@"nickname"], model.reply[@"count"]] forState:0];
        _replyButton.sd_layout.heightIs(25);
        _commentButton.sd_layout.topSpaceToView(_replyButton, 5);
    }
    //点赞
    [_praiseButton setTitle:model.likes forState:0];
    _praiseButton.selected = [model.is_like intValue] == 0 ? NO : YES;
    
}

-(void)replyClick
{
    self.replyBlock(self.model);
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

-(void)commentClick
{
    self.commentBlock(_model);
}

-(void)tapImage:(UITapGestureRecognizer *)tgr
{
    self.tapImageBlock(@[_model.content_images], 0);
}

@end
