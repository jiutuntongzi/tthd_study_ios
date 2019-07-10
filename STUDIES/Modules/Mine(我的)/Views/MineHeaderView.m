//
//  MineHeaderView.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineHeaderView.h"

@implementation MineHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,SCREEN_WIDTH,frame.size.height);
        gl.startPoint = CGPointMake(1, 1);
        gl.endPoint = CGPointMake(0, 0);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:39/255.0 green:205/255.0 blue:235/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:133/255.0 green:251/255.0 blue:200/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0.0f),@(1.0f)];
        [self.layer addSublayer:gl];
        
        [self addSubViews];

    }
    
    return self;
}

-(void)addSubViews
{
    QMUIButton *setButton = [QMUIButton new];
    [setButton setBackgroundImage:UIImageMake(@"mine_icon_set") forState:0];
    [setButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:setButton];
    
    QMUILabel *title = [MyTools labelWithText:@"个人中心" textColor:UIColorWhite textFont:UIFontMake(22) textAlignment:NSTextAlignmentCenter];
    [self addSubview:title];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar9.jpg");
    _avatarImageView.layer.cornerRadius = 40;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.backgroundColor = UIColorRed;
    [self addSubview:_avatarImageView];
    
    _nameLabel = [MyTools labelWithText:@"花想容" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    [self addSubview:_nameLabel];
    
    QMUIButton *editButton = [QMUIButton new];
    [editButton setImage:UIImageMake(@"mine_icon_edit") forState:0];
    [editButton addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editButton];
    
    _desLabel = [MyTools labelWithText:@"云想衣裳花想容，春风拂槛露华浓，若非群玉山头见，会向瑶台月下逢" textColor:UIColorMakeWithHex(@"#3D5254") textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
    _desLabel.backgroundColor = UIColorMakeWithHex(@"#B1EAF4");
    _desLabel.numberOfLines = 2;
    _desLabel.layer.cornerRadius = 5;
    _desLabel.layer.masksToBounds = YES;
    _desLabel.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [self addSubview:_desLabel];
    
    _unloginButton = [UIButton new];
    [_unloginButton setTitle:@"登录获得更多体验" forState:0];
    [_unloginButton setTitleColor:UIColorBlack forState:0];
    _unloginButton.titleLabel.font = UIFontMake(18);
    _unloginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_unloginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_unloginButton];
    
    _dynamicButton = [QMUIButton new];
    [_dynamicButton setTitle:@"动态 0" forState:0];
    [_dynamicButton setTitleColor:UIColorWhite forState:0];
    _dynamicButton.titleLabel.font = UIFontMake(18);
    [_dynamicButton addTarget:self action:@selector(dynamicClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dynamicButton];
    
    _followsButton = [QMUIButton new];
    [_followsButton setTitle:@"关注 0" forState:0];
    [_followsButton setTitleColor:UIColorWhite forState:0];
    _followsButton.titleLabel.font = UIFontMake(18);
    [_followsButton addTarget:self action:@selector(followClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followsButton];
    
    _fansButton = [QMUIButton new];
    [_fansButton setTitle:@"粉丝 0" forState:0];
    [_fansButton setTitleColor:UIColorWhite forState:0];
    _fansButton.titleLabel.font = UIFontMake(18);
    [_fansButton addTarget:self action:@selector(fansClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fansButton];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = UIColorWhite;
    [self addSubview:line1];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = UIColorWhite;
    [self addSubview:line2];
    
    setButton.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, BaseStatusViewHeight + 5)
    .widthIs(25)
    .heightIs(25);
    
    title.sd_layout
    .leftEqualToView(self)
    .centerYEqualToView(setButton)
    .rightEqualToView(self)
    .heightIs(30);
    
    _avatarImageView.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(title, 10)
    .heightIs(80)
    .widthEqualToHeight();
    
    editButton.sd_layout
    .rightSpaceToView(self, 20)
    .topEqualToView(_avatarImageView)
    .widthIs(30)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_avatarImageView, 10)
    .topEqualToView(_avatarImageView)
    .widthIs(200)
    .heightIs(25);
    
    _desLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .bottomEqualToView(_avatarImageView)
    .rightSpaceToView(self, 20)
    .heightIs(50);
    
    _unloginButton.sd_layout
    .centerYEqualToView(_avatarImageView)
    .leftSpaceToView(_avatarImageView, 15)
    .widthIs(160)
    .heightIs(30);
    
    _dynamicButton.sd_layout
    .leftEqualToView(self)
    .topSpaceToView(_avatarImageView, 10)
    .heightIs(40)
    .widthIs(self.width / 3);
    
    line1.sd_layout
    .leftSpaceToView(_dynamicButton, 0)
    .centerYEqualToView(_dynamicButton)
    .widthIs(0.5)
    .heightIs(30);
    
    _followsButton.sd_layout
    .leftSpaceToView(line1, 0)
    .centerYEqualToView(_dynamicButton)
    .widthIs(self.width / 3)
    .heightIs(40);
    
    line2.sd_layout
    .leftSpaceToView(_followsButton, 0)
    .centerYEqualToView(_dynamicButton)
    .widthIs(0.5)
    .heightIs(30);
    
    _fansButton.sd_layout
    .centerYEqualToView(_followsButton)
    .leftSpaceToView(line2, 0)
    .widthIs(self.width / 3)
    .heightIs(40);
}

#pragma mark - 点击设置
-(void)setClick
{
    if ([self respondsToSelector:@selector(setClick)]) {
        self.setClickBlock();
    }
}

-(void)dynamicClick
{
    if ([self respondsToSelector:@selector(dynamicClick)]) {
        self.dynamicBlock();
    }
}

-(void)followClick
{
    if ([self respondsToSelector:@selector(followClick)]) {
        self.followBlock();
    }
}

-(void)fansClick
{
    if ([self respondsToSelector:@selector(fansClick)]) {
        self.fansBlock();
    }
}

-(void)loginClick
{
    if ([self respondsToSelector:@selector(loginClick)]) {
        self.loginBlock();
    }
}

-(void)editClick
{
    if ([self respondsToSelector:@selector(editClick)]) {
        self.editBlock();
    }
}

-(void)setInfoModel:(UserInfoModel *)infoModel
{
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:infoModel == nil ? @"" : infoModel.avatar]
                        placeholderImage:UIImageMake(@"common_icon_avatar")];
    _nameLabel.text     = infoModel.nickname;
    _nameLabel.hidden   = infoModel == nil ? YES : NO;
    _desLabel.text      = infoModel.bio;
    _desLabel.hidden    = infoModel == nil ? YES :NO;
    _unloginButton.hidden    = !_nameLabel.hidden;
}

-(void)setIndexModel:(UserIndexModel *)indexModel
{
    [_dynamicButton setTitle:[NSString stringWithFormat:@"动态 %@", indexModel == nil ? @"0" : indexModel.dynamic_number]
                    forState:0];
    [_followsButton setTitle:[NSString stringWithFormat:@"关注 %@", indexModel == nil ? @"0" : indexModel.attention_number]
                    forState:0];
    [_fansButton setTitle:[NSString stringWithFormat:@"粉丝 %@", indexModel == nil ? @"0" : indexModel.follow_number]
                 forState:0];
}

@end
