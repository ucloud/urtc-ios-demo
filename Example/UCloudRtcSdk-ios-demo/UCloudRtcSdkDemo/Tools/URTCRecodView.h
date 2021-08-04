//
//  URTCRecodView.h
//  
//
//  Created by Tony on 2020/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,URTCRecordViewStatus) {
    URTCRecordViewStatus_Start,
    URTCRecordViewStatus_Stop,
    URTCRecordViewStatus_Close,
};

typedef void(^URTCRecordViewDidSelectBlock)(URTCRecordViewStatus status);

@interface URTCRecodView : UIView

/**
 按钮操作 回调
 */
@property (nonatomic, copy) URTCRecordViewDidSelectBlock didSelectBlock;

@end

NS_ASSUME_NONNULL_END
