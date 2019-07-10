//
//  SearchHistoryView.m
//  STUDIES
//
//  Created by 花想容 on 2019/5/28.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "SearchHistoryView.h"

@implementation SearchHistoryView

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
    QMUILabel *title = [MyTools labelWithText:@"历史记录" textColor:UIColorGray textFont:UIFontMake(16) textAlignment:NSTextAlignmentLeft];
    [self addSubview:title];
    
    QMUIButton *clearButton = [QMUIButton new];
    [clearButton setImage:nil forState:0];
    [clearButton setTitle:@"清除" forState:0];
    clearButton.imagePosition = QMUIButtonImagePositionLeft;
    clearButton.spacingBetweenImageAndTitle = 5;
    [clearButton setTitleColor:UIColorGray forState:0];
    clearButton.titleLabel.font = UIFontMake(15);
    [self addSubview:clearButton];
    
    UIView *containerView = [UIView new];
    [self addSubview:containerView];
    
    NSArray *array = @[@"长沙", @"乌鲁木齐", @"哈萨克斯坦", @"新疆维吾尔族自治区", @"张家界"];
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        UIButton *button = [UIButton new];
        [button setTitle:array[i] forState:0];
        [button setTitleColor:UIColorMakeWithHex(@"91CEC0") forState:0];
        [button setTitleColor:UIColorWhite forState:UIControlStateSelected];
        [button setBackgroundColor:UIColorWhite];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = UIFontMake(18);
        button.tag = i + 1000;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 5;
        button.layer.borderColor = UIColorMakeWithHex(@"91CEC0").CGColor;
        [containerView addSubview:button];
        [temp addObject:button];
        button.sd_layout.autoHeightRatio(0.4);
    }
    
    [containerView setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:3 itemWidth:SCREEN_WIDTH / 4 + 10 verticalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
    
    title.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, 10)
    .widthIs(120)
    .heightIs(25);
    
    clearButton.sd_layout
    .rightSpaceToView(self, 10)
    .centerYEqualToView(title)
    .widthIs(80)
    .heightIs(25);
    
    containerView.sd_layout
    .topSpaceToView(title, 20)
    .leftSpaceToView(self, 20)
    .rightSpaceToView(self, 20);
}

-(void)buttonClicked:(UIButton *)sender
{
    for (int i = 0; i < 8; i ++) {
        if (sender.tag == 1000 + i) {
            sender.selected = YES;
            sender.layer.borderWidth = 1;
            [sender setBackgroundColor:UIColorMakeWithHex(@"91CEC0")];
            
            continue;
        }
        
        UIButton *button = (UIButton *)[self viewWithTag:1000 + i];
        button.selected = NO;
        [button setBackgroundColor:UIColorWhite];
        
    }
}

@end
