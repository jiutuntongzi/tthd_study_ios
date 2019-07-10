//
//  LineDetailImageCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineDetailImageCell.h"

@implementation LineDetailImageCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BaseBackgroundColor;
        
        [self initLayout];
    }
    
    return self;
}

-(void)initLayout
{
    _imageView = [UIImageView new];
    _imageView.image = UIImageMake(@"content2.jpg");
    _imageView.layer.cornerRadius = 6;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    _imageView.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 5)
    .heightIs(150);
}

-(void)setImageUrl:(NSString *)imageUrl
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
}

@end
