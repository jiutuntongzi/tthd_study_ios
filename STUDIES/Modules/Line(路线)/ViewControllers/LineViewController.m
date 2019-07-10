//
//  LineViewController.m
//  STUDIES
//
//  Created by happyi on 2019/3/11.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineViewController.h"
#import "LineBannerCell.h"
#import "LineHotPlaceCell.h"
#import "LineHotPlaceViewController.h"
#import "LinePlaceDetailViewController.h"
#import "LineHotCell.h"
#import "LineDetailNewViewController.h"
#import "LineRequestManagerClass.h"
#import "LineThemeModel.h"
#import "LineThemeItemModel.h"
#import "LineDestinationModel.h"
#import "CommonRequestManagerClass.h"
#import "BannerModel.h"
#import "LineSearchViewController.h"
#import "LoginViewController.h"

@interface LineViewController ()<UITableViewDelegate, UITableViewDataSource, RequestManagerDelegate>

/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** 路线请求类 */
@property(nonatomic, strong) LineRequestManagerClass *lineRequestManager;
/** 公共请求类 */
@property(nonatomic, strong) CommonRequestManagerClass *commonRequestManager;
/** 数据 */
@property(nonatomic, strong) NSMutableArray <LineThemeModel *> *themeArray;
@property(nonatomic, strong) NSMutableArray <LineDestinationModel *> *destinationArray;
@property(nonatomic, strong) NSMutableArray <BannerModel *> *bannerArray;
@end

@implementation LineViewController

#pragma mark - lazy
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[LineBannerCell class]
               forCellReuseIdentifier:NSStringFromClass([LineBannerCell class])];
        [_mainTableView registerClass:[LineHotPlaceCell class]
               forCellReuseIdentifier:NSStringFromClass([LineHotPlaceCell class])];
        [_mainTableView registerClass:[LineHotCell class] forCellReuseIdentifier:NSStringFromClass([LineHotCell class])];
    }
    
    return _mainTableView;
}

-(LineRequestManagerClass *)lineRequestManager
{
    if (!_lineRequestManager) {
        _lineRequestManager = [[LineRequestManagerClass alloc] init];
        _lineRequestManager.delegate = self;
    }
    
    return _lineRequestManager;
}

-(CommonRequestManagerClass *)commonRequestManager
{
    if (!_commonRequestManager) {
        _commonRequestManager = [[CommonRequestManagerClass alloc] init];
        _commonRequestManager.delegate = self;
    }
    
    return _commonRequestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"路线";
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    
    [self.view addSubview:self.mainTableView];
    
    _themeArray = [NSMutableArray array];
    _destinationArray = [NSMutableArray array];
    _bannerArray = [NSMutableArray array];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, -44)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, BaseTabBarViewHeight);
    
    [self.lineRequestManager getHotThemeWithRequestName:GET_LINE_HOTTHEME];
    [self.lineRequestManager getHotDestinationWithType:@"1" requestName:GET_LINE_HOTDESTINATION];
    [self.commonRequestManager getBannerWithPosition:BannerPosition_route requestName:GET_BANNER];
}

-(void)moreClicked
{
    LineHotPlaceViewController *vc = [LineHotPlaceViewController new];
    vc.hotArray = _destinationArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 处理热门主题的数据
-(void)handleHotThemeDataWithData:(NSArray *)dataArray
{
    for (NSDictionary *dict in dataArray) {
        LineThemeModel *tModel = [[LineThemeModel alloc] initModelWithDict:dict];
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"path"]) {
            LineThemeItemModel *iModel = [[LineThemeItemModel alloc] initModelWithDict:dic];
            [itemArray addObject:iModel];
        }
        tModel.path = [itemArray copy];
        [_themeArray addObject:tModel];
    }
    
    [_mainTableView reloadData];
}

-(void)handleHotDestinationDataWithData:(NSArray *)dataArray
{
    for (NSDictionary *dict in dataArray) {
        LineDestinationModel *model = [[LineDestinationModel alloc] initModelWithDict:dict];
        [_destinationArray addObject:model];
    }
    [_mainTableView reloadData];
}

-(void)handleBannerDataWithData:(NSArray *)dataArray
{
    for (NSDictionary *dict in dataArray) {
        BannerModel *model = [[BannerModel alloc] initModelWithDict:dict];
        [_bannerArray addObject:model];
    }
    [_mainTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - RequestManagerDelegate
-(void)requestSuccess:(id)info requestName:(NSString *)requestName
{
    if ([requestName isEqualToString:GET_LINE_HOTTHEME]) {
        [self handleHotThemeDataWithData:info];
    }
    if ([requestName isEqualToString:GET_LINE_HOTDESTINATION]) {
        [self handleHotDestinationDataWithData:info];
    }
    if ([requestName isEqualToString:GET_BANNER]) {
        [self handleBannerDataWithData:info];
    }
}

-(void)requestFailure:(id)info requestName:(NSString *)requestName
{
    
}

#pragma mark - TableView Delegate & DataSource
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 80) {
        [self.view bringSubviewToFront:self.statusView];
        [self.view bringSubviewToFront:self.navView];
    }else{
        [self.view bringSubviewToFront:_mainTableView];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return _themeArray.count;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:_mainTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2 || section == 5 || section == 6 || section == 7 || section == 8) {
        return 30;
    }
    
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = BaseBackgroundColor;
    view.userInteractionEnabled = YES;
    
    if (section == 1 || section == 2 || section == 5 || section == 6 || section == 7 || section == 8) {
        
        
        NSArray *titles = @[@"热门目的地", @"当季热门", @"互动打call", @"金牌导师", @"热门路线", @"精选游记"];
        
        QMUILabel *title = [MyTools labelWithText:titles[section - 1] textColor:UIColorBlack textFont:UIFontMake(18) textAlignment:NSTextAlignmentLeft];
        [view addSubview:title];
        
        QMUIButton *more = [QMUIButton new];
        [more setTitle:@"更多 +" forState:0];;
        [more setTitleColor:UIColorMakeWithHex(@"#999999") forState:0];
        more.titleLabel.font = UIFontMake(16);
        [more addTarget:self action:@selector(moreClicked) forControlEvents:UIControlEventTouchUpInside];
        more.userInteractionEnabled = YES;
        [view addSubview:more];
        
        title.sd_layout
        .leftSpaceToView(view, 10)
        .topEqualToView(view)
        .bottomSpaceToView(view, 0)
        .widthIs(100);
        
        more.sd_layout
        .rightSpaceToView(view, 10)
        .centerYEqualToView(view)
        .widthIs(60)
        .heightIs(30);
        
        return view;
    }
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof (self)weakSelf = self;
    if (indexPath.section == 0) {
        static NSString *identifier = @"LineBannerCell";
        LineBannerCell *cell = (LineBannerCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.dataArray = _bannerArray;
        cell.searchView.tapSearch = ^{
            [weakSelf.navigationController pushViewController:[LineSearchViewController new] animated:YES];
        };
        return cell;
    }
    
    if (indexPath.section == 1) {
        static NSString *identifier = @"LineHotPlaceCell";
        LineHotPlaceCell *cell = (LineHotPlaceCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.dataArray = _destinationArray;
        cell.selectItemBlock = ^(NSString *dId) {
            LinePlaceDetailViewController *vc = [LinePlaceDetailViewController new];
            vc.dId = dId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }

    if (indexPath.section == 2) {
        static NSString *identifier = @"LineHotCell";
        LineHotCell *cell = (LineHotCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[LineHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.model = _themeArray[indexPath.row];
        cell.selectedDestinationBlock = ^(NSString *dId) {
            LinePlaceDetailViewController *vc = [LinePlaceDetailViewController new];
            vc.dId = dId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.selectedLineBlock = ^(NSString *lineId, NSString *tutorId) {
            if (!Token) {
                [self showLogin];
                return;
            }
            LineDetailNewViewController *vc = [LineDetailNewViewController new];
            vc.lineId = lineId;
            vc.tutorId = tutorId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)showLogin
{
    LoginViewController *loginVC = [LoginViewController new];
    loginVC.loginSuccessBlock = ^{
        
    };
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [vc setNavigationBarHidden:YES];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {`
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
