//
//  LineDetailHeaderView.m
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineDetailHeaderView.h"
#import "HCSStarRatingView.h"

@implementation LineDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        [self addSubViews];
    }
    
    return self;
}

-(void)addSubViews
{
    _imagePlayerView = [ImagePlayerView new];
    _imagePlayerView.backgroundColor = [UIColor clearColor];
    _imagePlayerView.scrollInterval = 3;
    _imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
    _imagePlayerView.hidePageControl = NO;
    _imagePlayerView.endlessScroll = YES;
    _imagePlayerView.imagePlayerViewDelegate = self;
    [self addSubview:_imagePlayerView];
    
    QMUIButton *backButton = [QMUIButton new];
    [backButton setImage:UIImageMake(@"base_icon_back") forState:0];
    [backButton addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    QMUIButton *shareButton = [QMUIButton new];
    [shareButton setImage:UIImageMake(@"note_icon_share") forState:0];
    [shareButton addTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
    
    _titleLabel = [MyTools labelWithText:@"经典线路：玉龙雪山+洱海+大理+昆明+苍山+泸沽湖+香格里拉10天8晚游" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = UIColorMakeWithHex(@"#EEEEEE");
    [self addSubview:line1];
    
    QMUILabel *teacher = [MyTools labelWithText:@"研学导师" textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
    [self addSubview:teacher];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = UIImageMake(@"avatar8.jpg");
    [self addSubview:_avatarImageView];
    
    _nameLabel = [MyTools labelWithText:@"花想容" textColor:UIColorBlack textFont:UIFontMake(17) textAlignment:NSTextAlignmentLeft];
    [self addSubview:_nameLabel];
    
    _femaleImageView = [UIImageView new];
    _femaleImageView.image = UIImageMake(@"teacher_icon_women");
    [self addSubview:_femaleImageView];
    
    _starView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    _starView.maximumValue = 5;
    _starView.minimumValue = 0;
    _starView.value = 3.5;
    _starView.tintColor = [UIColor redColor];
    _starView.allowsHalfStars = YES;
    _starView.filledStarImage = UIImageMake(@"home_icon_star_fill");
    _starView.emptyStarImage = UIImageMake(@"home_icon_star_empty");
    _starView.halfStarImage = UIImageMake(@"home_icon_star_half");
    [self addSubview:_starView];
    
    _desLabel = [MyTools labelWithText:@"风趣幽默，经验丰富" textColor:UIColorMakeWithHex(@"#646566") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    [self addSubview:_desLabel];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = UIColorMakeWithHex(@"#EEEEEE");
    [self addSubview:line2];
    
    _imagePlayerView.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .rightEqualToView(self)
    .heightIs(200);
    
    backButton.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, BaseStatusViewHeight)
    .widthIs(44)
    .heightIs(44);
    
    shareButton.sd_layout
    .centerYEqualToView(backButton)
    .rightSpaceToView(self, 10)
    .widthIs(44)
    .heightIs(44);
    
    _titleLabel.sd_layout
    .leftSpaceToView(self, 20)
    .rightSpaceToView(self, 20)
    .topSpaceToView(_imagePlayerView, 10)
    .heightIs(50);
    
    line1.sd_layout
    .leftEqualToView(self)
    .topSpaceToView(_titleLabel, 15)
    .rightEqualToView(self)
    .heightIs(5);
    
    teacher.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(line1, 5)
    .widthIs(100)
    .heightIs(25);
    
    _avatarImageView.sd_layout
    .leftEqualToView(teacher)
    .topSpaceToView(teacher, 10)
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
    .rightSpaceToView(self, 50)
    .heightIs(20);
    
    line2.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(_avatarImageView, 10)
    .heightIs(5);
}

-(void)backClicked
{
    if ([self respondsToSelector:@selector(backClicked)]) {
        self.backBlock();
    }
}

-(void)shareClicked
{
    if ([self respondsToSelector:@selector(shareClicked)]) {
        self.shareBlock();
    }
}

-(void)setModel:(LineDetailModel *)model
{
    _model = model;
    
    [_imagePlayerView reloadData];
    _titleLabel.text = model.title;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    _nameLabel.text = model.nickname;
    _femaleImageView.image = [model.sex intValue] == 1 ? UIImageMake(@"teacher_icon_man") : UIImageMake(@"teacher_icon_women");
    _starView.value = [model.star floatValue];
    _desLabel.text = model.bio;
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
