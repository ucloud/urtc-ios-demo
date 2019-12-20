//
//  ViewController.m
//  UCloudIMSdk-demo
//
//  Created by Tony on 2019/12/4.
//  Copyright © 2019 Tony. All rights reserved.
//

#import "ViewController.h"
#import <UCloudIMSdk/UCloudIMSdk.h>

#define APPID @"URtc-h4r1txxy"  //测试APPID

@interface ViewController ()<UCloudIMEngineDelegate>
@property (nonatomic, strong) UCloudIMEngine *imEngine;

@property (weak, nonatomic) IBOutlet UITextField *useridT;
@property (weak, nonatomic) IBOutlet UITextField *roomidT;
@property (weak, nonatomic) IBOutlet UITextView *sendTextV;
@property (weak, nonatomic) IBOutlet UITextView *recTextV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)connect:(id)sender {
    [self.roomidT resignFirstResponder];
    [self.useridT resignFirstResponder];
    [self.sendTextV resignFirstResponder];
    [self.recTextV resignFirstResponder];
    
    if([self.useridT.text isEqualToString:@""]) return;
    if([self.roomidT.text isEqualToString:@""]) return;
    self.imEngine = [UCloudIMEngine sharedImEngine];
    [self.imEngine cutOffConnect];
    self.imEngine.delegate = self;
    
    self.imEngine.userId = self.useridT.text;
    self.imEngine.roomId = self.roomidT.text;
    self.imEngine.appId = APPID;
    
    ///加入房间
    NSDictionary *parameters = @{
        @"UserType": @"admin",
        @"UserInfo":@{@"name":@"test"},
    };
    [self.imEngine joinRoom:parameters completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
        NSString *receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData * datas = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
        NSString *code = [NSString stringWithFormat:@"%@",jsonDict[@"Code"]];
        if (error) {
              NSLog(@"%@", error);
           } else if(code.intValue == 200){
               NSString *receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
               NSData * datas = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
               NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
               dispatch_async(dispatch_get_main_queue(), ^{
                   self.imEngine.mId = ((NSString*)(jsonDict[@"Msg"][@"MId"])).integerValue;
                   [self.imEngine connectCompletionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
                       if (error) {
                          NSLog(@"%@", error);
                       } else {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self.imEngine startConnect];
                           });
                       }
                   }];
               });
           }
    }];
}

///断开连接
- (IBAction)disconnect:(id)sender {
    [self.roomidT resignFirstResponder];
    [self.useridT resignFirstResponder];
    [self.sendTextV resignFirstResponder];
    [self.recTextV resignFirstResponder];
    [self.imEngine disconnectCompletionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {}];
}

///发送自定义消息
- (IBAction)sendCustomMsg:(id)sender {
    [self.roomidT resignFirstResponder];
    [self.useridT resignFirstResponder];
    [self.sendTextV resignFirstResponder];
    [self.recTextV resignFirstResponder];
    NSDictionary *parameters = @{
                                 @"CustomType": @"test",
                                 @"Content" : self.sendTextV.text,
                                };
    [self.imEngine pushCustomContent:parameters completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {}];
}

#pragma UCloudIMEngineDelegate
-(void)uCloudIMEngineDidReceiveMessage:(NSData *)data{
    NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.recTextV.text = str;
}
@end
