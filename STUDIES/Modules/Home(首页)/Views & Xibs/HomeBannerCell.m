//
//  HomeBannerCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeBannerCell.h"
#import "HomeSearchView.h"

@implementation HomeBannerCell

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
    _imagePlayerView.backgroundColor = [UIColor clearColor];
    _imagePlayerView.scrollInterval = 3;
    _imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
    _imagePlayerView.hidePageControl = NO;
    _imagePlayerView.endlessScroll = YES;
    _imagePlayerView.imagePlayerViewDelegate = self;
    [self.contentView addSubview:_imagePlayerView];
    
    [_imagePlayerView reloadData];
    
    _menuButton = [[QMUIButton alloc] init];
    [_menuButton setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.7]];
    _menuButton.layer.cornerRadius = 20;
    [_menuButton setImage:UIImageMake(@"home_icon_more") forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_menuButton];
    
    _searchView = [[HomeSearchView alloc] init];
    _searchView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.7];
    _searchView.searchLabel.textColor = UIColorBlack;
    _searchView.userInteractionEnabled = YES;
    [self.contentView addSubview:_searchView];
    
    _imagePlayerView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(Home_Banner_Height);
    
    _menuButton.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .centerYEqualToView(_searchView)
    .heightIs(40)
    .widthEqualToHeight();
    
    _searchView.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .rightSpaceToView(_menuButton, 10)
    .topSpaceToView(self.contentView, 50)
    .heightIs(40);
    
    [self setupAutoHeightWithBottomView:_imagePlayerView bottomMargin:10];
}

-(void)setModelArray:(NSMutableArray<BannerModel *> *)modelArray
{
    _modelArray = modelArray;
    [_imagePlayerView reloadData];
}

#pragma mark - 按钮点击
-(void)btnClick:(QMUIButton *)button
{
    if ([self respondsToSelector:@selector(btnClick:)]) {
        self.menuBtnClicked(button);
    }
}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return _modelArray.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    if (_modelArray.count == 0) {
        return;
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:_modelArray[index].image] placeholderImage:UIImageMake(@"commom_icon_placeholderImage")];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSMutableArray *array = [NSMutableArray array];
    for (BannerModel *model in _modelArray) {
        [array addObject:model.image];
    }
    self.tapImageBlock(array, index);
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
