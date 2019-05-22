//
//  RootController.m
//  URTC
//
//  Created by Tony on 2019/4/6.
//  Copyright © 2019年 Ucloud. All rights reserved.
//

#import "RootController.h"

@interface RootController ()

@property (weak, nonatomic) IBOutlet UITextField *roomTF;
@property (strong, nonatomic)ChatController *chatVC;
- (IBAction)clickBtnForRoot:(UIButton *)sender;
@end

@implementation RootController
#pragma mark - life cycle
- (void)viewDidLoad
{
    
    [super viewDidLoad];
}

#pragma mark - selector
- (IBAction)clickBtnForRoot:(UIButton *)sender
{
    if ([_roomTF.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入房间号" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.chatVC = [main instantiateViewControllerWithIdentifier:@"ChatController"];
    self.chatVC.roomName = _roomTF.text;
    if (self.chatVC) {
        [self presentViewController:self.chatVC animated:YES completion:nil];
    }
}


@end
