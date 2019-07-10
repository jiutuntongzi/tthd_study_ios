//
//  InteractViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "InteractViewController.h"
#import "HomeCallModel.h"
#import "InteractDetailViewController.h"

@interface InteractViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 搜索栏 */
@property(nonatomic, strong) UISearchBar *mySearchBar;
/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 进行中按钮 */
@property(nonatomic, strong) QMUIButton *stillButton;
/** 已结束按钮 */
@property(nonatomic, strong) QMUIButton *finishButton;

@end

@implementation InteractViewController

#pragma mark - lazy
-(UISearchBar *)mySearchBar
{
    if (!_mySearchBar) {
        _mySearchBar = [[UISearchBar alloc] init];
        _mySearchBar.placeholder = @"请输入关键字";
        _mySearchBar.searchBarStyle = UISearchBarStyleDefault;
        _mySearchBar.barStyle = UISearchBarStyleDefault;
        _mySearchBar.backgroundImage = [[UIImage alloc] init];
        UIView *backgroundView = [_mySearchBar subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];
        backgroundView.layer.cornerRadius = 18;
        backgroundView.clipsToBounds = YES;
    }
    
    return _mySearchBar;
}

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _mainTableView;
}

-(QMUIButton *)stillButton
{
    if (!_stillButton) {
        _stillButton = [[QMUIButton alloc] init];
        [_stillButton setBackgroundImage:UIImageMake(@"button_border.normal.png") forState:UIControlStateNormal];
        [_stillButton setBackgroundImage:UIImageMake(@"button_border.selected.png") forState:UIControlStateSelected];
        [_stillButton setTitle:@"进行中" forState:UIControlStateNormal];
        [_stillButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        [_stillButton setTitleColor:UIColorMakeWithHex(@"#34BCB4") forState:UIControlStateSelected];
        [_stillButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _stillButton.imagePosition = QMUIButtonImagePositionRight;
        _stillButton.spacingBetweenImageAndTitle = 10;
        _stillButton.titleLabel.font = UIFontMake(20);
        _stillButton.tag = 10001;
        _stillButton.selected = YES;
    }
    
    return _stillButton;
}

-(QMUIButton *)finishButton
{
    if (!_finishButton) {
        _finishButton = [QMUIButton new];
        _finishButton.titleLabel.font = UIFontMake(20);
        _finishButton.tag = 10002;
        [_finishButton setTitle:@"已完成" forState:UIControlStateNormal];
        [_finishButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        [_finishButton setTitleColor:UIColorMakeWithHex(@"#34BCB4") forState:UIControlStateSelected];
        [_finishButton setBackgroundImage:UIImageMake(@"button_border.normal.png") forState:UIControlStateNormal];
        [_finishButton setBackgroundImage:UIImageMake(@"button_border.selected.png") forState:UIControlStateSelected];
        [_finishButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.leftButton.hidden = YES;
    [self.rightButton setTitle:@"取消" forState:0];
    [self.rightButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.mySearchBar];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.stillButton];
    [self.view addSubview:self.finishButton];
    
    _stillButton.selected = YES;
    
    _mySearchBar.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, BaseStatusViewHeight + 5)
    .rightSpaceToView(self.view, 60)
    .heightIs(BaseNavViewHeight - 10);
    
    _stillButton.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseStatusViewHeight + BaseNavViewHeight)
    .widthIs(SCREEN_WIDTH / 2)
    .heightIs(48);
    
    _finishButton.sd_layout
    .rightSpaceToView(self.view, 0)
    .topEqualToView(_stillButton)
    .widthIs(SCREEN_WIDTH / 2)
    .heightIs(48);
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(_stillButton, 0)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
}

#pragma mark - 返回
-(void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Events
-(void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 10001) {
        _stillButton.selected = YES;
        _finishButton.selected = NO;
    }else{
        _stillButton.selected = NO;
        _finishButton.selected = YES;
    }
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LiveSearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    HomeCallModel *model = _dataArray[indexPath.row];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = UIImageMake(@"default1.jpg");
    imageView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 120);
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:UIImageMake(@"common_icon_placeholderImage")];
    [cell.contentView addSubview:imageView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCallModel *model = _dataArray[indexPath.row];
    InteractDetailViewController *vc = [InteractDetailViewController new];
    vc.url = model.url;
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
