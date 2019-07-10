//
//  ConditionView.h
//  STUDIES
//
//  Created by happyi on 2019/3/20.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol conditionViewDelegate <NSObject>

-(void)conditionViewDidSelectedIndex:(NSInteger)index;

@end

@interface ConditionView : UIView<UITableViewDelegate, UITableViewDataSource>

//已选择条件
@property(nonatomic, strong) NSString *condition;
//列表
@property(nonatomic, strong) UITableView *mainTableView;
//数据
@property(nonatomic, strong) NSArray *dataSourceArray;
//选择条件
@property(nonatomic, weak) id<conditionViewDelegate>delegate ;

-(instancetype)initWithFrame:(CGRect)frame condition:(NSString *)condition;

@end

NS_ASSUME_NONNULL_END
