//
//  PagingViewTableHeaderView.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "TeacherDetailHeaderView.h"
#import "CustomView.h"
@interface TeacherDetailHeaderView()
@end

@implementation TeacherDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = @[(id)UIColorMakeWithHex(@"#8DFAC9").CGColor,(id)UIColorMakeWithHex(@"#3CCDEA").CGColor];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 1);
        gradient.locations = @[@(0.5f), @(1.0f)];
        [self.layer addSublayer:gradient];
        
        [self addSubViews];
    }
    return self;
}


-(void)addSubViews
{
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar6.jpg");
    _avatarImageView.layer.cornerRadius = 40;
    _avatarImageView.layer.masksToBounds = YES;
    [self addSubview:_avatarImageView];
    
    _femaleImageView = [UIImageView new];
    _femaleImageView.image = UIImageMake(@"teacher_icon_women");
    [self addSubview:_femaleImageView];
    
    _nameLabel = [MyTools labelWithText:@"张小斐" textColor:UIColorMakeWithHex(@"#333334") textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    [self addSubview:_nameLabel];
    
    _tagButton = [QMUIButton new];
    [_tagButton setBackgroundImage:UIImageMake(@"teacher_icon_identifier_fill") forState:UIControlStateNormal];
    _tagButton.titleLabel.font = UIFontMake(16);
    [self addSubview:_tagButton];
    
    QMUIButton *shareBtn = [QMUIButton new];
    [shareBtn setImage:UIImageMake(@"teacher_icon_share") forState:UIControlStateNormal];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
    shareBtn.imagePosition = QMUIButtonImagePositionLeft;
    shareBtn.spacingBetweenImageAndTitle = 5;
    shareBtn.titleLabel.font = UIFontMake(15);
    shareBtn.layer.cornerRadius = 5;
    shareBtn.layer.borderColor = UIColorWhite.CGColor;
    shareBtn.layer.borderWidth = 1;
    [shareBtn addTarget:self action:@selector(shareClicked:)  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    
    _starView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    _starView.maximumValue = 5;
    _starView.minimumValue = 0;
    _starView.value = 5;
    _starView.tintColor = [UIColor redColor];
    _starView.allowsHalfStars = YES;
    _starView.filledStarImage = UIImageMake(@"home_icon_star_fill");
    _starView.emptyStarImage = UIImageMake(@"home_icon_star_empty");
    _starView.halfStarImage = UIImageMake(@"home_icon_star_half");
    _starView.backgroundColor = UIColorClear;
    _starView.userInteractionEnabled = NO;
    [self addSubview:_starView];

    
    _followsButton = [QMUIButton new];
    [_followsButton setTitle:@"关注:234" forState:UIControlStateNormal];
    [_followsButton setTitleColor:UIColorMakeWithHex(@"#656667") forState:UIControlStateNormal];
    _followsButton.titleLabel.font = UIFontMake(16);
    [_followsButton addTarget:self action:@selector(followClicked:) forControlEvents:UIControlEventTouchUpInside];
    _followsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_followsButton];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorMakeWithHex(@"#656667");
    [self addSubview:line];
    
    _fansButton = [QMUIButton new];
    [_fansButton setTitle:@"粉丝:999+" forState:UIControlStateNormal];
    [_fansButton setTitleColor:UIColorMakeWithHex(@"#656667") forState:UIControlStateNormal];
    _fansButton.titleLabel.font = UIFontMake(16);
    [_fansButton addTarget:self action:@selector(fansClicked:) forControlEvents:UIControlEventTouchUpInside];
    _fansButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_fansButton];
    
//    CustomView *desView = [CustomView new];
//    desView.backgroundColor = UIColorMakeWithHex(@"#F6F4F4");
//    [self addSubview:desView];
    
    UIImageView *desView = [UIImageView new];
    desView.image = UIImageMake(@"teacher_icon_border");
    [self addSubview:desView];
    
    _desLabel = [MyTools labelWithText:@"东方红说过话看到回复刚看见到货付款刚看到立法机关老豆腐就好了" textColor:UIColorBlack textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    _desLabel.numberOfLines = 2;
    [desView addSubview:_desLabel];
    
    _avatarImageView.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, 10)
    .widthIs(80)
    .heightEqualToWidth();
    
    _femaleImageView.sd_layout
    .leftSpaceToView(_avatarImageView, -20)
    .bottomEqualToView(_avatarImageView)
    .widthIs(15)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_avatarImageView, 10)
    .topEqualToView(_avatarImageView)
    .heightIs(30);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _tagButton.sd_layout
    .leftSpaceToView(_nameLabel, 10)
    .centerYEqualToView(_nameLabel)
    .widthIs(60)
    .heightIs(20);
    
//    shareBtn.sd_layout
//    .rightSpaceToView(self, 10)
//    .centerYEqualToView(_tagButton)
//    .widthIs(60)
//    .heightIs(25);
    
    _starView.sd_layout
    .leftEqualToView(_nameLabel)
    .centerYEqualToView(_avatarImageView)
    .widthIs(80)
    .heightIs(25);
    
    _followsButton.sd_layout
    .leftEqualToView(_nameLabel)
    .bottomEqualToView(_avatarImageView)
    .widthIs(90)
    .heightIs(20);
    
    line.sd_layout
    .leftSpaceToView(_followsButton, 10)
    .topEqualToView(_followsButton)
    .widthIs(1)
    .bottomEqualToView(_followsButton);
    
    _fansButton.sd_layout
    .leftSpaceToView(line, 10)
    .topEqualToView(_followsButton)
    .widthIs(90)
    .heightIs(20);
    
    desView.sd_layout
    .leftSpaceToView(self, 20)
    .bottomSpaceToView(self, 10)
    .rightSpaceToView(self, 20)
    .topSpaceToView(_avatarImageView, 5);
    
    _desLabel.sd_layout
    .leftSpaceToView(desView, 10)
    .topSpaceToView(desView, 15)
    .rightSpaceToView(desView, 10)
    .bottomSpaceToView(desView, 5);
}

-(void)followClicked:(QMUIButton *)button
{
    if ([self respondsToSelector:@selector(followClicked:)]) {
        self.followBlock();
    }
}

-(void)fansClicked:(QMUIButton *)button
{
    if ([self respondsToSelector:@selector(fansClicked:)]) {
        self.fansBlock();
    }
}

-(void)shareClicked:(QMUIButton *)button
{
    if ([self respondsToSelector:@selector(shareClicked:)]) {
        self.shareBlock();
    }
}

-(void)setModel:(TeacherDetailModel *)model
{
    _femaleImageView.hidden     = [model.sex intValue] == 0 ? YES : NO;
    _femaleImageView.image      = [model.sex intValue] == 1 ? UIImageMake(@"teacher_icon_man") : UIImageMake(@"teacher_icon_women");
    _nameLabel.text             = model.nickname;
    _starView.value             = [model.star intValue];
    _desLabel.text              = model.bio;

    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                        placeholderImage:UIImageMake(@"common_icon_avatar")];
    [_followsButton setTitle:[NSString stringWithFormat:@"关注：%@", model.attention_number] forState:0];
    [_fansButton setTitle:[NSString stringWithFormat:@"粉丝：%@", model.follow_number] forState:0];

}

@end
