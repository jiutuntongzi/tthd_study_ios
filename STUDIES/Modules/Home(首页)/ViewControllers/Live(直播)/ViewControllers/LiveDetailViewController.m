//
//  LiveDetailViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/15.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LiveDetailViewController.h"

@interface LiveDetailViewController ()

@end

@implementation LiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"直播详情";
    
    QMUILabel *label = [MyTools labelWithText:@"直播正在搭建中，敬请期待" textColor:UIColorGray textFont:UIFontMake(16) textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    label.size = CGSizeMake(SCREEN_WIDTH, 80);
    label.center = self.view.center;
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
