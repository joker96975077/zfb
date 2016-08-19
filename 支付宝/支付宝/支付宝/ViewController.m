//
//  ViewController.m
//  支付宝
//
//  Created by mr.scorpion on 16/8/14.
//  Copyright © 2016年 joker. All rights reserved.
//

#import "ViewController.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface ViewController ()
@property (nonatomic, strong) CAShapeLayer *alipaylayer;//圆弧
@property (nonatomic ,strong) CAShapeLayer *ticklayer; //钩
@end
//UITapGestureRecognizer * singleFingleTwo = [[UITapGestureRecognizer alloc] initwithTarget:self action:@selector(replayAnimation)];
@implementation ViewController
#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. 开启动画
    [self startAnimation];
    
    // 2. 添加单指双击复现动画
    //UITapGestureRecognizer *singleFingleTwo = [[UITapGestureRecognizer alloc] initwithTarget:self action:@selector(replayAnimation)];
    UITapGestureRecognizer *singleFingleTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replayAnimation)];
    singleFingleTwo.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:singleFingleTwo];
}

#pragma mark - Actions
#pragma mark - 开启动画
- (void)startAnimation
{
    // 一 、 画圈
    // 1. 先画一个圆圈的路径
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150)
                                                              radius:50.f
                                                          startAngle:M_PI * 3/2
                                                            endAngle:M_PI *7/2
                                                           clockwise:YES];
     // 2. 利用CAShapelayer来按照指定的PATH绘制图形
    _alipaylayer = [CAShapeLayer layer];
    _alipaylayer.path =  circlePath.CGPath;
    _alipaylayer.lineWidth = 3.f;
    _alipaylayer.fillColor = [UIColor clearColor].CGColor; // 填充色
    _alipaylayer.strokeColor =  RGBA(5, 154, 227, 1).CGColor; // [UIColor purplrColor].CGColor;
    
    // 3. 添加到view的layer上
    [self.view.layer addSublayer:_alipaylayer];
    
    
    // 二、 播放圆形动画
    // 1. 顺时针慢慢显示圆弧
    CABasicAnimation *drawAnimation =[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.fromValue = @0;
    drawAnimation.toValue = @1;
    drawAnimation.duration = 2.f;
    drawAnimation.fillMode = kCAFillModeForwards;
    drawAnimation.removedOnCompletion = YES;
    //[_alipaylayer addAnimation:drawAnimation forKey:@“DrawCircleAnimationKey”]; //测试:看看那这一小步的动画效果
    
    // 2. 顺时针慢慢擦除圆弧
    CABasicAnimation *dismissAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    dismissAnimation.fromValue = @0;
    dismissAnimation.toValue = @1;
    dismissAnimation.duration = 2.f;
    dismissAnimation.beginTime = 2.f;  //两个动画加入动画组，要按顺序播放，这个动画需要等上一个动画结束再开始
    dismissAnimation.removedOnCompletion = YES;
    
    
    // 三、将两个动画加入一个动画组
    CAAnimationGroup *group = [CAAnimationGroup animation]   ;
    group.animations = @[drawAnimation,dismissAnimation];
    group.duration = 4;
    group.repeatCount = INFINITY;
    group.removedOnCompletion = YES;
    [_alipaylayer addAnimation:group forKey:@"DrawCircleAnimationKey"];
    
    
    //3.1 两周圆圈动画结束后，执行打勾动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //3.2 停止圆弧动画
        //注：在开始下一个打勾动画钱需要停止圆弧的动画，停止动画苹果推荐的做法是直接设置SPEED为0
        _alipaylayer.speed = 0 ;
        
        
        // 四、制作完成打勾的动画
        UIBezierPath *tickpath = [UIBezierPath bezierPath];
        [tickpath moveToPoint:CGPointMake(130, 150)];
        [tickpath addLineToPoint:CGPointMake(145, 165)];
        [tickpath addLineToPoint:CGPointMake(170, 140)];
        
        _ticklayer = [CAShapeLayer layer];
        _ticklayer.path = tickpath.CGPath;
        _ticklayer.fillColor =[UIColor clearColor].CGColor;
        _ticklayer.strokeColor = RGBA(5, 154, 227, 1).CGColor;
        _ticklayer.lineWidth = 3.f;
        [self.view.layer addSublayer:_ticklayer ];
        
        CABasicAnimation *tickAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        tickAnimation.fromValue = @0;
        tickAnimation.toValue = @1;
        tickAnimation.duration = 2.f;
        [_ticklayer addAnimation:tickAnimation forKey:@"TickAnimationKey"];
        tickAnimation.removedOnCompletion = YES;
    });
}
#pragma mark - 停止动画
- (void)stopAnimation
{
    _ticklayer.speed = 0;
    [self.view.layer removeAllAnimations];
    [self.alipaylayer removeFromSuperlayer];
    self.alipaylayer = nil;
    [self.ticklayer removeFromSuperlayer];
    self.ticklayer = nil;
}
#pragma mark - 重启动画
- (void)replayAnimation
{
    [self stopAnimation];
    [self startAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
