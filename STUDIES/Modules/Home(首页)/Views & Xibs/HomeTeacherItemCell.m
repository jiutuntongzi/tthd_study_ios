//
//  HomeTeacherItemCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/14.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeTeacherItemCell.h"
@implementation HomeTeacherItemCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseBackgroundColor;
        
        [self setSubViews];
    }
    
    return self;
}

-(void)setSubViews
{
    UIView *container = [UIView new];
    container.backgroundColor = UIColorMakeWithHex(@"#DFF0EC");
    container.layer.cornerRadius = 5;
    container.layer.masksToBounds = YES;
    [self.contentView addSubview:container];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar2.jpg");
    [container addSubview:_avatarImageView];
    
    _starView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    _starView.maximumValue = 5;
    _starView.minimumValue = 0;
    _starView.value = 3.5;
    _starView.tintColor = [UIColor redColor];
    _starView.allowsHalfStars = YES;
    _starView.filledStarImage = UIImageMake(@"home_icon_star_fill");
    _starView.emptyStarImage = UIImageMake(@"home_icon_star_empty");
    _starView.halfStarImage = UIImageMake(@"home_icon_star_half");
    _starView.backgroundColor = UIColorClear;
    _starView.userInteractionEnabled = NO;
    [container addSubview:_starView];
    
    _nameLabel = [MyTools labelWithText:@"张小花" textColor:UIColorBlack textFont:UIFontMake(14) textAlignment:NSTextAlignmentCenter];
    [container addSubview:_nameLabel];
    
    _desLabel = [MyTools labelWithText:@"风趣幽默，经验丰富" textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(12) textAlignment:NSTextAlignmentCenter];
    [container addSubview:_desLabel];
    
    _followButton = [QMUIButton new];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_followButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
    [_followButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateSelected];
    [_followButton setBackgroundColor:UIColorMakeWithHex(@"#FED631")];
    _followButton.layer.cornerRadius = 10;
    _followButton.titleLabel.font = UIFontMake(15);
    [self.contentView addSubview:_followButton];
    
    _followButton.sd_layout
    .centerXEqualToView(self.contentView)
    .bottomSpaceToView(self.contentView, 5)
    .heightIs(25)
    .widthIs(self.contentView.width / 2 + 10);
    
    container.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 5)
    .bottomSpaceToView(_followButton, 10);
    
    _avatarImageView.sd_layout
    .leftSpaceToView(container, 8)
    .topSpaceToView(container, 8)
    .rightSpaceToView(container, 8)
    .heightEqualToWidth();
    
    _starView.sd_layout
    .topSpaceToView(_avatarImageView, -10)
    .heightIs(20)
    .leftSpaceToView(container, 20)
    .rightSpaceToView(container, 20);
    
    _nameLabel.sd_layout
    .leftEqualToView(_avatarImageView)
    .rightEqualToView(_avatarImageView)
    .topSpaceToView(_avatarImageView, 10)
    .autoHeightRatio(0);
    
    _desLabel.sd_layout
    .leftEqualToView(_avatarImageView)
    .rightEqualToView(_avatarImageView)
    .topSpaceToView(_nameLabel, 0)
    .autoHeightRatio(0);
    
}

-(void)setModel:(HomeTutorModel *)model
{
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                        placeholderImage:UIImageMake(@"commom_icon_placeholderImage")];
    _starView.value = [model.star intValue];
    _nameLabel.text = model.nickname;
    BOOL isFollow = [model.is_follow intValue] == 0 ? NO : YES;
    if (isFollow == YES) {
        [_followButton setBackgroundColor:UIColorWhite];
        _followButton.layer.borderColor = UIColorMakeWithHex(@"#666666").CGColor;
        _followButton.layer.borderWidth = 1;
        [_followButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:0];
        [_followButton setTitle:@"已关注" forState:0];
    }else{
        [_followButton setBackgroundColor:UIColorMakeWithHex(@"#FED631")];
        _followButton.layer.borderColor = UIColorClear.CGColor;
    }
}

@end
