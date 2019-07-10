//
//  LineHotPlaceViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineHotPlaceViewController.h"
#import "HomeSearchView.h"
#import "LineSearchViewController.h"
#import "LineDestinationModel.h"
#import "LinePlaceDetailViewController.h"

@interface LineHotPlaceViewController ()

/** 搜索 */
@property(nonatomic, strong) HomeSearchView *searchView;

@end

@implementation LineHotPlaceViewController

#pragma mark - lazy
-(HomeSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[HomeSearchView alloc] initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH - 60, 40)];
        _searchView.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
        _searchView.searchLabel.text = @"搜索线路";
        __weak __typeof (self)weakSelf = self;
        _searchView.tapSearch = ^{
            [weakSelf.navigationController pushViewController:[LineSearchViewController new] animated:YES];
        };
    }
    
    return _searchView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createButtonsView];
    
    [self.navView addSubview:self.searchView];

    _searchView.sd_layout
    .leftSpaceToView(self.navView, 50)
    .rightSpaceToView(self.navView, 30)
    .centerYEqualToView(self.navView)
    .heightIs(35);
}

#pragma mark - 创建按钮s
-(void)createButtonsView
{
    QMUILabel *tips = [MyTools labelWithText:@"热门目的地" textColor:UIColorBlack textFont:UIFontBoldMake(20) textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:tips];
    
    tips.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight + 20)
    .widthIs(150)
    .heightIs(30);
    
    UIView *container = [UIView new];
    [self.view addSubview:container];
    
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < _hotArray.count; i ++) {
        LineDestinationModel *model = _hotArray[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.name forState:0];
        [button setTitleColor:UIColorMakeWithHex(@"91CEC0") forState:0];
        [button setTitleColor:UIColorWhite forState:UIControlStateSelected];
        [button setBackgroundColor:UIColorWhite];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = UIFontMake(18);
        button.tag = i + 1000;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 5;
        button.layer.borderColor = UIColorMakeWithHex(@"91CEC0").CGColor;
        [container addSubview:button];
        [temp addObject:button];
        button.sd_layout.autoHeightRatio(0.4);
        
    }
    
    [container setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:3 itemWidth:SCREEN_WIDTH / 4 + 10 verticalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
    
    container.sd_layout
    .topSpaceToView(tips, 10)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20);
    
    if (_hotArray.count == 0) {
        tips.hidden = YES;
    }
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
        
        UIButton *button = (UIButton *)[self.view viewWithTag:1000 + i];
        button.selected = NO;
        [button setBackgroundColor:UIColorWhite];
        
    }
    
    LineDestinationModel *model = _hotArray[sender.tag - 1000];
    LinePlaceDetailViewController *vc = [LinePlaceDetailViewController new];
    vc.dId = model.dId;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
