//
//  YJResolutionChoosePicker.h
//
//  Created by YJ on 2020/7/4.
//  Copyright © 2020 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompleteBlock)(NSString *resolution,int index);


@interface URTCResolutionChoosePicker : UIView

@property (nonatomic, copy) CompleteBlock completeBlock;

-(void)showActionSheetView;


@end

NS_ASSUME_NONNULL_END
