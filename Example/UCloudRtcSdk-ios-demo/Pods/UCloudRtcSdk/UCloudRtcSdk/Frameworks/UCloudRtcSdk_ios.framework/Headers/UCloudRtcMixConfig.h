//
//  UCloudRtcMixConfig.h
//  UCloudRtcSdk-ios
//
//  Created by Tony on 2020/4/13.
//  Copyright © 2020 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCloudRtcEngine.h"

typedef enum : NSUInteger {
    UCloudRtcMixConfigTypePush = 1,
    UCloudRtcMixConfigTypeRecord,
    UCloudRtcMixConfigTypePushAndRecord,
    UCloudRtcMixConfigTypeUpdate,
} UCloudRtcMixConfigType;

@interface UCloudRtcMixConfig : NSObject

//1 转推 2 录制 3 转推和录制 4 更新设置
@property (nonatomic, assign) UCloudRtcMixConfigType type;

//streams 如果指定了用户，则只添加该用户的指定流，新加入的流处理由addstreammode参数决定 [{"user_id": "u616","media_type": 1 //1 摄像头  2 桌面},{}]
@property (nonatomic, strong) NSArray *streams;

//如果type选1或3需要指定转推地址
@property (nonatomic, copy) NSArray *pushurl;

//更新layout时使用，指定切换到的layout最大用户数，如果不指定，使用实时推流的用户数
@property (nonatomic, assign) NSInteger layoutUserlimit;

//1 流式(均分)布局, 2 讲课模式，主讲人占大部分屏幕，其他人小屏居于右侧或底部 3 自定义布局 4 定制讲课模式 5 定制均分模式
@property (nonatomic, assign) NSInteger layout;

//可选多布局,如果layouts已经有值会忽略layout的设置，update的时候可以使用layout指定更新到哪种布局 [4,5,6]
@property (nonatomic, strong) NSArray *layouts;
  
//如果layout选3，自定义布局填在custom里，格式参照RFC5707 Media Server Markup Language (MSML)
@property (nonatomic, strong) NSArray *custom;
           
//bgColor :{"r": 0,"g": 0, "b": 0}
@property (nonatomic, strong) NSDictionary *bgColor;

//bitrate 默认600
@property (nonatomic, assign) NSInteger bitrate;

//framerate 可选值 6, 12, 15, 24, 30, 48, 60, 默认15
@property (nonatomic, assign) NSInteger framerate;

//videocodec "h264" | "h265"， 默认h264
@property (nonatomic, copy) NSString *videocodec;

//qualitylevel: "B" | "CB" //If codec equals "h264"
@property (nonatomic, copy) NSString *qualitylevel;

// "aac"
@property (nonatomic, copy) NSString *audiocodec;

//layout选择2时，指定谁是主讲人
@property (nonatomic, copy) NSString *mainviewuid;

//layout选择2时，主屏幕放置的流类型 1 摄像头  2 桌面
@property (nonatomic, assign) UCloudRtcStreamMediaType mainviewtype;

//录制视频的宽 默认：640
@property (nonatomic, assign) NSInteger width;

//录制视频的高 默认：480
@property (nonatomic, assign) NSInteger height;

// bucket
@property (nonatomic, copy) NSString *bucket;

// region
@property (nonatomic, copy) NSString *region;

//0 (无水印) 1 (时间水印) 、 2 (图片水印) 、 3（文字水印)
@property (nonatomic, assign) NSInteger watertype;

//1 lefttop 2 leftbottom
@property (nonatomic, assign) NSInteger waterpos;

//watertype 2时代表图片水印url 、watertype 3代表水印文字
@property (nonatomic, copy) NSString *waterurl;

//1输出纯音频, 默认:0输出音视频
@property (nonatomic, assign) NSInteger mimetype;

//1自动 2手动, 默认自动
@property (nonatomic, assign) NSInteger addstreammode;

// 如果配置了这个参数，如果该用户的所有推流结束，则录制或者转推任务都会立刻结束
@property (nonatomic, copy) NSString *keyuser;

//单位秒，默认60秒
@property (nonatomic, assign) NSTimeInterval taskTimeout;
@end



/// 转推录制回调结果
@interface UCloudRtcMixResponse : NSObject
@property (nonatomic, assign) UCloudRtcMixConfigType type;
@property (nonatomic, copy) NSString *filename;

@property (nonatomic, copy) NSString *mixId;
// bucket
@property (nonatomic, copy) NSString *bucket;
// region
@property (nonatomic, copy) NSString *region;

@property (nonatomic, copy) NSArray *pushurl;
@end
