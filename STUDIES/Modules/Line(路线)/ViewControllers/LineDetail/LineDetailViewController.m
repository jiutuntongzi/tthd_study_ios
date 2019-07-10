//
//  LineDetailViewController.m
//  STUDIES
//
//  Created by happyi on 2019/5/9.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "LineDetailViewController.h"

@interface LineDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/** webView */
@property (nonatomic, strong) UIWebView *webView;
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LineDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorWhite;
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = UIColorRed;
    [self.view addSubview:_scrollView];
    
    [self initSegmentedControl];
}

#pragma mark - 创建顶部标签栏
-(void)initSegmentedControl
{
    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"路线介绍",@"购买须知", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:titleArray];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = UIColorMakeWithHex(@"#91CEC0");
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    [segmentedControl addTarget:self
                         action:@selector(segmentAction:)
               forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:segmentedControl];
    
    segmentedControl.sd_layout
    .leftSpaceToView(self.view, 50)
    .rightSpaceToView(self.view, 50)
    .topSpaceToView(self.view, 20)
    .heightIs(40);
    
    [self addSubViewWith:segmentedControl];
}

#pragma mark - 子视图
-(void)addSubViewWith:(UIView *)view
{
    _webView = [[UIWebView alloc] init];
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_webView];
    
    _webView.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 20);
}

-(void)setDetailModel:(LineDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    [_webView loadHTMLString:detailModel.intro baseURL:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        
//        CGPoint point = [change[@"new"] CGPointValue];
//        
//        CGFloat height = point.y;
//        NSLog(@"point.y---%f",height);
//        
//        CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
//        
//        CGFloat webHeight = fittingSize.height;
//        
////        if (webHeight > SCREEN_HEIGHT * 2 / 3) {
////            webHeight = SCREEN_HEIGHT;
////        }
//
////        _webView.sd_layout.heightIs(webHeight);
//    }
}

#pragma mark - segmentedControl Method
-(void)segmentAction:(UISegmentedControl *)Seg{
    if (Seg.selectedSegmentIndex == 0) {
        [_webView loadHTMLString:_detailModel.intro baseURL:nil];
    }else{
        [_webView loadHTMLString:_detailModel.notice baseURL:nil];
    }
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return _webView.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
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
