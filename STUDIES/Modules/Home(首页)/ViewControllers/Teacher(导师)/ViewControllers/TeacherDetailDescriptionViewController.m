//
//  TeacherDescriptionViewController.m
//  STUDIES
//
//  Created by happyi on 2019/3/25.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "TeacherDetailDescriptionViewController.h"

@interface TeacherDetailDescriptionViewController ()

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation TeacherDetailDescriptionViewController

#pragma mark - lazy
-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        [_webView loadHTMLString:self.htmlString baseURL:nil];
    }
    
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorWhite;
    
    [self.view addSubview:self.webView];
    
    _webView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 10)
    .widthIs(SCREEN_WIDTH)
    .bottomSpaceToView(self.view, 10);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.webView.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
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
