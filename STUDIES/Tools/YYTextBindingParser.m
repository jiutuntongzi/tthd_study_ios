//
//  YYTextBindingParser.m
//  STUDIES
//
//  Created by happyi on 2019/6/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "YYTextBindingParser.h"

@implementation YYTextBindingParser

- (instancetype)init {
    self = [super init];
    NSString *atPattern = @"@[\\S]*";
    NSString *topicPattern = @"#(.*?)#";
    NSString *notePattern = @"《(.*?)》";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@", atPattern, topicPattern, notePattern];
    
    self.regex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
    return self;
}
- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)range {
    __block BOOL changed = NO;
    [_regex enumerateMatchesInString:text.string options:NSMatchingWithoutAnchoringBounds range:text.rangeOfAll usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (!result) return;
        NSRange range = result.range;
        if (range.location == NSNotFound || range.length < 1) return;
        if ([text attribute:YYTextBindingAttributeName atIndex:range.location effectiveRange:NULL]) return;
        
        NSRange bindlingRange = NSMakeRange(range.location, range.length);
        YYTextBinding *binding = [YYTextBinding bindingWithDeleteConfirm:YES];
        [text setTextBinding:binding range:bindlingRange]; /// Text binding
        [text setColor:BaseNavBarColor range:bindlingRange];
        changed = YES;
    }];
    return changed;
}


@end
