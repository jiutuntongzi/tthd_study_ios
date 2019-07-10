//
//  Track1ViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/7.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "Track1ViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "HomeSearchView.h"
#import "TrackSearchViewController.h"
#import "TrackSubmitViewController.h"
@interface Track1ViewController ()<BMKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, BMKGeoCodeSearchDelegate, BMKLocationManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** 地图 */
@property (nonatomic, strong) BMKMapView *mapView;
/** 主视图 */
@property (nonatomic, strong) UITableView *mainTableView;
/** 大头针标注 */
@property (nonatomic, strong) BMKPointAnnotation *annotation;
/** 地理编码类 */
@property (nonatomic, strong) BMKGeoCodeSearch *codeSearch;
/** 定位类 */
@property (nonatomic, strong) BMKLocationManager *locationManager;
/** 当前位置的周边信息 */
@property (nonatomic, strong) NSMutableArray <BMKPoiInfo *> *poiList;
/** 搜索 */
@property (nonatomic, strong) HomeSearchView *searchView;
/** 确定按钮 */
@property (nonatomic, strong) QMUIButton *sureButton;
/** 当前城市编码 */
@property (nonatomic, strong) NSString *city;
/** 选择的地址 */
@property (nonatomic, strong) BMKPoiInfo *selectedInfo;

@end

@implementation Track1ViewController

#pragma mark - lazy
-(BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.delegate = self;
        _mapView.showMapScaleBar = YES;
        _mapView.zoomLevel = 18;
        
        BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
        displayParam.isRotateAngleValid = YES;
        displayParam.isAccuracyCircleShow = NO;
        [_mapView updateLocationViewWithParam:displayParam];
        
    }
    
    return _mapView;
}

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.emptyDataSetDelegate = self;
    }
    
    return _mainTableView;
}

-(BMKPointAnnotation *)annotation
{
    if (!_annotation) {
        _annotation = [[BMKPointAnnotation alloc] init];
    }
    
    return _annotation;
}

-(BMKGeoCodeSearch *)codeSearch
{
    if (!_codeSearch) {
        _codeSearch = [[BMKGeoCodeSearch alloc] init];
        _codeSearch.delegate = self;
    }
    
    return _codeSearch;
}

-(NSMutableArray<BMKPoiInfo *> *)poiList
{
    if (!_poiList) {
        _poiList = [NSMutableArray array];
    }
    
    return _poiList;
}

-(BMKLocationManager *)locationManager
{
    if (!_locationManager) {
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        //_locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    
    return _locationManager;
}

-(HomeSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[HomeSearchView alloc] initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH - 120, 40)];
        _searchView.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
        _searchView.searchLabel.text = @"搜索具体位置";
        __weak __typeof (self)weakSelf = self;
        _searchView.tapSearch = ^{
            TrackSearchViewController *vc = [TrackSearchViewController new];
            vc.city = weakSelf.city;
            vc.selectedLocationBlock = ^(BMKPoiInfo * _Nonnull info) {
                weakSelf.selectedInfo = info;
                [weakSelf.mapView setCenterCoordinate:info.pt animated:NO];
                TrackSubmitViewController *trackVC = [TrackSubmitViewController new];
                trackVC.selectedInfo = info;
                [weakSelf presentViewController:trackVC animated:YES completion:nil];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    
    return _searchView;
}

-(QMUIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [QMUIButton new];
        [_sureButton setTitle:@"确定" forState:0];
        [_sureButton setTitleColor:UIColorBlack forState:0];
        [_sureButton setBackgroundColor:UIColorMakeWithHex(@"#FEDB5C")];
        _sureButton.titleLabel.font = UIFontMake(17);
        _sureButton.layer.cornerRadius = 6;
        [_sureButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sureButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"位置";
    
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.mapView];
    [self.navView addSubview:self.sureButton];
    [self.navView addSubview:self.searchView];
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .heightIs(SCREEN_HEIGHT / 3);
    
    _mapView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .bottomSpaceToView(_mainTableView, 0)
    .widthIs(SCREEN_WIDTH);
    
    _sureButton.sd_layout
    .centerYEqualToView(self.navView)
    .rightSpaceToView(self.navView, 15)
    .heightIs(30)
    .widthIs(60);
    
    _searchView.sd_layout
    .leftSpaceToView(self.navView, 50)
    .rightSpaceToView(_sureButton, 15)
    .centerYEqualToView(self.navView)
    .heightIs(35);
}

-(void)rightButtonClicked
{
    [self.navigationController pushViewController:[TrackSubmitViewController new] animated:YES];
}

#pragma mark - BMKMapViewDelegate
//拖动地图
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //移动标注
    self.annotation.coordinate = _mapView.centerCoordinate;
    //地理反编码
    BMKReverseGeoCodeSearchOption *reverseOption=[[BMKReverseGeoCodeSearchOption alloc] init];
    reverseOption.location = mapView.centerCoordinate;
    [self.codeSearch reverseGeoCode:reverseOption];
}

//地图加载完成
-(void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    [_mapView addAnnotation:self.annotation];
    //定位
    __weak __typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在定位当前位置"];
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"定位失败"];
            return;
        }
        [SVProgressHUD dismiss];
        [weakSelf.mapView setCenterCoordinate:location.location.coordinate animated:YES];
        NSLog(@"当前定位位置%@", location.rgcData.locationDescribe);
    }];
}

#pragma mark - BMKGeoCodeSearchDelegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%@", result.sematicDescription);
    
    self.city = result.addressDetail.city;
    [self.poiList removeAllObjects];
    self.poiList = [result.poiList mutableCopy];
    [_mainTableView reloadData];
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"提示";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"当前定位地点无周边地址信息，请尝试移动地图，切换地位地点";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.poiList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    QMUILabel *label = [MyTools labelWithText:_poiList[indexPath.row].name textColor:UIColorBlack textFont:UIFontMake(17) textAlignment:NSTextAlignmentCenter];
    label.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [cell.contentView addSubview:label];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorGray;
    line.frame = CGRectMake(0, 50 - 0.5, SCREEN_WIDTH, 0.5);
    [cell.contentView addSubview:line];
    
    if (indexPath.row == 0) {
        label.textColor = UIColorMakeWithHex(@"#09BDB4");
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *info = _poiList[indexPath.row];
    [_mapView setCenterCoordinate:info.pt animated:YES];
    
    TrackSubmitViewController *trackVC = [TrackSubmitViewController new];
    trackVC.selectedInfo = info;
    trackVC.city = self.city;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:trackVC];
    [nav setNavigationBarHidden:YES animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
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
