//
//  LoginViewController.m
//  UCloudRtcSdkDemo
//
//  Created by tony on 2019/4/2.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+Toast.h"
#import <UCloudRtcSdk_ios/UCloudRtcSdk_ios.h>
#import "MeetingRoomViewController.h"

//线上
#define APP_ID @"URtc-h4r1txxy"
#define APP_KEY @"9129304dbf8c5c4bf68d70824462409f"
//pre 测试
//#define APP_ID @""
//#define APP_KEY @""
#define TOKEN @""

@interface LoginViewController ()

@property (nonatomic,strong) NSDictionary *engineSetting;

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.engineSetting = [NSDictionary dictionary];
    self.navigationController.navigationBarHidden = YES;
    self.userTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入房间号"
                                                                                  attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.4]}];
    
    self.userLabel.text = [self getUserId];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(doSetting:)
               name:@"doSetting"
             object:nil];
}

-(void)doSetting:(NSNotification*)noti{
    NSDictionary *dic = noti.userInfo;
    self.engineSetting = dic;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (NSString *)getUserId {
   NSString* userId = [NSString stringWithFormat:@"ios_%d",arc4random()%1000];
    return userId;
}


- (void)didEnterRoomWithUserId:(NSString *)userId appId:(NSString *)appId roomId:(NSString *)roomId{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self performSegueWithIdentifier:@"gotoMeetingRoom" sender:nil];
    }];
}



- (IBAction)didLoginAction:(id)sender {
    NSString *roomName = self.userTextField.text;
    if (!roomName || roomName.length == 0) {
        [self.view makeToast:[NSString stringWithFormat:@"房间号不能为空"]
                    duration:3.0
                    position:CSToastPositionCenter];
        return;
    }
    [self.view endEditing:YES];
    
    //点击加入房间
    [self didEnterRoomWithUserId:self.userLabel.text appId:APP_ID roomId:roomName];
}

- (IBAction)didChangeServer:(UISegmentedControl *)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoMeetingRoom"]) {
        MeetingRoomViewController *meeting = segue.destinationViewController;
        meeting.userId = self.userLabel.text;
        meeting.roomId = self.userTextField.text;
        meeting.appId = APP_ID;
        meeting.appKey = APP_KEY;
        meeting.token = TOKEN;
        meeting.engineSetting = self.engineSetting;
        if (self.segment.selectedSegmentIndex == 0) {
            meeting.engineMode = UCloudRtcEngineModeTrival;
        }else{
            meeting.engineMode = UCloudRtcEngineModeNormal;
        }
    }
}
@end
