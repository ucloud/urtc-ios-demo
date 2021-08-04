//
//  NativeMediaViewController.m
//  UCloudRtcSdkDemo
//
//  Created by Tony on 2020/7/1.
//  Copyright © 2020 ucloud. All rights reserved.
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
        NSString *tmpDir = NSTemporaryDirectory();
        self.videoUrl = [NSString stringWithFormat:@"%@test.mp4",tmpDir];
        self.playerVC = [[AVPlayerViewController alloc] init];
        self.playerVC.player = [AVPlayer playerWithURL:[self.videoUrl hasPrefix:@"http"] ? [NSURL URLWithString:self.videoUrl]:[NSURL fileURLWithPath:self.videoUrl]];
        self.playerVC.view.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width*1.5)/2, self.view.frame.size.width, self.view.frame.size.width*1.5);
        self.playerVC.showsPlaybackControls = YES;
        [self.view addSubview:self.playerVC.view];
        
        if (self.playerVC.readyForDisplay) {
            [self.playerVC.player play];
        }
}

- (IBAction)back{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
