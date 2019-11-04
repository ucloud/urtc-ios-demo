//
//  UCloudRtcRecordConfig.h
//  UCloudRtcSdk-ios
//
//  Created by Tony on 2019/10/23.
//  Copyright © 2019 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCloudRtcRecordConfig : NSObject

//录制类型  1 音频 2 视频 3 音频+视频
@property (nonatomic, assign) NSInteger mimetype;

//主窗口位置用户id
@property (nonatomic, copy) NSString *mainviewid;

//主窗口的媒体类型 1 摄像头 2 桌面
@property (nonatomic, assign) NSInteger mainviewmt;

//要使用的存储地址的名称
@property (nonatomic, copy) NSString *bucket;

//Bucket 所属的region
@property (nonatomic, copy) NSString *region;

//水印的位置
@property (nonatomic, assign) NSInteger watermarkpos;

//录制视频的宽
@property (nonatomic, assign) NSInteger width;

//录制视频的高
@property (nonatomic, assign) NSInteger height;

@end
