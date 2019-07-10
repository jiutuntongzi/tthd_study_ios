//
//  VideoPlayViewController.m
//  STUDIES
//
//  Created by happyi on 2019/6/12.
//  Copyright © 2019 happyi. All rights reserved.
//

#import "VideoPlayViewController.h"
#import <ZFPlayer/ZFPlayerController.h>
#import <ZFPlayerView.h>
#import <ZFAVPlayerManager.h>
#import <ZFPlayerControlView.h>
@interface VideoPlayViewController ()

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _controlView = [ZFPlayerControlView new];
    _controlView.fastViewAnimated = YES;
    _controlView.effectViewShow = NO;
    _controlView.prepareShowLoading = YES;
    _controlView.portraitControlView.fullScreenBtn.hidden = YES;
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    _player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:self.view];
    _player.controlView = _controlView;
    _player.allowOrentitaionRotation = NO;
    @weakify(self)
    _player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        @strongify(self)
        [self cancelClick];
    };
    [_player enterFullScreen:NO animated:NO];
    playerManager.assetURL = [NSURL URLWithString:_videoUrl];
    
    QMUIButton *button = [QMUIButton new];
    [button setImage:UIImageMake(@"teacher_icon_close") forState:0];
    [button addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(10, BaseStatusViewHeight, 40, 40);
    [self.view addSubview:button];
}

-(void)cancelClick
{
    [self hideWithAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
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
