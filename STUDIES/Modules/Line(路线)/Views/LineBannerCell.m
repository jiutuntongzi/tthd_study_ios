//
//  LineBannerCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineBannerCell.h"
#import "HomeSearchView.h"
#import "BannerModel.h"

@implementation LineBannerCell

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
    _imagePlayerView = [ImagePlayerView new];
    _imagePlayerView.imagePlayerViewDelegate = self;
    _imagePlayerView.backgroundColor = [UIColor clearColor];
    _imagePlayerView.scrollInterval = 3;
    _imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
    _imagePlayerView.hidePageControl = NO;
    _imagePlayerView.endlessScroll = YES;
    _imagePlayerView.imagePlayerViewDelegate = self;
    [self.contentView addSubview:_imagePlayerView];
    
    [_imagePlayerView reloadData];
    
    _searchView = [[HomeSearchView alloc] init];
    _searchView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.7];
    _searchView.searchLabel.textColor = UIColorBlack;
    [self.contentView addSubview:_searchView];
    
    _imagePlayerView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(Home_Banner_Height);
    
    _searchView.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 20)
    .topSpaceToView(self.contentView, 50)
    .heightIs(40);
    
    [self setupAutoHeightWithBottomView:_imagePlayerView bottomMargin:15];
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [_imagePlayerView reloadData];
}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return _dataArray.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    if (_dataArray.count == 0) {
        return;
    }
    BannerModel *model = _dataArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    //    self.clicked(index);
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
