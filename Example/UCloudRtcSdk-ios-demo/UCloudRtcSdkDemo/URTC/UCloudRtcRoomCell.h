//
//  UCloudRtcRoomCell.h
//  UCloudRtcSdkDemo
//
//  Created by ucloud on 2020/4/22.
//  Copyright © 2020 ucloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UCloudRtcSdk_ios/UCloudRtcSdk_ios.h>
NS_ASSUME_NONNULL_BEGIN


/**
 type       0: 为摄像头
        1: 麦克风
 */
typedef void(^UCloudRtcRoomCellMuteComplete)(UCloudRtcStream *stream, int type, BOOL mute);
@interface UCloudRtcRoomCell : UICollectionViewCell

@property (strong, nonatomic)  UCloudRtcStream *stream;

@property (copy, nonatomic) UCloudRtcRoomCellMuteComplete muteComplete;

@end

NS_ASSUME_NONNULL_END
