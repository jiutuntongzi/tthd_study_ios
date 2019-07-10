//
//  LineDetailTeacherCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineDetailTeacherCell.h"

@implementation LineDetailTeacherCell

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

-(void)setSubViews
{
    QMUILabel *label = [MyTools labelWithText:@"研学导师" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:label];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar8.jpg");
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [MyTools labelWithText:@"花想容" textColor:UIColorBlack textFont:UIFontMake(17) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _femaleImageView = [UIImageView new];
    _femaleImageView.image = UIImageMake(@"teacher_icon_women");
    [self.contentView addSubview:_femaleImageView];
    
    _starView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    _starView.maximumValue = 5;
    _starView.minimumValue = 0;
    _starView.value = 3.5;
    _starView.tintColor = [UIColor redColor];
    _starView.allowsHalfStars = YES;
    _starView.filledStarImage = UIImageMake(@"home_icon_star_fill");
    _starView.emptyStarImage = UIImageMake(@"home_icon_star_empty");
    _starView.halfStarImage = UIImageMake(@"home_icon_star_half");
    _starView.userInteractionEnabled = NO;
    [self.contentView addSubview:_starView];
    
    _desLabel = [MyTools labelWithText:@"风趣幽默，经验丰富" textColor:UIColorMakeWithHex(@"#646566") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_desLabel];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorGray;
    [self.contentView addSubview:line];
    
    label.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .heightIs(30);
    [label setSingleLineAutoResizeWithMaxWidth:200];
    
    _avatarImageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(label, 10)
    .widthIs(80)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_avatarImageView, 10)
    .topEqualToView(_avatarImageView)
    .heightIs(25);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _femaleImageView.sd_layout
    .centerYEqualToView(_nameLabel)
    .leftSpaceToView(_nameLabel, 15)
    .widthIs(15)
    .heightEqualToWidth();
    
    _starView.sd_layout
    .leftEqualToView(_nameLabel)
    .centerYEqualToView(_avatarImageView)
    .heightIs(25)
    .widthIs(100);
    
    _desLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .bottomEqualToView(_avatarImageView)
    .rightSpaceToView(self.contentView, 50)
    .heightIs(20);
    
    line.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(_avatarImageView, 20)
    .widthIs(SCREEN_WIDTH)
    .heightIs(10);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:5];
}

-(void)setModel:(LineDetailModel *)model
{
    _model = model;
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    _nameLabel.text = model.nickname;
    _femaleImageView.image = [model.sex intValue] == 1 ? UIImageMake(@"teacher_icon_man") : UIImageMake(@"teacher_icon_women");
    _starView.value = [model.star floatValue];
    _desLabel.text = model.bio;
}

@end
