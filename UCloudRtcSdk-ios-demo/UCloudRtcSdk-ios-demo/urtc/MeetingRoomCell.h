//
//  MeetingRoomCell.h
//  MeetingSDK
//
//  Created by tony on 2019/4/28.
//  Copyright © 2018年 ucloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UCloudRtcSdk_ios/UCloudRtcSdk_ios.h>

@protocol MeetingRoomCellDelegate <NSObject>
@optional
//禁用视频
-(void)didMuteStream:(UCloudRtcStream *)stream muteVideo:(BOOL)mute;
//禁用音频
-(void)didMuteStream:(UCloudRtcStream *)stream muteAudio:(BOOL)mute;
@end


@interface MeetingRoomCell : UICollectionViewCell

@property (nonatomic, weak) id <MeetingRoomCellDelegate> delegate;

- (void)configureWithStream:(UCloudRtcStream *)stream;
@end
