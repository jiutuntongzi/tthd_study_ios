//
//  LineDetailRecommandCell.m
//  STUDIES
//
//  Created by happyi on 2019/5/27.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineDetailRecommandCell.h"

@implementation LineDetailRecommandCell

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
    _containerView = [UIView new];
    [self.contentView addSubview:_containerView];
    
    _containerView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10);
    
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:5];
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < dataArray.count; i ++) {
        LineThemeItemModel *model = dataArray[i];
        
        UIView *view = [UIView new];
        [_containerView addSubview:view];
        view.sd_layout.autoHeightRatio(1);
        [temp addObject:view];
        
        QMUIButton *imageView = [QMUIButton new];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.cover_img] forState:0];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.tag = 1000 + i;
        [imageView addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:imageView];
        
        UIImageView *avatar = [UIImageView new];
        [avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
        avatar.layer.cornerRadius = 20;
        avatar.layer.masksToBounds = YES;
        [view addSubview:avatar];
        
        QMUILabel *content = [MyTools labelWithText:model.title textColor:UIColorBlack textFont:UIFontMake(14) textAlignment:NSTextAlignmentLeft];
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
}

-(void)selectedClick:(QMUIButton *)button
{
    LineThemeItemModel *model = _dataArray[button.tag - 1000];
    self.selectedLineBlock(model.pId, model.tutor_id);
}

@end
