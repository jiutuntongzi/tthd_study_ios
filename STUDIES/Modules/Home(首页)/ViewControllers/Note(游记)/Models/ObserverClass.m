//
//  ObserverClass.m
//  STUDIES
//
//  Created by happyi on 2019/6/4.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "ObserverClass.h"

@implementation ObserverClass

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

@end
