//
//  MineButtonsView.m
//  STUDIES
//
//  Created by happyi on 2019/5/17.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "MineButtonsView.h"

@implementation MineButtonsView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViews];
    }
    
    return self;
}

-(void)addSubViews
{
    QMUIButton *collectButton = [QMUIButton new];
    [collectButton setImage:UIImageMake(@"mine_icon_collect") forState:0];
    [collectButton setTitle:@"收藏夹" forState:0];
    collectButton.imagePosition = QMUIButtonImagePositionTop;
    collectButton.spacingBetweenImageAndTitle = 5;
    [collectButton setTitleColor:UIColorBlack forState:0];
    collectButton.titleLabel.font = UIFontMake(16);
    [collectButton addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:collectButton];
    
    QMUIButton *trackButton = [QMUIButton new];
    [trackButton setImage:UIImageMake(@"mine_icon_collect") forState:0];
    [trackButton setTitle:@"我的足记" forState:0];
    trackButton.imagePosition = QMUIButtonImagePositionTop;
    trackButton.spacingBetweenImageAndTitle = 5;
    [trackButton setTitleColor:UIColorBlack forState:0];
    trackButton.titleLabel.font = UIFontMake(16);
    [trackButton addTarget:self action:@selector(trackClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:trackButton];
    
    QMUIButton *topicButton = [QMUIButton new];
    [topicButton setImage:UIImageMake(@"mine_icon_collect") forState:0];
    [topicButton setTitle:@"话题" forState:0];
    topicButton.imagePosition = QMUIButtonImagePositionTop;
    topicButton.spacingBetweenImageAndTitle = 5;
    [topicButton setTitleColor:UIColorBlack forState:0];
    topicButton.titleLabel.font = UIFontMake(16);
    [topicButton addTarget:self action:@selector(topicClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:topicButton];
    
    collectButton.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .widthIs(self.width / 3)
    .heightIs(70);
    
    trackButton.sd_layout
    .leftSpaceToView(collectButton, 0)
    .topEqualToView(self)
    .widthIs(self.width / 3)
    .heightIs(70);
    
    topicButton.sd_layout
    .leftSpaceToView(trackButton, 0)
    .topEqualToView(self)
    .widthIs(self.width / 3)
    .heightIs(70);
}

-(void)collectClick
{
    if ([self respondsToSelector:@selector(collectClick)]) {
        self.selectCollectBlock();
    }
}

-(void)trackClick
{
    if ([self respondsToSelector:@selector(trackClick)]) {
        self.selectTrackBlock();
    }
}

-(void)topicClick
{
    if ([self respondsToSelector:@selector(topicClick)]) {
        self.selectTopicBlock();
    }
}

@end
