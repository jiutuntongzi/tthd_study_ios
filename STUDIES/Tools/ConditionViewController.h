//
//  TeacherConditionViewController.h
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "QMUIModalPresentationViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConditionViewController : QMUIModalPresentationViewController

/** 选择分类的回调 */
@property (nonatomic, copy) void(^selectedTypeBlock)(id model);
/** 数据源 */
@property (nonatomic, strong) NSArray *dataSourceArray;
/** 已选择的分类 */
@property (nonatomic, strong) id selectedModel;

@end

NS_ASSUME_NONNULL_END
