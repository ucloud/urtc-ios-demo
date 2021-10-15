//
//  ViewController.m
//  UCloudRtcSdkDemo
//
//  Created by ucloud on 2020/4/20.
//  Copyright © 2020 ucloud. All rights reserved.
//

#import "ViewController.h"
#import "UCloudRtcTextField.h"
#import "UCloudRtcMeetingRoomVC.h"
#import "UIView+Toast.h"
#import "UCloudRtcSettingVC.h"
#import <UCloudRtcSdk_ios/UCloudRtcSdk_ios.h>

//线上
//#error 在[UCloud 控制台](https://console.ucloud.cn/urtc/manage)， 创建URTC应用，得到 appId 和 appKey
//#define APP_ID <#APP_ID #>
//#define APP_KEY <#APP_KEY#>
#define APP_ID @"URtc-h4r1txxy"
#define APP_KEY @"9129304dbf8c5c4bf68d70824462409f"
#define TOKEN @""
#import <AVFoundation/AVFoundation.h>
#import <UCloudRtcSdk_ios/UCloudRtcSdk_ios.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UCloudRtcTextField *userTf;
@property (weak, nonatomic) IBOutlet UCloudRtcTextField *roomTf;
@property (weak, nonatomic) IBOutlet UISwitch *roomTypeSwitch;

///  参数设置
@property (nonatomic,strong) NSDictionary *engineSetting;
@property (weak, nonatomic) IBOutlet UILabel *versionLB;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    self.versionLB.text = [UCloudRtcEngine currentVersion];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear");
}

- (IBAction)joinRoom:(UIButton *)sender {
    if (_userTf.text.length <= 0) {
        [self.view makeToast:@"请输入用户ID"];
        return;
    }
    if (_roomTf.text.length <= 0) {
        [self.view makeToast:@"请输入房间名"];
        return;
    }
    
    UCloudRtcMeetingRoomVC *roomVC = [UCloudRtcMeetingRoomVC new];
    roomVC.userId = self.userTf.text;
    roomVC.roomId = self.roomTf.text;
    roomVC.appId = APP_ID;
    roomVC.appKey = APP_KEY;
    roomVC.token = TOKEN;
    roomVC.engineSetting = self.engineSetting;
    roomVC.modalPresentationStyle = UIModalPresentationFullScreen;
    if (self.roomTypeSwitch.on) {
        roomVC.roomType = UCloudRtcEngineRoomType_Broadcast;
    }else{
        roomVC.roomType = UCloudRtcEngineRoomType_Communicate;
    }
    [self presentViewController:roomVC animated:true completion:nil];
}


- (void)gotoSetting{
   UCloudRtcSettingVC *settingVC = (UCloudRtcSettingVC *) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UCloudRtcSettingVC"];
    [self.navigationController pushViewController:settingVC animated:true];

}

- (void)setupUI {
    // 用户ID
    _userTf.text = [NSString stringWithFormat:@"ios_%d",arc4random()%1000];
    
    // 设置leftView
    [_userTf setLeftImageViewWithName:@"user"];
    [_roomTf setLeftImageViewWithName:@"room"];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:(UIBarButtonItemStyleDone) target:self action:@selector(gotoSetting)] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

@end
