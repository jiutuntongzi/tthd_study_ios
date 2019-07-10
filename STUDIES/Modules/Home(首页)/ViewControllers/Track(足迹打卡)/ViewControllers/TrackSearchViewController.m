//
//  TrackSearchViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TrackSearchViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <CoreLocation/CoreLocation.h>

@interface TrackSearchViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, BMKSuggestionSearchDelegate, UISearchBarDelegate, BMKPoiSearchDelegate, CLLocationManagerDelegate>
/** 搜索栏 */
@property(nonatomic, strong) UISearchBar *mySearchBar;
/** 主视图 */
@property(nonatomic, strong) UITableView *mainTableView;
/** Search类 */
@property(nonatomic, strong) BMKSuggestionSearch *search;
/** POISearch类 */
@property(nonatomic, strong) BMKPoiSearch *poiSearch;
/** POI数据 */
@property(nonatomic, strong) NSMutableArray <BMKPoiInfo *> *poiList;
/** 关键词 */
@property(nonatomic, strong) NSString *keyword;
/** 定位 */
@property(nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation TrackSearchViewController

#pragma mark - lazy
-(UISearchBar *)mySearchBar
{
    if (!_mySearchBar) {
        _mySearchBar = [[UISearchBar alloc] init];
        _mySearchBar.placeholder = @"请输入关键字";
        _mySearchBar.searchBarStyle = UISearchBarStyleDefault;
        _mySearchBar.barStyle = UISearchBarStyleDefault;
        _mySearchBar.backgroundImage = [[UIImage alloc] init];
        _mySearchBar.delegate = self;
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
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.emptyDataSetSource = self;
    }
    
    return _mainTableView;
}

-(BMKSuggestionSearch *)search
{
    if (!_search) {
        _search = [[BMKSuggestionSearch alloc] init];
        _search.delegate = self;
    }
    
    return _search;
}

-(BMKPoiSearch *)poiSearch
{
    if (!_poiSearch) {
        _poiSearch = [[BMKPoiSearch alloc] init];
        _poiSearch.delegate = self;
    }
    
    return _poiSearch;
}

-(NSMutableArray<BMKPoiInfo *> *)poiList
{
    if (!_poiList) {
        _poiList = [NSMutableArray array];
    }
    
    return _poiList;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _search.delegate = nil;
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
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, BaseStatusViewHeight + 5)
    .rightSpaceToView(self.view, 60)
    .heightIs(BaseNavViewHeight - 10);
    
    _mainTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 0);
    
    [self startLocate];
}

- (void)startLocate{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.delegate = self;
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
    }
}

#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            NSLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
                self.city = city;
            }else if (error == nil && [array count] == 0){
                NSLog(@"No results were returned.");
            }else if (error != nil){
                NSLog(@"An error occurred = %@", error);
            }
            self.city = city;
            if (city.length > 0) {
                [manager stopUpdatingLocation];
            }
        }
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
     
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
     if (error.code == kCLErrorDenied) {
         // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
     }
}
     

#pragma mark - 返回
-(void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *text = @"暂无当前搜索信息";
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

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.poiList removeAllObjects];
    self.keyword = searchBar.text;
//    BMKSuggestionSearchOption *option = [[BMKSuggestionSearchOption alloc] init];
//    option.cityname = @"长沙";
//    option.keyword = searchBar.text;
//
//    BOOL flag = [self.search suggestionSearch:option];
//    if (flag) {
//        NSLog(@"Sug检索发送成功");
//    }  else  {
//        NSLog(@"Sug检索发送失败");
//    }
    
    BMKPOICitySearchOption *cityOption = [[BMKPOICitySearchOption alloc] init];
    cityOption.keyword = searchBar.text;
    cityOption.city = self.city.length == 0 ? @"长沙市" : self.city;
    cityOption.isCityLimit = NO;
    cityOption.scope = BMK_POI_SCOPE_DETAIL_INFORMATION;
//    cityOption.filter = filter;
    cityOption.pageIndex = 0;
    cityOption.pageSize = 20;

    BOOL flag = [self.poiSearch poiSearchInCity:cityOption];
    if(flag) {
        NSLog(@"POI城市内检索成功");
    } else {
        NSLog(@"POI城市内检索失败");
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        [_poiList removeAllObjects];
        [_mainTableView reloadData];
    }
}

#pragma mark - BMKSuggestionSearchDelegate
/**
 *返回suggestion搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionSearchResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {

    }
    else {
        NSLog(@"检索失败");
    }
}

#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误码，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"检索结果返回成功：%@",poiResult.poiInfoList);
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
            NSLog(@"%@\n%@", info.name, info.address);
            _poiList = [poiResult.poiInfoList mutableCopy];
            [_mainTableView reloadData];
        }
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        NSLog(@"检索词有歧义");
    } else {
        NSLog(@"其他检索结果错误码相关处理");
    }
}

#pragma mark - TableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _poiList.count;
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
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    QMUILabel *name = [MyTools labelWithText:_poiList[indexPath.row].name textColor:UIColorBlack textFont:UIFontMake(17) textAlignment:NSTextAlignmentLeft];
    [cell.contentView addSubview:name];

    NSRange range = [_poiList[indexPath.row].name rangeOfString:self.keyword options:NSCaseInsensitiveSearch];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_poiList[indexPath.row].name];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#09BDB4") range:range];
    name.attributedText = string;
    
    UIImageView *icon = [UIImageView new];
    icon.image = UIImageMake(@"track_icon_location");
    [cell.contentView addSubview:icon];
    
    QMUILabel *address = [MyTools labelWithText:_poiList[indexPath.row].address textColor:UIColorMakeWithHex(@"#666666") textFont:UIFontMake(15) textAlignment:NSTextAlignmentLeft];
    address.numberOfLines = 0;
    [cell.contentView addSubview:address];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorGray;
    [cell.contentView addSubview:line];
    
    name.sd_layout
    .leftSpaceToView(cell.contentView, 30)
    .topSpaceToView(cell.contentView, 10)
    .rightSpaceToView(cell.contentView, 15)
    .autoHeightRatio(0);
    
    icon.sd_layout
    .leftSpaceToView(cell.contentView, 15)
    .topSpaceToView(name, 10)
    .widthIs(10)
    .heightIs(15);
    
    address.sd_layout
    .leftEqualToView(name)
    .centerYEqualToView(icon)
    .rightEqualToView(name)
    .heightIs(20);
    
    line.sd_layout
    .leftEqualToView(cell.contentView)
    .rightEqualToView(cell.contentView)
    .topSpaceToView(icon, 15)
    .heightIs(0.5);
    
    [cell setupAutoHeightWithBottomView:line bottomMargin:5];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *info = _poiList[indexPath.row];
    self.selectedLocationBlock(info);
    [self.navigationController popViewControllerAnimated:YES];
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
