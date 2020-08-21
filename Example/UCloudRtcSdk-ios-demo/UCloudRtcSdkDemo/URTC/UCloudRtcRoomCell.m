//
//  UCloudRtcRoomCell.m
//  UCloudRtcSdkDemo
//
//  Created by ucloud on 2020/4/22.
//  Copyright © 2020 ucloud. All rights reserved.
//

#import "UCloudRtcRoomCell.h"

@interface UCloudRtcRoomCell ()

@end

@implementation UCloudRtcRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)cameraOnOff:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.muteComplete(_stream, 0, !sender.isSelected);
}
- (IBAction)micOnOff:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.muteComplete(_stream, 1, sender.isSelected);
}

- (void)setStream:(UCloudRtcStream *)stream {
    _stream = stream;
    [stream renderOnView:self.contentView];
}

- (void)dealloc {
    NSLog(@"-%@- dealloc", self);
}

@end
