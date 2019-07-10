//
//  DynamicDetailHeaderView.m
//  STUDIES
//
//  Created by happyi on 2019/5/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicDetailHeaderView.h"
#import <UILabel+YBAttributeTextTapAction.h>
#import "TFHpple.h"
#import "NoteDetailModel.h"
@implementation DynamicDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        [self addSubViews];
    }
    
    return self;
}

-(void)addSubViews
{
    //头像
    _avatarImageView = [UIImageView new];
    _avatarImageView.layer.cornerRadius = 22.5;
    _avatarImageView.layer.masksToBounds = YES;
    [self addSubview:_avatarImageView];
    
    //名称
    _nameLabel = [MyTools labelWithText:@""
                              textColor:UIColorBlack
                               textFont:UIFontMake(15)
                          textAlignment:NSTextAlignmentLeft];
    [self addSubview:_nameLabel];
    
    //标签
    _tagButton = [QMUIButton new];
    [_tagButton setBackgroundImage:UIImageMake(@"teacher_icon_identifier_empty")
                          forState:UIControlStateNormal];
    [self addSubview:_tagButton];
    
    //关注按钮
    _followButton = [QMUIButton new];
    [_followButton setBackgroundImage:UIImageMake(@"note_icon_follow_add")
                             forState:0];
    [_followButton setBackgroundImage:UIImageMake(@"note_icon_follow_remove")
                             forState:UIControlStateSelected];
    [_followButton setTitle:@"+关注"
                   forState:0];
    [_followButton setTitle:@"取消关注"
                   forState:UIControlStateSelected];
    _followButton.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [_followButton setTitleColor:UIColorMakeWithHex(@"#333333")
                        forState:0];
    [_followButton setTitleColor:UIColorMakeWithHex(@"#999999")
                        forState:UIControlStateSelected];
    _followButton.titleLabel.font = UIFontMake(14);
    [_followButton addTarget:self
                      action:@selector(followClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followButton];
    
    //时间
    _timeLabel = [MyTools labelWithText:@""
                              textColor:UIColorMakeWithHex(@"#999999")
                               textFont:UIFontMake(14)
                          textAlignment:NSTextAlignmentLeft];
    [self addSubview:_timeLabel];
    
    //内容
    _contentLabel = [YYLabel new];
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    //内容视图
    _container = [UIView new];
    [self addSubview:_container];
    
    //视频封面
    _videoImageView = [UIImageView new];
    _videoImageView.backgroundColor = UIColorBlack;
    _videoImageView.contentMode = UIViewContentModeScaleAspectFit;
    _videoImageView.userInteractionEnabled = YES;
    [self addSubview:_videoImageView];
    
    //播放按钮
    QMUIButton *playButton = [QMUIButton new];
    [playButton setImage:UIImageMake(@"dynamic_icon_play")
                forState:0];
    [playButton addTarget:self
                   action:@selector(playClick)
         forControlEvents:UIControlEventTouchUpInside];
    [_videoImageView addSubview:playButton];
    
    //游记
    _noteButton = [QMUIButton new];
    [_noteButton setBackgroundColor:UIColorMakeWithHex(@"#FCF8F8")];
    [_noteButton addTarget:self
                    action:@selector(noteClick)
          forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_noteButton];
    
    //游记图片
    _noteImageView = [UIImageView new];
    [_noteButton addSubview:_noteImageView];
    
    //游记标题
    _noteTitle = [MyTools labelWithText:@"标题"
                              textColor:UIColorBlack
                               textFont:UIFontMake(17)
                          textAlignment:NSTextAlignmentLeft];
    [_noteButton addSubview:_noteTitle];
    
    //游记内容
    _noteContentLabel = [MyTools labelWithText:@"内容"
                                     textColor:UIColorMakeWithHex(@"#666666")
                                      textFont:UIFontMake(15)
                                 textAlignment:NSTextAlignmentLeft];
    [_noteButton addSubview:_noteContentLabel];
    
    //位置icon
    _icon = [UIImageView new];
    _icon.image = UIImageMake(@"track_icon_location_green");
    [self addSubview:_icon];
    
    //位置
    _location = [QMUIButton new];
    [_location setTitle:@"长沙市开福区政府"
               forState:UIControlStateNormal];
    [_location setTitleColor:UIColorMakeWithHex(@"#91CEC0")
                    forState:UIControlStateNormal];
    _location.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _location.titleLabel.font = UIFontMake(13);
    [self addSubview:_location];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorMakeWithHex(@"#F8F8F8");
    [self addSubview:line];
    
    _avatarImageView.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, 15)
    .widthIs(45)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_avatarImageView, 10)
    .topEqualToView(_avatarImageView)
    .heightIs(25);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _tagButton.sd_layout
    .leftSpaceToView(_nameLabel, 10)
    .topEqualToView(_nameLabel)
    .bottomEqualToView(_nameLabel)
    .widthIs(55);
    
    _followButton.sd_layout
    .rightSpaceToView(self, 15)
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
    .rightSpaceToView(self, 10)
    .heightIs(40);
    
    _container.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 10)
    .rightSpaceToView(self, 15);
    
    _videoImageView.sd_layout
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
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
    .rightSpaceToView(self, 10)
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
    .rightSpaceToView(self, 20)
    .heightIs(20);
    
    line.sd_layout
    .leftEqualToView(self)
    .topSpaceToView(_location, 10)
    .widthIs(SCREEN_WIDTH)
    .heightIs(10);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:0];
}

#pragma mark - 点击关注按钮
-(void)followClick:(QMUIButton *)button
{
    self.followBlock(button, _dynamicModel);
}

#pragma mark - 点击游记
-(void)noteClick
{
    self.noteBlock(_dynamicModel.travel_id);
}

#pragma mark - 点击播放视频
-(void)playClick
{
    self.playVideoBlock(_dynamicModel.video);
}

-(void)setDynamicModel:(DynamicListModel *)dynamicModel
{
    __weak __typeof (self)weakSelf = self;
    _dynamicModel = dynamicModel;
    
    //判断是否有视频
    if (dynamicModel.video.length == 0) {
        _videoImageView.hidden = YES;
        _container.hidden = NO;
    }else{
        _videoImageView.hidden = NO;
        [_videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?vframe/jpg/offset/1", dynamicModel.video]] placeholderImage:nil];
        _container.hidden = YES;
        
        _noteButton.sd_layout
        .leftEqualToView(_avatarImageView)
        .topSpaceToView(_videoImageView, 10)
        .rightSpaceToView(self, 10)
        .heightIs(90);
    }
    
    //用户信息
    NSDictionary *userDic = dynamicModel.user;
    [_avatarImageView sd_setImageWithURL:userDic[@"avatar"] placeholderImage:nil];
    _nameLabel.text = userDic[@"nickname"];
    _tagButton.hidden = [userDic[@"is_tutor"] intValue] == 0 ? YES : NO;
    _timeLabel.text = [KyoDateTools prettyDateWithDateString:[MyTools getDateStringWithTimeInterval:dynamicModel.createtime]];
    
    //解析内容
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[dynamicModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:@{NSFontAttributeName: UIFontMake(16)} range:NSMakeRange(0, attr.string.length)];
    // 将html字符串转为NSData
    NSData *data = [dynamicModel.content dataUsingEncoding:NSUTF8StringEncoding];
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
    
    [_contentLabel setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
        YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:range.location];
        weakSelf.tapContent(highlight.userInfo, [text.string substringWithRange:range]);
    }];
    CGSize size = [attr.string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:UIFontMake(16)}
                                            context:nil].size;
    _contentLabel.sd_layout.heightIs(size.height);
    
    
    if (dynamicModel.images.length > 0) {
        NSMutableArray *temp = [NSMutableArray new];
        NSArray *array = [dynamicModel.images componentsSeparatedByString:@","];
        for (int i = 0; i < array.count; i ++) {
            UIImageView *imageView = [UIImageView new];
            [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:nil];
            [_container addSubview:imageView];
            imageView.sd_layout.autoHeightRatio(0.8);
            [temp addObject:imageView];
        }
        
        [_container setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:3 itemWidth:SCREEN_WIDTH / 3.5
                              verticalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
    }else{
        _container.sd_layout.heightIs(0);
    }
    
    if ([dynamicModel.travel isKindOfClass:[NSDictionary class]]) {
        NoteDetailModel *noteModel = [[NoteDetailModel alloc] initModelWithDict:dynamicModel.travel];
        [_noteImageView sd_setImageWithURL:[NSURL URLWithString:noteModel.imgs.count > 0 ? noteModel.imgs[0] : @""] placeholderImage:nil];
        _noteTitle.text = noteModel.title;
        _noteContentLabel.text = noteModel.content;
    }else{
        _noteButton.sd_layout.heightIs(0);
        _noteButton.hidden = YES;
    }
    
    if (dynamicModel.position.length == 0) {
        _icon.hidden = YES;
        _location.hidden = YES;
        _icon.sd_layout.heightIs(0);
        _location.sd_layout.heightIs(0);
    }else{
        [_location setTitle:dynamicModel.position forState:0];
    }
    
    BOOL isFollow = [dynamicModel.is_follow intValue] == 0 ? NO : YES;
    
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

@end
