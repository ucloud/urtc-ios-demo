//
//  UCloudRtcSettingVC.m
//  UCloudRtcSdkDemo
//
//  Created by ucloud on 2020/4/20.
//  Copyright © 2020 ucloud. All rights reserved.
//

#import "UCloudRtcSettingVC.h"
#import "CLSlider.h"

@interface UCloudRtcSettingVC ()<CLSliderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *videoL;
@property (weak, nonatomic) IBOutlet UILabel *audioL;
@property (weak, nonatomic) IBOutlet UILabel *pubL;
@property (weak, nonatomic) IBOutlet UILabel *subL;
@property (weak, nonatomic) IBOutlet UILabel *logL;
@property (weak, nonatomic) IBOutlet UILabel *videoProfileL;
@property (weak, nonatomic) IBOutlet UISwitch *autoPublishSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoSubscibeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *videoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *audioSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *logSwitch;
@property (weak, nonatomic) IBOutlet CLSlider *mSlider;
@end

@implementation UCloudRtcSettingVC
{
    NSInteger isVideo;
    NSInteger isAudio;
    NSInteger isAutoPub;
    NSInteger isAutoSub;
    NSInteger isLog;
    NSInteger videoProfile;
    NSDictionary *settingDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupUI {
    self.navigationItem.title = @"设置";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     [button setBackgroundImage:[UIImage imageNamed:@"backarrow.png"]
                                           forState:UIControlStateNormal];
     [button addTarget:self action:@selector(back)
                  forControlEvents:UIControlEventTouchUpInside];
     button.frame = CGRectMake(0, 0, 23, 23);
     UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
     self.navigationItem.leftBarButtonItem = menuButton;
    
    self.mSlider.delegate = self;
    self.mSlider.sliderStyle = CLSliderStyle_Point;
    self.mSlider.backgroundColor = [UIColor clearColor];
    self.mSlider.thumbTintColor = [UIColor colorWithRed:82.0/255 green:187.0/255 blue:255.0/255 alpha:1];
    self.mSlider.thumbShadowColor = [UIColor blackColor];
    self.mSlider.thumbShadowOpacity = 0.3f;
    self.mSlider.thumbDiameter = 20;
    self.mSlider.scaleLineColor = [UIColor colorWithRed:82.0/255 green:187.0/255 blue:255.0/255 alpha:1];
    self.mSlider.scaleLineWidth = 3.f;
    self.mSlider.scaleLineHeight = 4;
    self.mSlider.scaleLineNumber = 6;
    
    settingDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"setting"];
    if (settingDic == nil) {
        settingDic = @{
            @"isVideo": @(1),
            @"isAudio": @(1),
            @"isAutoPub": @(1),
            @"isAutoSub": @(1),
            @"isLog": @(0),
            @"videoProfile": @(3)
        };
    }
    if ([[settingDic valueForKey:@"isVideo"]  isEqual: @1]) {
        self.videoSwitch.on = YES;
    }else{
        self.videoSwitch.on = NO;
    }
    if ([[settingDic valueForKey:@"isAudio"]  isEqual: @1]) {
        self.audioSwitch.on = YES;
    }else{
        self.audioSwitch.on = NO;
    }
    if ([[settingDic valueForKey:@"isAutoPub"]  isEqual: @1]) {
        self.autoPublishSwitch.on = YES;
    }else{
        self.autoPublishSwitch.on = NO;
    }
    if ([[settingDic valueForKey:@"isAutoSub"]  isEqual: @1]) {
        self.autoSubscibeSwitch.on = YES;
    }else{
        self.autoSubscibeSwitch.on = NO;
    }
    if ([[settingDic valueForKey:@"isLog"]  isEqual: @1]) {
        self.logSwitch.on = YES;
    }else{
        self.logSwitch.on = NO;
    }
    videoProfile = ((NSString*)[settingDic valueForKey:@"videoProfile"]).integerValue;
    if (videoProfile == 0) {
        [self.mSlider setSelectedIndex:4];
        self.videoProfileL.text = @"480P";
    }else{
        [self.mSlider setSelectedIndex:videoProfile];
        [self didSelectedIndex:videoProfile];
    }
}

-(void)didSelectedIndex:(NSInteger)index{
    videoProfile = index;
    NSString *lable = @"";
    switch (index) {
        case 0:
            lable = @"180P_1";
            break;
        case 1:
            lable = @"180P_2";
            break;
        case 2:
            lable = @"360P_1";
            break;
        case 3:
            lable = @"360P_2";
            break;
        case 4:
            lable = @"默认480P";
            break;
        case 5:
            lable = @"720P";
            break;
        case 6:
            lable = @"1080P";
            break;
        default:
            break;
    }
    self.videoProfileL.text = lable;
}
- (IBAction)videoSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.videoL.text = @"默认打开";
    }else{
        self.videoL.text = @"关闭";
    }
}
- (IBAction)audioSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.audioL.text = @"默认打开";
    }else{
        self.audioL.text = @"关闭";
    }
}
- (IBAction)pubSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.pubL.text = @"默认打开";
    }else{
        self.pubL.text = @"关闭";
    }
}
- (IBAction)subSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.subL.text = @"默认打开";
    }else{
        self.subL.text = @"关闭";
    }
}
- (IBAction)logSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.logL.text = @"默认打开";
    }else{
        self.logL.text = @"关闭";
    }
}


- (void)back {
    isVideo = self.videoSwitch.on ? 1 : 0;
    isAudio = self.audioSwitch.on ? 1 : 0;
    isAutoPub = self.autoPublishSwitch.on ? 1 : 0;
    isAutoSub = self.autoSubscibeSwitch.on ? 1 : 0;
    isLog = self.logSwitch.on ? 1 : 0;

    settingDic = @{
        @"isVideo": @(isVideo),
        @"isAudio": @(isAudio),
        @"isAutoPub": @(isAutoPub),
        @"isAutoSub": @(isAutoSub),
        @"isLog": @(isLog),
        @"videoProfile": @(videoProfile)
    };
    [[NSUserDefaults standardUserDefaults] setObject:settingDic forKey:@"setting"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
