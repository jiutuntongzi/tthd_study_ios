//
//  DynamicUserCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/10.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "DynamicUserCell.h"
#import <HCSStarRatingView.h>

@implementation DynamicUserCell

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
    UIImageView *avatar = [UIImageView new];
    avatar.image = UIImageMake(@"avatar4.jpg");
    avatar.layer.cornerRadius = 3;
    avatar.layer.masksToBounds = YES;
    [self.contentView addSubview:avatar];
    
    QMUILabel *name = [MyTools labelWithText:@"张小花" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:name];
    
    UIImageView *female = [UIImageView new];
    female.image = UIImageMake(@"teacher_icon_women");
    [self.contentView addSubview:female];
    
    QMUIButton *tag = [QMUIButton new];
    [tag setBackgroundImage:UIImageMake(@"teacher_icon_identifier_empty") forState:UIControlStateNormal];
    [self.contentView addSubview:tag];
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 3.5;
    starRatingView.tintColor = [UIColor redColor];
    starRatingView.allowsHalfStars = YES;
    starRatingView.filledStarImage = UIImageMake(@"home_icon_star_fill");
    starRatingView.emptyStarImage = UIImageMake(@"home_icon_star_empty");
    starRatingView.halfStarImage = UIImageMake(@"home_icon_star_half");
    [self.contentView addSubview:starRatingView];
    
    QMUILabel *fans = [MyTools labelWithText:@"粉丝：99" textColor:UIColorMakeWithHex(@"#646566") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:fans];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorMakeWithHex(@"#E4E5E6");
    [self.contentView addSubview:line];
    
    avatar.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(70)
    .heightEqualToWidth();
    
    name.sd_layout
    .leftSpaceToView(avatar, 10)
    .topEqualToView(avatar)
    .widthIs(70)
    .autoHeightRatio(0);
    
    female.sd_layout
    .centerYEqualToView(name)
    .leftSpaceToView(name, 15)
    .widthIs(15)
    .heightEqualToWidth();
    
    tag.sd_layout
    .leftSpaceToView(female, 10)
    .topEqualToView(female)
    .bottomEqualToView(female)
    .widthIs(45);
    
    starRatingView.sd_layout
    .leftEqualToView(name)
    .centerYEqualToView(self.contentView)
    .heightIs(25)
    .widthIs(100);
    
    fans.sd_layout
    .leftEqualToView(name)
    .bottomEqualToView(avatar)
    .rightSpaceToView(self.contentView, 20)
    .autoHeightRatio(0);
    
    line.sd_layout
    .leftEqualToView(avatar)
    .topSpaceToView(avatar, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:0];
}

@end
