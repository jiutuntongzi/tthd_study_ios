//
//  TopicSearchCell.m
//  STUDIES
//
//  Created by happyi on 2019/4/29.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TopicSearchCell.h"

@implementation TopicSearchCell

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
    _imageView = [UIImageView new];
    _imageView.image = UIImageMake(@"content8.jpg");
    _imageView.layer.cornerRadius = 5;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    _titleLabel = [MyTools labelWithText:@"#话题标题#" textColor:UIColorMakeWithHex(@"#91CEC0") textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [MyTools labelWithText:@"内容" textColor:UIColorMakeWithHex(@"#000000") textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_contentLabel];
    
    _discussLabel = [MyTools labelWithText:@"讨论  100" textColor:UIColorMakeWithHex(@"#999999") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_discussLabel];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorGray;
    [self.contentView addSubview:line];
    
    _imageView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(115)
    .heightIs(95);
    
    _titleLabel.sd_layout
    .topEqualToView(_imageView)
    .leftSpaceToView(_imageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    
    _discussLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomEqualToView(_imageView)
    .widthIs(120)
    .autoHeightRatio(0);
    
    _contentLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, 10)
    .rightSpaceToView(self.contentView, 10)
    .bottomSpaceToView(_discussLabel, 10);
    
    line.sd_layout
    .leftEqualToView(_imageView)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(_imageView, 15)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:line bottomMargin:5];
}

-(void)setModel:(TopicListModel *)model
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.images]
                  placeholderImage:UIImageMake(@"common_icon_placeholderImage")];
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    _contentLabel.text = model.describe;
    _discussLabel.text = [NSString stringWithFormat:@"讨论  %@", model.discuss];
}

@end
