//
//  LinePagerViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LinePagerViewController.h"
#import "JXPagerListRefreshView.h"
#import "JXCategoryView.h"
@interface LinePagerViewController ()

@end

@implementation LinePagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isNeedHeader = YES;
    self.isNeedFooter = NO;
}

-(JXPagerView *)preferredPagingView
{
    return [[JXPagerListRefreshView alloc] initWithDelegate:self];
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
