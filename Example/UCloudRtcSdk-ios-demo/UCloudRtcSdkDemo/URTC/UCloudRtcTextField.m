//
//  UCloudRtcTextField.m
//  UCloudRtcSdkDemo
//
//  Created by ucloud on 2020/4/20.
//  Copyright © 2020 ucloud. All rights reserved.
//

#import "UCloudRtcTextField.h"

@implementation UCloudRtcTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.borderStyle = UITextBorderStyleNone;
    self.leftViewMode = UITextFieldViewModeAlways;

}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, rect.size.height-0.5, rect.size.width, 0.5));
}

- (void)setLeftImageViewWithName:(NSString *)name {
    int w = self.bounds.size.height;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w + 10, w)];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.center = view.center;
    imgView.image = [UIImage imageNamed:name];
    imgView.bounds = CGRectMake(0, 0, w*0.7, w*0.7);
    [view addSubview:imgView];

    self.leftView = view;
}

@end
