//
//  HomeMenuCell.m
//  STUDIES
//
//  Created by happyi on 2019/3/13.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeMenuCell.h"

@implementation HomeMenuCell

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
    _containerView = [UIView new];
    _containerView.backgroundColor = BaseBackgroundColor;
    [self.contentView addSubview:_containerView];
    
    NSMutableArray *temp = [NSMutableArray new];
    NSArray *titles = @[@"导师", @"游记", @"话题", @"足迹打卡", @"研学主题", @"互动打call"];
    NSArray *images = @[@"home_icon_teacher", @"home_icon_travel", @"home_icon_topic", @"home_icon_track", @"home_icon_study", @"home_icon_interact"];
    for (int i = 0; i < titles.count; i ++) {
        QMUIButton *button = [QMUIButton new];
        [button setImage:UIImageMake(images[i]) forState:0];
        [button setTitle:titles[i] forState:0];
        [button setTitleColor:UIColorBlack forState:0];
        button.imagePosition = QMUIButtonImagePositionTop;
        button.spacingBetweenImageAndTitle = 10;
        button.titleLabel.font = UIFontMake(15);
        [button addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 + i;
        [_containerView addSubview:button];
        button.sd_layout.autoHeightRatio(1);
        [temp addObject:button];
    }
    
    [_containerView setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:4 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];
    
    _containerView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .widthIs(SCREEN_WIDTH)
    .heightIs(Home_Menu_Height);
    
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
}

#pragma mark - 点击事件
-(void)menuClicked:(QMUIButton *)button
{
    if ([self respondsToSelector:@selector(menuClicked:)]) {
        self.selectMenu(button.tag);
    }
}

@end
