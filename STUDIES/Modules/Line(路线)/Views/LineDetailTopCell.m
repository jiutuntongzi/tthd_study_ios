//
//  LineDetailTopCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineDetailTopCell.h"

@implementation LineDetailTopCell

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
    _imagePlayerView = [ImagePlayerView new];
    _imagePlayerView.backgroundColor = [UIColor clearColor];
    _imagePlayerView.scrollInterval = 3;
    _imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
    _imagePlayerView.hidePageControl = NO;
    _imagePlayerView.endlessScroll = YES;
    _imagePlayerView.imagePlayerViewDelegate = self;
    [self.contentView addSubview:_imagePlayerView];
    
    _titleLabel = [MyTools labelWithText:@"经典线路：玉龙雪山+洱海+大理+昆明+苍山+泸沽湖+香格里拉10天8晚游" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorGray;
    [self.contentView addSubview:line];
    
    _imagePlayerView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(200);
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(_imagePlayerView, 10)
    .heightIs(50);
    
    line.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(_titleLabel, 10)
    .widthIs(SCREEN_WIDTH)
    .heightIs(10);

    [self setupAutoHeightWithBottomView:line bottomMargin:5];
}

-(void)setModel:(LineDetailModel *)model
{
    _model = model;
    
    [_imagePlayerView reloadData];
    _titleLabel.text = model.title;
}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return _model.imgs.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    if (_model.imgs.count == 0) {
        return;
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.imgs[index]] placeholderImage:nil];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    self.imagePlayerBlock();
}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didScorllIndex:(NSInteger)index
{
    //    if (_bannerArray.count > 0) {
    //        MH_BannerModel *model = _bannerArray[index];
    //
    //        _descLabel.text = model.desc.length > 40 ? [model.desc substringToIndex:40] : model.desc;
    //    }
}


@end
