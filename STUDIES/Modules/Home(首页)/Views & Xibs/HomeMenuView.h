//
//  HomeMenuView.h
//  STUDIES
//
//  Created by happyi on 2019/4/22.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, ContentIndex) {
    Index_Submit       = 0,
    Index_Note ,
    Index_Recruit
};

@interface HomeMenuView : UIView

/** 按钮回掉 */
@property(nonatomic, copy) void(^menuBlock)(ContentIndex index);

@end

