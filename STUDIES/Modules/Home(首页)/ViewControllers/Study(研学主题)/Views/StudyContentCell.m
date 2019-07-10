//
//  StudyContentCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "StudyContentCell.h"

@implementation StudyContentCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayout];
    }
    
    return self;
}

-(void)initLayout
{
    _coverImageView = [UIImageView new];
    _coverImageView.image = UIImageMake(@"content2.jpg");
    _coverImageView.layer.cornerRadius = 6;
    _coverImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_coverImageView];
    
    
    _coverImageView.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 5)
    .heightIs(120);
}

-(void)setModel:(LineThemeModel *)model
{
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil
     ];
}

@end
