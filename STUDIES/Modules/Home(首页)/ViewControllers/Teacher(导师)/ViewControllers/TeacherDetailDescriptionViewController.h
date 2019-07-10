//
//  TeacherDescriptionViewController.h
//  STUDIES
//
//  Created by happyi on 2019/3/25.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagerView.h>

@interface TeacherDetailDescriptionViewController : UIViewController<JXPagerViewListViewDelegate>

/** 介绍的内容 */
@property (nonatomic, strong) NSString *htmlString;

@end

