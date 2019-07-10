//
//  LiveTableViewCell.m
//  STUDIES
//
//  Created by happyi on 2019/4/16.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LiveSearchCell.h"

@implementation LiveSearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = BaseBackgroundColor;
        
        [self setSubViews];
    }
    
    return self;
}

#pragma mark - 子视图
-(void)setSubViews
{
    UIImageView *imageView = [UIImageView new];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.image = UIImageMake(@"content7.jpg");
    [self addSubview:imageView];
    
    UILabel *title = [MyTools labelWithText:@"我是直播内容标题" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self addSubview:title];
    
    UIImageView *avatar = [UIImageView new];
    avatar.image = UIImageMake(@"avatar9.jpg");
    avatar.layer.cornerRadius = 20;
    avatar.layer.masksToBounds = YES;
    [self addSubview:avatar];
    
    QMUILabel *name = [MyTools labelWithText:@"我是直播用户" textColor:UIColorBlack textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:name];
    
    UIImageView *icon = [UIImageView new];
    icon.backgroundColor = UIColorClear;
    icon.image = UIImageMake(@"home_icon_hot");
    [self.contentView addSubview:icon];
    
    QMUILabel *hot = [MyTools labelWithText:@"1.3w" textColor:UIColorRed textFont:UIFontMake(12) textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:hot];
    
    QMUILabel *time = [MyTools labelWithText:@"2019-03-22" textColor:UIColorGray textFont:UIFontMake(12) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:time];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorGray;
    [self.contentView addSubview:line];
    
    imageView.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, 15)
    .widthIs(SCREEN_WIDTH / 3)
    .heightIs(100);
    
    title.sd_layout
    .leftSpaceToView(imageView, 10)
    .topEqualToView(imageView)
    .rightSpaceToView(self, 20)
    .autoHeightRatio(0);
    
    avatar.sd_layout
    .leftEqualToView(title)
    .bottomEqualToView(imageView)
    .heightIs(40)
    .widthIs(40);
    
    name.sd_layout
    .leftSpaceToView(avatar, 10)
    .topEqualToView(avatar)
    .widthIs(120)
    .autoHeightRatio(0);
    
    time.sd_layout
    .leftEqualToView(name)
    .bottomEqualToView(avatar)
    .widthIs(180) 
    .autoHeightRatio(0);
    
    hot.sd_layout
    .centerYEqualToView(time)
    .rightEqualToView(title)
    .widthIs(30)
    .autoHeightRatio(0);
    
    icon.sd_layout
    .centerYEqualToView(hot)
    .rightSpaceToView(hot, 5)
    .widthIs(10)
    .heightIs(12);
    
    line.sd_layout
    .leftEqualToView(imageView)
    .rightEqualToView(title)
    .topSpaceToView(imageView, 15)
    .heightIs(0.3);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:15];
}

@end
