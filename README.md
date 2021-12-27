# urtc-ios-demo
urtc iOS 端demo

> 运行demo

```
cd  [path]/urtc-ios-demo/Example/UCloudRtcSdk-ios-demo

pod install

打开UCloudRtcSdkDemo.xcworkspace
```

> UCloudRtcSdk_iOS下载

- [UCloudRtcSdk_iOS_1.9.2.3](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.2.3.zip)

- [UCloudRtcSdk_iOS_1.9.2.3_非bitcode](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.2.3_非bitcode.zip)

- [UCloudRtcSdk_iOS_1.9.2.2](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.2.2.zip)

- [UCloudRtcSdk_iOS_1.9.2.1](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.2.1.zip)

- [UCloudRtcSdk_iOS_1.9.2](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.2.zip)

- [UCloudRtcSdk_iOS_1.9.1.7](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.1.7.zip)

- [UCloudRtcSdk_iOS_1.9.1.6](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.1.6.zip)

- [UCloudRtcSdk_iOS_1.9.1.5](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.1.5.zip)

- [UCloudRtcSdk_iOS_1.9.1.4](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.1.4.zip)

- [UCloudRtcSdk_iOS_1.9.1.3](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.1.3.zip)

- [UCloudRtcSdk_iOS_1.9.1.2](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.1.2.zip)

- [UCloudRtcSdk_iOS_1.9.1.1](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.1.1.zip)

- [UCloudRtcSdk_iOS-1.9.1](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS_1.9.1.zip)

- [UCloudRtcSdk_iOS-1.9.0](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.9.0.zip)

- [UCloudRtcSdk_iOS-1.8.9](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.8.9.zip)

- [UCloudRtcSdk_iOS-1.8.8](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.8.8.zip)

- [UCloudRtcSdk_iOS-1.8.7](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.8.7.zip)

- [UCloudRtcSdk_iOS-1.8.6](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.8.6.zip)

- [UCloudRtcSdk_iOS-1.8.5](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.8.5.zip)

- [UCloudRtcSdk_iOS-1.8.4](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.8.4.zip)

- [UCloudRtcSdk_iOS-1.8.3](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.8.3.zip)

- [UCloudRtcSdk_iOS-1.8.2](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.8.2.zip)

- [UCloudRtcSdk_iOS-1.8.1](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.8.1.zip)

- [UCloudRtcSdk_iOS-1.8.0](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.8.0.zip)

- [UCloudRtcSdk_iOS-1.7.9](http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.7.9.zip)


# 1 描述
UCloudRtcSdk_ios.framework 是UCloud推出的一款适用于iOS平台的实时音视频 SDK，支持iOS 8.0及以上系统，提供了音视频通话基础功能，提供灵活的接口，支持高度定制以及二次开发。<br/><br/>
在[UCloud 控制台](https://console.ucloud.cn/urtc/manage)， 创建URTC应用，得到 appId 和 appKey。

# 2 功能列表
## 2.1 基本功能
* 基本的音视频通话功能	
* 支持内置音视频采集的常见功能	
* 支持静音关闭视频功能	
* 支持视频尺寸的配置(180P - 720P)	
* 支持自动重连	
* 支持丰富的消息回调	
* 支持纯音频互动	
* 支持视频的大小窗口切换	
* 支持获取视频房间统计信息（帧率、码率、丢包率等）	
* 支持编码镜像功能		
* 支持屏幕录制功能
* 支持自动手动订阅 自动手动发布
* 支持权限（上行/下行/全部）控制
* 支持音量提示
* 支持获取sdk版本


## 2.2 增值功能
* 终端智能测试（摄像头、麦克风、网络、播放器）
* 视频录制/视频存储
* 视频水印
* 视频直播CDN分发
* 美颜
* 贴纸/滤镜/哈哈镜
* 背景分割
* 手势
* 虚拟形象
* 变声
# 3 方案介绍
## 3.1 方案架构
![](http://urtcwater.cn-bj.ufileos.com/%E5%9B%BE%E7%89%871.png)
## 3.2 方案优势
* 利用边缘节点就近接入
* 可用性99.99%
* 智能链路调度
* 自有骨干专线+Internet传输优化
* 数据报文AES加密传输
* 全API开放调度能力
* 端到端链路质量探测
* 多点接入线路容灾
* 抗丢包视频30% 音频70%
* 国内平均延时低于75ms 国际平均延时低于200ms
# 4 应用场景
## 4.1 主播连麦
支持主播之间连麦一起直播，带来与传统单向直播不一样的体验
48KHz 采样率、全频带编解码以及对音乐场景的特殊优化保证观众可以听到最优质的声音
## 4.2 视频会议
小范围实时音视频互动，提供多种视频通话布局模板，更提供自定义布局方式，保证会议发言者互相之间的实时性，提升普通观众的观看体验
## 4.3 泛文娱
### 4.3.1 一对一社交
客户可以利用UCloud实时音视频云实现 QQ、微信、陌陌等社交应用的一对一视频互动
### 4.3.2 狼人杀游戏
支持15人视频通话，玩家可在游戏中选择只开启语音或同时开启音视频
## 4.4 在线教育
支持自动和手动发布订阅视频流，方便实现课堂虚拟分组概念，同时支持根据角色设置流权限，保证课程秩序
## 4.5 在线客服
线上开展音视频对话，对客户的资信情况进行审核，方便金融科技企业实现用户在线签约、视频开户验证以及呼叫中心等功能
提供云端存储空间及海量数据的处理能力，提供高可用的技术和高稳定的平台

# 5 快速使用

##  5.1 导入SDK
### 5.1.1 使用 CocoaPods 自动集成
``` 
pod 'UCloudRtcSdk'
  platform :ios, '9.0'
  source 'https://github.com/CocoaPods/Specs.git'
  target 'Your App' do
  	use_frameworks!
  	#pod 'UCloudRtcSdk'
	pod 'UCloudRtcSdk', '~> 1.6.9'
end
```
### 5.1.2 手动导入 SDK 
> 手动导入

```
Add Files to "Your targets" -> [`pwd`/UCloudRtcSdk/Framework/UCloudRtcSdk_ios.framework]
```

> 添加系统依赖库

```
进入 TARGETS > Project Name > General > Frameworks, Libraries, and Embedded Content 菜单
点击 +，分别添加 CFNetwork.framework, Security.framework, OpenGLES.framework, GLKit.framework, VideoToolbox.framework和libicucore.tdb，libc++.tdb
```
### 5.1.3 工程配置
> Enable Bitcode

- 低于v1.5.7（包含）版本：
```
TARGETS > Project Name > Build Settings > Enable Bitcode 设置为No；
```
- v1.5.8及以后版本支持Bitcode

> 多媒体权限

```
	<key>NSCameraUsageDescription</key>
	<string>需要访问你的摄像头</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>需要访问你的麦克风</string>
```
 

## 5.2 初始化 
建议在初始化 App 的同时，初始化 SDK。



### 5.2.1 导入 SDK 头文件
    //objective-c
    <UCloudRtcSdk_ios/UCloudRtcSdk_ios.h> 
    
    //swift
    import UCloudRtcSdk_ios
### 5.2.2. 设置 userId 和 roomId，获取AppID；
### 5.2.3 初始化UCloudRtcEngine 并设置代理以接收相关回调信息；
    //objective-c
    UCloudRtcEngine *engine = [[UCloudRtcEngine alloc] initWithUserId:userId  appId:appId roomId:roomId]];
    engine.delegate = self;
    
     //swift
     UCloudRtcEngine *engine = UCloudRtcEngine.init(userId:userId, appId: appId, roomId:roomId , appKey: appKey, token:token)
     self.engine?.delegate = self
### 5.2.4 配置参数
初始化完成后，即可调用 SDK相关接口，实现对应功能。使用之前需要对SDK进行相关设置，如果不设置也可以，系统将会采用默认值。
    
    //objective-c
    self.engine.isAutoPublish = YES;//加入房间后将自动发布本地音视频 默认为YES
    self.engine.isAutoSubscribe = YES;//加入房间后将自动订阅远端音视频 默认为YES
    self.engine.isOnlyAudio = NO;//将启用纯音频模式 默认为NO
    self.engine.isDebug = NO;//是否开启日志
    self.engine.videoProfile = UCloudRtcEngine_VideoProfile_360P_1;//设置视频分辨率
    self.engine.streamProfile = UCloudRtcEngine_StreamProfileAll;//设置流权限
    self.engine.isTrackVolume = YES// 开启音量检测，默认为NO
    

    
    //swift
    self.engine?.isAutoPublish = ture;//加入房间后将自动发布本地音视频 默认为ture
    self.engine?.isAutoSubscribe = ture;//加入房间后将自动订阅远端音视频 默认为ture
    self.engine?.isOnlyAudio = false;//将启用纯音频模式 默认为false
    self.engine?.isDebug = false;//是否开启日志
    self.engine?.videoProfile = ._VideoProfile_360P_1;//设置视频分辨率
    self.engine?.streamProfile = .streamProfileAll;//设置流权限
## 5.3 加入房间

    //objective-c
    [self.engine joinRoomWithcompletionHandler:^(NSData *data, NSUrlResponse *response, NSError error) {
    }];
    
    //swift
    self.engine?.joinRoomWithcompletionHandler({(data, response, error) -> Void in})
## 5.4 发布本地流
* 自动发布模式下，joinRoom成功后，即可发布本地流，无需再次调用publish接口；
* 手动发布模式下，joinRoom成功后，可通过下述接口发布本地流；
        
        //objective-c
        [self.engine publish];
        
        //swift
        self.engine?.publish()
* 发布过程中可以监听以下事件获取发布状态，根据状态调用渲染或其他接口即可。

        //objective-c
        - (void)uCloudRtcEngine:(UCloudRtcEngine *)manager didChangePublishState:(UCloudRtcEnginePublishState)publishState {
            switch (publishState) {
                        case UCloudRtcEnginePublishStateUnPublish:
                            self.isConnected = NO;
                        break;
                        case UCloudRtcEnginePublishStatePublishing: {
                            [self.bottomButton setTitle:@"正在发布..." forState:UIControlStateNormal];
                        }
                        break;
                        case UCloudRtcEnginePublishStatePublishSucceed:{
                            self.isConnected = YES;
                            [self.view makeToast:@"发布成功" duration:1.5 position:CSToastPositionCenter];
                            [self.bottomButton setTitle:@"发布成功" forState:UIControlStateNormal];
                        }
                        break;
                        case UCloudRtcEnginePublishStateRepublishing: {
                            [self.bottomButton setTitle:@"正在重新发布..." forState:UIControlStateNormal];
                        }
                        break;
                        case UCloudRtcEnginePublishStatePublishFailed: {
                        self.isConnected = NO;
                            [self.bottomButton setTitle:@"开始发布" forState:UIControlStateNormal];
                        }
                        break;
                        case UCloudRtcEnginePublishStatePublishStoped: {
                        self.isConnected = NO;
                            [self.view makeToast:@"发布已停止" duration:1.5 position:CSToastPositionCenter];
                            [self.bottomButton setTitle:@"开始发布" forState:UIControlStateNormal];
                        }
                        break;
                        default:
                        break;
                    }                               
                }
                
        //swift
        func uCloudRtcEngine(_ manager: UCloudRtcEngine, didChange publishState: UCloudRtcEnginePublishState) {
            switch publishState {
                case .unPublish:
                    self.isConnected = false
                case .publishing:
                    CBToast.showToastAction(message: "正在发布...")
                case .publishSucceed:
                    CBToast.showToastAction(message: "发布成功")
                    self.isConnected = true;
                    self.bottomButton?.setTitle("发布成功", for: .normal)
                case .republishing:
                    self.bottomButton?.setTitle("正在重新发布...", for: .normal)
                case .publishFailed:
                    self.isConnected = false;
                    CBToast.showToastAction(message: "开始发布")
                case .publishStoped:
                    self.isConnected = false;
                    CBToast.showToastAction(message: "发布已停止")
                    self.bottomButton?.setTitle("开始发布", for: .normal)
                default:
                break
            }
        }
## 5.5 取消发布本地流

    //objective-c
    [self.engine unPublish];
    
    //swift
    self.engine?.unPublish()
## 5.6 订阅远程流
* 自动订阅模式下，joinRoom成功后，即可订阅远程流，无需再次调用subscribeMethod接口；\\
* 手动订阅模式下，joinRoom成功后，可通过下述接口订阅远程流；\\

        //objective-c
        [self.engine subscribeMethod:remoteStream];
        
        //swift
        self.engine?.subscribeMethod(remoteStream)
* 订阅成功，在回调事件中调用渲染接口即可。

        //objective-c
        -(void)uCloudRtcEngine:(UCloudRtcEngine *)channel didSubscribe:(UCloudRtcStream *)stream{
            [self reloadVideos];
        }
        
        //swift
        func uCloudRtcEngine(_ channel: UCloudRtcEngine, didSubscribe stream: UCloudRtcStream) {
            self.reloadVideos()
        }
## 5.7 取消订阅远程流

    //objective-c
    [self.engine unSubscribeMethod:remoteStream];
    
    //swift
    self.engine?.unSubscribeMethod(remoteStream)
    
## 5.8 开始视频录制
* 配置视频录制相关参数，开始视频录制

        //objective-c
        UCloudRtcRecordConfig *recordConfig = [UCloudRtcRecordConfig new];
        recordConfig.mainviewid = userId;  //主窗口位置用户id
        recordConfig.mimetype = 3;         //录制类型  1 音频 2 视频 3 音频+视频
        recordConfig.mainviewmt = 1;       //主窗口的媒体类型 1 摄像头 2 桌面
        recordConfig.bucket = @"urtc-test";//存储地址的名称
        recordConfig.region = @"cn-bj";    //所属的region
        recordConfig.watermarkpos = 1;     //水印的位置
        recordConfig.width = 360;          //录制视频的宽
        recordConfig.height = 480;         //录制视频的高
        recordConfig.isaverage = YES;      //是否均分
        recordConfig.waterurl = @"http://urtc-living-test.cn-bj.ufileos.com/test.png";//watertype 2时代表图片水印url 、watertype 3代表水印文字
        recordConfig.watertype = 1;        //1 (时间水印) 、 2 (图片水印) 、 3（文字水印)
        recordConfig.wtemplate = 9;        //模板
        [self.engine startRecord:recordConfig];   

        //swift
        let recordConfig = UCloudRtcRecordConfig.init()
        recordConfig.mainviewid = userId;   //主窗口位置用户id
        recordConfig.mimetype = 3;          //录制类型  1 音频 2 视频 3 音频+视频
        recordConfig.mainviewmt = 1;        //主窗口的媒体类型 1 摄像头 2 桌面
        recordConfig.bucket = "urtc-test";  //存储地址的名称
        recordConfig.region = "cn-bj";      //所属的region
        recordConfig.watermarkpos = 1;      //水印的位置
        recordConfig.width = 360;           //录制视频的宽
        recordConfig.height = 480;          //录制视频的高
        recordConfig.isaverage = YES;       //是否均分
        recordConfig.waterurl = @"http://urtc-living-test.cn-bj.ufileos.com/test.png";//watertype 2时代表图片水印url 、watertype 3代表水印文字
        recordConfig.watertype = 1;         //1 (时间水印) 、 2 (图片水印) 、 3（文字水印)
        recordConfig.wtemplate = 9;         //模板
        self.engine?.startRecord(recordConfig)

* 视频录制开始的回调方法会包含自动生成的视频录制文件存放地址，如下方式获取：

        //objective-c
        -(void)uCloudRtcEngine:(UCloudRtcEngine *)manager startRecord:(NSDictionary *)recordResponse{
            [self.view makeToast:[NSString stringWithFormat:@"视频录制文件:%@",recordResponse[@"FileName"]] duration:3.0     position:CSToastPositionCenter];
        }

        //swift
        func uCloudRtcEngine(_ manager: UCloudRtcEngine, startRecord recordResponse: [AnyHashable : Any]) {
            CBToast.showToastAction(message: NSString(format: "视频录制文件:%@", recordResponse["FileName"] as! CVarArg))
        }  

## 5.9 停止视频录制
    //objective-c
    [self.manager stopRecord];
    
    //swift
    self.manager?.stopRecord()
    
## 5.10 离开房间
    //objective-c
    [self.engine leaveRoom];   
    
    //swift
    self.engine?.leaveRoom()
    
## 6.0 编译、运行，开始体验吧！

