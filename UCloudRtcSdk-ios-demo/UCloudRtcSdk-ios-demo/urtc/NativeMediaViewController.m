//
//  NativeMediaViewController.m
//  UCloudRtcSdk-ios-demo
//
//  Created by Tony on 2020/1/8.
//  Copyright © 2020 Tony. All rights reserved.
//

#import "NativeMediaViewController.h"
#import <AVKit/AVKit.h>

@interface NativeMediaViewController ()
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong)AVPlayerViewController *playerVC;
@end

@implementation NativeMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//        self.videoUrl =  [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
        NSString *tmpDir = NSTemporaryDirectory();
        self.videoUrl = [NSString stringWithFormat:@"%@test.mp4",tmpDir];
        NSLog(@"self.videoUrl==%@",self.videoUrl);
//        self.videoUrl = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
        /*
         因为是 http 的链接，所以要去 info.plist里面设置
         App Transport Security Settings
         Allow Arbitrary Loads  = YES
         */
        self.playerVC = [[AVPlayerViewController alloc] init];
        self.playerVC.player = [AVPlayer playerWithURL:[self.videoUrl hasPrefix:@"http"] ? [NSURL URLWithString:self.videoUrl]:[NSURL fileURLWithPath:self.videoUrl]];
//        self.playerVC.view.frame = self.view.bounds;
    self.playerVC.view.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40);
        self.playerVC.showsPlaybackControls = YES;
    //self.playerVC.entersFullScreenWhenPlaybackBegins = YES;//开启这个播放的时候支持（全屏）横竖屏哦
    //self.playerVC.exitsFullScreenWhenPlaybackEnds = YES;//开启这个所有 item 播放完毕可以退出全屏
        [self.view addSubview:self.playerVC.view];
        
        if (self.playerVC.readyForDisplay) {
            [self.playerVC.player play];
        }
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
