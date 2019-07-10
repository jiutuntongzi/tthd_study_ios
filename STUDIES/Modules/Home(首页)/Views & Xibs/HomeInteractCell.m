//
//  HomeInteractCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeInteractCell.h"

@implementation HomeInteractCell

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
    _imagePlayerView.layer.cornerRadius = 5;
    _imagePlayerView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imagePlayerView];
    
    [_imagePlayerView reloadData];
    
    _imagePlayerView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(Home_Interact_Height - 30);
    
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
    HomeCallModel *model = _dataArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.cover_img]
                 placeholderImage:UIImageMake(@"common_icon_placeholderImage")];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    self.selectedInteractBlock(_dataArray[index]);
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
