//
//  HomeSearchView.m
//  STUDIES
//
//  Created by happyi on 2019/3/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "HomeSearchView.h"

@implementation HomeSearchView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 18;
        self.backgroundColor = UIColorWhite;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearchView)];
        [self addGestureRecognizer:tgr];
        
        [self setSubViews];
    }
    return self;
}

#pragma mark - 子视图
-(void)setSubViews
{
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = UIImageMake(@"home_icon_search");
    [self addSubview:icon];
    
    _searchLabel = [MyTools labelWithText:@"请输入关键字搜索" textColor:UIColorGray textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self addSubview:_searchLabel];
    
    
    
    _searchLabel.sd_layout
    .leftSpaceToView(self, 15)
    .topEqualToView(self)
    .widthIs(150)
    .bottomEqualToView(self);
    
    icon.sd_layout
    .rightSpaceToView(self, 15)
    .centerYEqualToView(self)
    .widthIs(25)
    .heightEqualToWidth();
}

#pragma mark - 点击搜索栏
-(void)tapSearchView
{
    if (self.tapSearch) {
        self.tapSearch();
    }
}

-(void)setSearchLabel:(QMUILabel *)searchLabel
{
    self.searchLabel = searchLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
