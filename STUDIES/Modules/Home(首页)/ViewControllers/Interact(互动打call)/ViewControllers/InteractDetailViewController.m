//
//  InteractDetailViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/16.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "InteractDetailViewController.h"

@interface InteractDetailViewController ()

@end

@implementation InteractDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"打call详情";
    
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self.view addSubview:webView];
    
    webView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view, BaseNavViewHeight + BaseStatusViewHeight)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
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
