//
//  UCloudRtcLogger.h
//  UCloudRtcSDK
//
//  Created by tony on 2019/2/26.
//  Copyright © 2019年 ucloud. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT void UCloudRtcLog(NSString *format, ...);

@interface UCloudRtcLogger : NSObject
+ (void)setLogEnable:(BOOL)enable;
+ (BOOL)logEnable;
@end

