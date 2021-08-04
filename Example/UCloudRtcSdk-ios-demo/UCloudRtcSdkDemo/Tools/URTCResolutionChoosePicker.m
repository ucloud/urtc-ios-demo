//
//  YJResolutionChoosePicker.m
//
//  Created by YJ on 2020/7/4.
//  Copyright © 2020 YJ. All rights reserved.
//

#import "URTCResolutionChoosePicker.h"

#define kDeviceHight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width


@interface YJResolutionPickerView : UIView

@property(nonatomic,strong) UILabel *TitleLbl;

@property(nonatomic,strong) UIView *Line;

@end


@implementation YJResolutionPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
     
        _TitleLbl = [[UILabel alloc] initWithFrame:self.bounds];
        _TitleLbl.font = [UIFont systemFontOfSize:15];
        _TitleLbl.textColor = [UIColor blackColor];
        _TitleLbl.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_TitleLbl];
        
        _Line = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 130) / 2.0, self.frame.size.height - 3, 130, 1)];
        _Line.backgroundColor = [UIColor blueColor];
        [self addSubview:_Line];
    }
    return self;
}





@end



@interface URTCResolutionChoosePicker()  <UIPickerViewDelegate,UIPickerViewDataSource>

/** 弹窗 */
@property(nonatomic,strong) UIView *alertView;

@property (strong, nonatomic) UIPickerView *pickerView;

@property(nonatomic,strong) NSArray *DataArrM;

@property(nonatomic,assign) int currentIndex;

@end


@implementation URTCResolutionChoosePicker
/**
 UCloudRtcEngine_VideoProfile_180P_1 = 0, // 分辨率:240*180,  码率范围:100-200kpbs, 帧率:15fps
 UCloudRtcEngine_VideoProfile_180P_2 = 1, // 分辨率:320*180,  码率范围:100-200kpbs, 帧率:15fps
 UCloudRtcEngine_VideoProfile_360P_1 = 2, // 分辨率:480*360,  码率范围:100-300kpbs, 帧率:15fps(默认值)
 UCloudRtcEngine_VideoProfile_360P_2 = 3, // 分辨率:640*360,  码率范围:100-400kpbs, 帧率:20fps
 UCloudRtcEngine_VideoProfile_480P = 4,   // 分辨率:640*480,  码率范围:100-500kpbs, 帧率:20fps
 UCloudRtcEngine_VideoProfile_720P = 5,   // 分辨率:1280*720, 码率范围:300-1000kpbs,帧率:30fps
 UCloudRtcEngine_VideoProfile_1080P = 6,  // 分辨率:1920*1080,码率范围:500-1500kpbs,帧率:30fps
 
 */

- (NSArray *)DataArrM {
    if (!_DataArrM) {
        _DataArrM = @[@"240*180",@"320*180",@"480*360",@"640*360", @"640*480", @"1280*720", @"1920*1080"];
    }
    return _DataArrM;
}



- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [UIPickerView new];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.01 alpha:0.4];
        
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(28, kDeviceHight, kDeviceWidth - 56, 150)];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.clipsToBounds = YES;
        _alertView.layer.cornerRadius = 10.0f;
        
        self.pickerView.frame = _alertView.bounds;

        [self addSubview:_alertView];
        [_alertView addSubview:self.pickerView];
        
        
        CGFloat btnW = 70;
        CGFloat btnH = 35;
        UIButton *cancelBtn = [UIButton new];
        [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        cancelBtn.frame = CGRectMake(0, 0, btnW, btnH);
        [cancelBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        [_alertView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        
      
        UIButton *completeBtn = [UIButton new];
        [completeBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        completeBtn.frame = CGRectMake(CGRectGetWidth(_alertView.frame)-btnW, 0, btnW, btnH);
        [completeBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
        [_alertView addSubview:completeBtn];
        [completeBtn addTarget:self action:@selector(completeClick) forControlEvents:(UIControlEventTouchUpInside)];

        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}


- (void)cancelClick {
     [self CloseBtnClick];
}

- (void)completeClick {
    if (_completeBlock) {
        _completeBlock(self.DataArrM[_currentIndex], _currentIndex);
    }
    [self CloseBtnClick];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    if( CGRectContainsPoint(_alertView.frame, [tap locationInView:self])) {

    }else {
        
        [self CloseBtnClick];
    }
}


#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return self.DataArrM.count;
}
#pragma mark UIPickerViewDelegate Implementation

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    YJResolutionPickerView *pView =(YJResolutionPickerView *)view;
    if (!pView) {
        pView = [[YJResolutionPickerView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 50)];
    }
    pView.TitleLbl.text = self.DataArrM[row];
    return pView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
    NSLog(@"%ld - %ld", row , component);
    
    _currentIndex = (int)row;
}




#pragma mark - 弹出
-(void)showActionSheetView {
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

-(void)creatShowAnimation {
    self.alertView.transform = CGAffineTransformMakeTranslation(0, 0);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alertView.transform = CGAffineTransformMakeTranslation(0, -160);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 关闭按钮点击才回调
- (void)hideActionSheetView {
    
    self.alertView.transform = CGAffineTransformMakeTranslation(0, -160);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alertView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)CloseBtnClick {
    
    [self hideActionSheetView];
}


- (void)dealloc {
    NSLog(@"ActionSheet销毁了");
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
