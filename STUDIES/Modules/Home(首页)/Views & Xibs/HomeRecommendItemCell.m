//
//  HomeRecommendItemCell.m
//  STUDIES
//
//  Created by 花想容 on 2019/6/1.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeRecommendItemCell.h"
#define itemHeight 60

@implementation HomeRecommendItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubViews];

    }
    return self;
}

-(void)addSubViews
{
    _titleLabel = [MyTools labelWithText:@"" textColor:UIColorWhite textFont:UIFontMake(15) textAlignment:NSTextAlignmentCenter];
    _titleLabel.backgroundColor = UIColorGreen;
    _titleLabel.layer.cornerRadius = 8;
    _titleLabel.layer.masksToBounds = YES;
    _titleLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.contentView addSubview:_titleLabel];

    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .heightIs(40);
//    [_titleLabel setSingleLineAutoResizeWithMaxWidth:200];
}

-(void)setTitleLabel:(QMUILabel *)titleLabel
{
    [_titleLabel updateLayout];
}

#pragma mark — 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGRect rect = [_titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, _titleLabel.size.height)
                                                 options:NSStringDrawingTruncatesLastVisibleLine
                                                        |NSStringDrawingUsesFontLeading
                                                        |NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}
                                                 context:nil];
    CGSize size = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
    rect.size.height = 50;
    rect.size.width = size.width + 30;
    attributes.frame = rect;
    return attributes;
}
@end
