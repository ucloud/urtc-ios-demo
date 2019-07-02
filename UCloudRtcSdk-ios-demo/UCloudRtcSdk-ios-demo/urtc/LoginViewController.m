//
//  LoginViewController.m
//  MeetingSDK
//
//  Created by tony on 2019/4/2.
//  Copyright © 2018年 ucloud. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+Toast.h"
#import <UCloudRtcSdk_ios/UCloudRtcSdk_ios.h>
#import "MeetingRoomViewController.h"


#define APP_ID @"URtc-h4r1txxy"


@interface LoginViewController ()

@property (nonatomic,strong) NSDictionary *engineSetting;

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (nonatomic, assign) BOOL didEnterNextVC;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [UCloudRtcPortList switchServer:NO];
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
    self.didEnterNextVC = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSString *)getUserId {
   NSString* userId = [NSString stringWithFormat:@"%d",arc4random()%1000];
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
    
    if (self.didEnterNextVC) {
        return; //防止点击频率过快，多次push
    }
    
    self.didEnterNextVC = YES;
    
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
        meeting.engineSetting = self.engineSetting;
    }
}
@end
