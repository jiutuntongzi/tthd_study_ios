//
//  LineHotCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/16.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineHotCell.h"

@implementation LineHotCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = BaseBackgroundColor;
        
        [self initLayout];
    }
    
    return self;
}

-(void)initLayout
{
    _topImageView = [UIImageView new];
    _topImageView.image = UIImageMake(@"default2.jpg");
    _topImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_topImageView];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    [_topImageView addGestureRecognizer:tgr];
    
    _containerView = [UIView new];
    [self.contentView addSubview:_containerView];
    
    _topImageView.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 5)
    .rightEqualToView(self.contentView)
    .heightIs(160);
    
    _containerView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(_topImageView, 10)
    .rightSpaceToView(self.contentView, 10);
    
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:5];
}

-(void)selectedClick:(QMUIButton *)button
{
    self.selectedLineBlock([_model.path[button.tag - 1000] pId], [_model.path[button.tag - 1000] tutor_id]);
}

-(void)tapImage
{
    self.selectedDestinationBlock(_model.tId);
}

-(void)setModel:(LineThemeModel *)model
{
    _model = model;
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < model.path.count; i ++) {
        UIView *view = [UIView new];
        [_containerView addSubview:view];
        view.sd_layout.autoHeightRatio(1);
        [temp addObject:view];
        
        QMUIButton *imageView = [QMUIButton new];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[model.path[i] cover_img]] forState:0];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.tag = 1000 + i;
        [imageView addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:imageView];
        
        UIImageView *avatar = [UIImageView new];
        [avatar sd_setImageWithURL:[NSURL URLWithString:[model.path[i] avatar]] placeholderImage:nil];
        avatar.layer.cornerRadius = 20;
        avatar.layer.masksToBounds = YES;
        [view addSubview:avatar];
        
        QMUILabel *content = [MyTools labelWithText:[model.path[i] title] textColor:UIColorBlack textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
        content.numberOfLines = 2;
        [view addSubview:content];
        
        imageView.sd_layout
        .leftEqualToView(view)
        .topEqualToView(view)
        .rightEqualToView(view)
        .autoHeightRatio(0.7);
        
        avatar.sd_layout
        .leftEqualToView(view)
        .topSpaceToView(imageView, 5)
        .widthIs(40)
        .heightEqualToWidth();
        
        content.sd_layout
        .leftSpaceToView(avatar, 5)
        .topEqualToView(avatar)
        .rightEqualToView(imageView)
        .bottomEqualToView(avatar);
    }
    
    [_containerView setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:2 itemWidth:SCREEN_WIDTH / 2 - 20 verticalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
    
    if (model.path.count == 0) {
        _containerView.sd_layout.heightIs(0);
    }
}

@end
