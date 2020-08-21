//
//  CLSlider.m
//  CLBrowser
//
//  Created by ucloud on 2017/3/15.
//  Copyright © 2017年 ucloud. All rights reserved.
//

#import "CLSlider.h"


@interface ClCircleLayer: CALayer
@property (nonatomic,strong) CALayer *fillLayer;
@property (nonatomic) UIColor *fillColor;
@property (nonatomic) UIColor *shadowFilColor;
@property (nonatomic) CGFloat shadowFillOpacity;

@end

@implementation ClCircleLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)doInit
{
    _fillColor = [UIColor colorWithRed:0.358 green:1.000 blue:0.834 alpha:1.000];
    _shadowFilColor = [UIColor yellowColor];
    _shadowFillOpacity = 1.0f;
    
    self.shadowColor = self.shadowFilColor.CGColor;
    self.shadowOffset = CGSizeMake(0, 0);
    self.shadowOpacity = self.shadowFillOpacity;
    
    self.fillLayer = [CALayer new];
    self.fillLayer.backgroundColor = self.fillColor.CGColor;
    [self addSublayer:self.fillLayer];
    
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    
    if (!CGSizeEqualToSize(self.bounds.size, self.fillLayer.frame.size)) {
        //更新圆角及阴影 尺寸
        CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.bounds)*0.5, CGRectGetHeight(self.bounds)*0.5);
        CGFloat cornerRadius = CGRectGetWidth(self.bounds) *0.5;
        CGMutablePathRef shadowPath = CGPathCreateMutable();
        CGPathAddArc(shadowPath, nil, centerPoint.x, centerPoint.y, cornerRadius, 0, (CGFloat)M_PI*2, YES);
        self.shadowPath = shadowPath;
        
        self.fillLayer.cornerRadius = cornerRadius;
        
    }
    self.fillLayer.frame = self.bounds;
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    self.fillLayer.backgroundColor = self.fillColor.CGColor;
}
- (void)setShadowFilColor:(UIColor *)shadowFilColor
{
    _shadowFilColor = shadowFilColor;
    self.shadowColor = self.shadowFilColor.CGColor;
}

//范围0~1
- (void)setShadowFillOpacity:(CGFloat)shadowFillOpacity
{
    shadowFillOpacity = MAX(0, shadowFillOpacity);
    shadowFillOpacity = MIN(1, shadowFillOpacity);
    
    _shadowFillOpacity = shadowFillOpacity;
    self.shadowOpacity = self.shadowFillOpacity;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                     ||                                                 //
//                                                     ||                                                 //
//====================================================>⭕️=================================================//
//                                                     ||                                                 //
//                                                     ||                                                 //
////////////////////////////////////////////////////////////////////////////////////////////////////////////


@interface CLSlider ()
{
    BOOL touchOnCircleLayer;
    CGRect lastFrame;
}
@property (nonatomic,strong)ClCircleLayer *thumbLayer;

@property (nonatomic,assign,readwrite) NSInteger currentIdx;
@end

@implementation CLSlider

#pragma mark -
#pragma mark - alloc init

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}
- (void)doInit
{
    touchOnCircleLayer = NO;
    _currentIdx = 0;
    _sliderStyle = CLSliderStyle_Nomal;
    
    //滑块相关
    _thumbShadowOpacity = 0.6;
    _thumbShadowColor = [UIColor yellowColor];
    _thumbTintColor = [UIColor colorWithRed:0.358 green:1.000 blue:0.834 alpha:1.000];
    _thumbDiameter = 20;
    
    //刻度线相关
    _scaleLineWidth = 1.0f;
    _scaleLineColor = [UIColor lightGrayColor];
    _scaleLineNumber = 4;
    _scaleLineHeight = 5;
    self.backgroundColor = [UIColor whiteColor];
    
    //滑块
    self.thumbLayer = [ClCircleLayer new];
    self.thumbLayer.anchorPoint = CGPointMake(0.5, 0.5);
    self.thumbLayer.fillColor = _thumbTintColor;
    self.thumbLayer.shadowFilColor = _thumbShadowColor;
    self.thumbLayer.shadowFillOpacity = _thumbShadowOpacity;
    [self.layer addSublayer:self.thumbLayer];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGRectEqualToRect(lastFrame, self.frame)) {
        lastFrame = self.frame;
        [self setNeedsDisplay];
        
    }
}

- (void)drawRect:(CGRect)rect
{
    
    CGFloat W = CGRectGetWidth(self.bounds);
    CGFloat H = CGRectGetHeight(self.bounds);
    
    //设置滑块位置
    CGFloat thumLayerFrameX = [self thumbLayerFrameXAtindex:self.currentIdx];
    CGRect tmpRect = CGRectMake(thumLayerFrameX, (H-self.thumbDiameter)*0.5, self.thumbDiameter, self.thumbDiameter);
    [self setThumbLayerFrame:tmpRect animated:YES];
    
    //绘制背景颜色
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);

    //绘制主刻度线
    CGPoint spindleScaleStartPoint = CGPointMake(self.thumbDiameter*0.5, H *0.5);
    CGPoint spindleScaleEndPoint = CGPointMake(W - self.thumbDiameter*0.5, H *0.5);
    
    //设置刻度线颜色
    [self.scaleLineColor setStroke];
    //绘主刻度轴(X轴)
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, self.scaleLineWidth);
    CGContextMoveToPoint(context, spindleScaleStartPoint.x,spindleScaleStartPoint.y);
    CGContextAddLineToPoint(context, spindleScaleEndPoint.x,spindleScaleEndPoint.y);
    CGContextStrokePath(context);

    if (CLSliderStyle_Nomal == self.sliderStyle || CLSliderStyle_Cross == self.sliderStyle) {
        //绘制竖直刻度短线
        NSInteger lineNum = self.scaleLineNumber+1;
        CGFloat oneW = (W-self.thumbDiameter)/self.scaleLineNumber;
        CGFloat x = self.thumbDiameter * 0.5;
        CGFloat startY = 0;
        
        if (CLSliderStyle_Nomal ==self.sliderStyle) {
            startY = MAX(0, spindleScaleStartPoint.y-self.scaleLineHeight);
        }else if (CLSliderStyle_Cross == self.sliderStyle) {
            startY = MAX((H-self.scaleLineHeight)*0.5, 0);
        }
        CGFloat endY = H;
        if (CLSliderStyle_Nomal ==self.sliderStyle) {
            endY = spindleScaleStartPoint.y;
        }else if (CLSliderStyle_Cross == self.sliderStyle) {
            endY = MIN(H, startY+self.scaleLineHeight);
        }
        
        for (NSInteger i = 0; i < lineNum; i ++) {
            CGPoint startP = CGPointMake(x+(i*(oneW)), startY);
            CGPoint endP = CGPointMake(x+(i*(oneW)), endY);
            CGContextMoveToPoint(context, startP.x, startP.y);
            CGContextAddLineToPoint(context, endP.x, endP.y);
            CGContextStrokePath(context);
            
        }
    }else if (CLSliderStyle_Point == self.sliderStyle) {
        //绘制圆点型刻度分隔
        NSInteger lineNum = self.scaleLineNumber+1;
        CGFloat oneW = (W-self.thumbDiameter)/self.scaleLineNumber;
        CGFloat x = self.thumbDiameter * 0.5;
        CGFloat y = spindleScaleStartPoint.y;

        for (int i = 0; i < lineNum; i++) {
            CGPoint point = CGPointMake(x+(i*(oneW)), y);
            CGContextSetFillColorWithColor(context, self.scaleLineColor.CGColor);//填充颜色
            CGContextSetLineWidth(context, 1);//线的宽度
            CGContextAddArc(context, point.x, point.y, self.scaleLineHeight, 0, 2*M_PI, YES); //添加一个圆
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        
    }

}
#pragma mark -
#pragma mark - Private Method
- (CGFloat)thumbLayerFrameXAtindex:(NSInteger)idx
{
    CGFloat W = CGRectGetWidth(self.frame);
    CGFloat oneW = (W-self.thumbDiameter)/self.scaleLineNumber;
    CGFloat x = oneW*idx;
    return x;
}

- (void)setThumbLayerFrame:(CGRect)frame animated:(BOOL)animated
{
    if(animated) {
        self.thumbLayer.actions = nil;
        self.thumbLayer.frame = frame;
    }else {
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
        self.thumbLayer.actions = newActions;
        self.thumbLayer.frame = frame;
    }
}



#pragma mark -
#pragma mark - Touch
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    CGPoint p = [touch locationInView:self];
    if (p.y>=0 && p.y <= CGRectGetHeight(self.frame)) {
        p.y = self.thumbLayer.position.y;
    }
    if (CGRectContainsPoint(self.thumbLayer.frame, p)) {
        touchOnCircleLayer = YES;
        [self didSeleCtcircleLayer];
        return YES;
    }
    touchOnCircleLayer = NO;
    return NO;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    if (touchOnCircleLayer) {
        CGPoint point = [touch locationInView:self];
        
        CGRect mRect = self.thumbLayer.frame;
        CGFloat x = point.x-self.thumbDiameter*0.5;
        mRect.origin.x = MAX(x, 0);
        mRect.origin.x = MIN(mRect.origin.x, CGRectGetWidth(self.frame)-self.thumbDiameter);
        [self setThumbLayerFrame:mRect animated:NO];
        
        
        CGFloat W = CGRectGetWidth(self.frame);
        CGFloat oneW = (W-self.thumbDiameter)/self.scaleLineNumber;

        CGFloat offX = point.x-self.thumbDiameter*0.5+oneW*0.5;
        offX = MAX(0, offX);
        offX = MIN(offX, CGRectGetWidth(self.frame));
        
        CGFloat idx = offX/oneW;
        int cIdx = (int)idx;
        cIdx = MIN(cIdx, (int)self.scaleLineNumber);
        cIdx = MAX(cIdx, 0);
        
        
        if (self.currentIdx != cIdx) {
            self.currentIdx = cIdx;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        return YES;
    }
    return NO;
}
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event
{
    [self desSelectCircleLayer];
}
- (void)cancelTrackingWithEvent:(nullable UIEvent *)event
{
    [self desSelectCircleLayer];
}

//取消选中
- (void)desSelectCircleLayer
{
    self.thumbLayer.transform = CATransform3DIdentity;
    CGRect tmpRect = self.thumbLayer.frame;
    tmpRect.origin.x = [self thumbLayerFrameXAtindex:self.currentIdx];
    
    self.thumbLayer.actions = nil;
    self.thumbLayer.frame = tmpRect;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:self.currentIdx];
    }
}
//选中
- (void)didSeleCtcircleLayer
{
    self.thumbLayer.transform = CATransform3DScale(self.thumbLayer.transform, 1.2, 1.2, 1);
}


#pragma mark -
#pragma mark - Setter Method

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    _thumbTintColor = thumbTintColor;
    self.thumbLayer.fillColor = thumbTintColor;
}

- (void)setThumbShadowOpacity:(CGFloat)thumbShadowOpacity
{
    _thumbShadowOpacity = thumbShadowOpacity;
    self.thumbLayer.shadowFillOpacity = thumbShadowOpacity;
}
- (void)setThumbShadowColor:(UIColor *)thumbShadowColor
{
    _thumbShadowColor = thumbShadowColor;
    self.thumbLayer.shadowFilColor = thumbShadowColor;
}


#pragma mark -
#pragma mark - Public Method
- (void)setSelectedIndex:(NSInteger)index
{
    index = MAX(0, index);
    index = MIN(index, self.scaleLineNumber);
    self.currentIdx = index;
    
    CGRect tmpRect = self.thumbLayer.frame;
    tmpRect.origin.x = [self thumbLayerFrameXAtindex:self.currentIdx];
    [self setThumbLayerFrame:tmpRect animated:NO];
}
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    index = MAX(0, index);
    index = MIN(index, self.scaleLineNumber);
    self.currentIdx = index;
    CGRect tmpRect = self.thumbLayer.frame;
    tmpRect.origin.x = [self thumbLayerFrameXAtindex:self.currentIdx];
    [self setThumbLayerFrame:tmpRect animated:animated];

}

@end
