//
//  HomeLiveItemCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeLiveItemCell.h"

@implementation HomeLiveItemCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
                
        self.backgroundColor = BaseBackgroundColor;
        
        [self setSubViews];
    }
    
    return self;
}

-(void)setSubViews
{
    UIImageView *imageView = [UIImageView new];
    imageView.image = UIImageMake(@"content1.jpg");
    imageView.layer.cornerRadius = 6;
    imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView];
    
    UIImageView *avatar = [UIImageView new];
    avatar.image = UIImageMake(@"avatar1.jpg");
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    avatar.layer.cornerRadius = 20;
    avatar.layer.masksToBounds = YES;
    [self.contentView addSubview:avatar];
    
    QMUILabel *name = [MyTools labelWithText:@"直播用户" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:name];
    
    UIImageView *icon = [UIImageView new];
    icon.backgroundColor = UIColorClear;
    icon.image = UIImageMake(@"home_icon_hot");
    [self.contentView addSubview:icon];
    
    QMUILabel *hot = [MyTools labelWithText:@"1.3w" textColor:UIColorRed textFont:UIFontMake(12) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:hot];
    
    QMUILabel *time = [MyTools labelWithText:@"2019-03-22" textColor:UIColorGray textFont:UIFontMake(12) textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:time];
    
    imageView.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 5)
    .heightIs(120);
    
    avatar.sd_layout
    .leftEqualToView(imageView)
    .topSpaceToView(imageView, 5)
    .widthIs(40)
    .heightEqualToWidth();
    
    name.sd_layout
    .topEqualToView(avatar)
    .leftSpaceToView(avatar, 5)
    .rightEqualToView(imageView)
    .autoHeightRatio(0);
    
    icon.sd_layout
    .leftEqualToView(name)
    .bottomEqualToView(avatar)
    .widthIs(10)
    .heightIs(12);
    
    hot.sd_layout
    .leftSpaceToView(icon, 5)
    .centerYEqualToView(icon)
    .widthIs(30)
    .heightIs(20);
    
    time.sd_layout
    .rightEqualToView(imageView)
    .centerYEqualToView(icon)
    .widthIs(80)
    .heightIs(20);
}

@end
