//
//  TrackSearchViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/8.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrackSearchViewController : BaseViewController

/** 当前城市 */
@property(nonatomic, strong) NSString *city;
/** 选择的地点 */
@property(nonatomic, copy) void(^selectedLocationBlock)(BMKPoiInfo *info);

@end

NS_ASSUME_NONNULL_END
