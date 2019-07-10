//
//  YYTextBindingParser.h
//  STUDIES
//
//  Created by happyi on 2019/6/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYTextBindingParser : NSObject<YYTextParser>
@property(nonatomic, strong) NSRegularExpression *regex;
@end

