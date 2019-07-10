//
//  LiveSearchViewController.m
//  STUDIES
//
//  Created by happyi on 2019/4/16.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LiveSearchViewController.h"
#import "LiveSearchCell.h"
#import "LiveDetailViewController.h"

@interface LiveSearchViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 搜索栏 */
@property(nonatomic, strong) UISearchBar *mySearchBar;
/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;

@end

@implementation LiveSearchViewController

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
        [_mainTableView registerClass:[LiveSearchCell class]
               forCellReuseIdentifier:NSStringFromClass([LiveSearchCell class])];
    }
    
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.leftButton.hidden = YES;
    [self.rightButton setTitle:@"取消" forState:0];
    [self.rightButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.mySearchBar];
    [self.view addSubview:self.mainTableView];
    
    _mySearchBar.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, BaseStatusViewHeight + 5)
    .rightSpaceToView(self.view, 60)
    .heightIs(BaseNavViewHeight - 10);
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
}

#pragma mark - 返回
-(void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LiveSearchCell";
    LiveSearchCell *cell = (LiveSearchCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[LiveDetailViewController new] animated:YES];
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
