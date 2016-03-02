//
//  PushView.m
//  065-物理仿真集合
//
//  Created by 刘朝阳 on 16/1/9.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

#import "PushView.h"
#import "MBProgressHUD.h"



#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@interface PushView()
{
    UIImageView *_pointImage;
    UIPushBehavior *_push;
    CGPoint _currentPoint;
    UIView *_newMainBall;
    BOOL _isOk;

}

@property (nonatomic, strong) NSMutableArray *ballArr;
@end

@implementation PushView
#pragma mark - 懒加载数组
-(NSMutableArray *)ballArr{
    if (_ballArr == nil) {
        _ballArr = [NSMutableArray array];
    }
    return _ballArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加桌面
        UIImageView *desk = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"012"]];
        desk.frame = self.bounds;
        [self addSubview:desk];
        //移除盒子
        [self.boxView removeFromSuperview];
        
        //搭建界面
        //添加次球
        for (int i = 0; i < 8; i++) {
            UIView *ballView = [[UIView alloc]initWithFrame:CGRectMake(20*i+100, 200, 30, 30)];
            ballView.layer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]].CGImage;
            ballView.layer.cornerRadius = 15;
            ballView.layer.masksToBounds = YES;
            [self addSubview:ballView];
            //添加到数组
            [self.ballArr addObject:ballView];
        }
        //添加主球
        UIView *mainBallView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.5, self.frame.size.height * 0.8, 30, 30)];
        
        mainBallView.layer.contents = (id)[UIImage imageNamed:@"9"].CGImage;
        mainBallView.layer.cornerRadius = 15;
        mainBallView.layer.masksToBounds = YES;
        [self addSubview:mainBallView];
        [self.ballArr addObject:mainBallView];
        
        

        //添加开始拖拽的圆点图片
        UIImageView *pointImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AttachmentPoint_Mask"]];
        //隐藏圆点
        pointImage.hidden = YES;
        [self addSubview:pointImage];
        _pointImage = pointImage;
   /*********************添加行为************************/
        //添加
        [self addBehavior:mainBallView];
        
        //添加手势识别器
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        //监控主球移动
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(showPoint)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        
    }
    return self;
}
#pragma mark - 添加行为
- (void)addBehavior:(UIView *) mainBallView{
    
    
    /**************************创建推动行为************************/
    UIPushBehavior *push = [[UIPushBehavior alloc]initWithItems:@[mainBallView] mode:UIPushBehaviorModeInstantaneous];
    [self.animator addBehavior:push];
    _push = push;
    
    /**************************创建碰撞检测**************************/
    CGFloat W = self.frame.size.width;
    CGFloat H = self.frame.size.height;
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:self.ballArr];
 
    //添加路径
    
    [collision addBoundaryWithIdentifier:@"1" fromPoint:CGPointMake(30, 60) toPoint:CGPointMake(30, 310)];
    [collision addBoundaryWithIdentifier:@"2" fromPoint:CGPointMake(30, 350) toPoint:CGPointMake(30, H-60)];
    [collision addBoundaryWithIdentifier:@"3" fromPoint:CGPointMake(60, H-27) toPoint:CGPointMake(W-60, H-27)];
    [collision addBoundaryWithIdentifier:@"4" fromPoint:CGPointMake(W-20, H-60) toPoint:CGPointMake(W-20 ,350)];
    [collision addBoundaryWithIdentifier:@"5" fromPoint:CGPointMake(W-20, 310) toPoint:CGPointMake(W-20, 60)];
    [collision addBoundaryWithIdentifier:@"6" fromPoint:CGPointMake(60, 25) toPoint:CGPointMake(W-60, 25)];
    
    //添加碰撞检测行为
    [self.animator addBehavior:collision];
    
    
    /**************************物体的属性行为**************************/
    UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:self.ballArr];
    //设置成员的弹性材质
    item.elasticity = 0.1;
    //设置阻力
    item.resistance = 0.8;
    [self.animator addBehavior:item];

}
#pragma mark - 判断球的轨迹
- (void)showPoint{
    for (int i=0; i<self.ballArr.count; i++) {
        UIView *ball = self.ballArr[i];
        if (ball.center.x <= 30 || ball.center.x >= (self.frame.size.width-30)) {
            if (i == self.ballArr.count-1) {
                //提示
                MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self];
                hud.labelText = @"请选择主球位置";
                [self addSubview:hud];
                [hud show:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [hud removeFromSuperview];
                });
                //引用主球
                _newMainBall = ball;
#warning 必须把空间所在的行为状态移除后再改变位置行为
                //移除行为
                [self.animator removeAllBehaviors];
                //隐藏主球
                _newMainBall.hidden = YES;
#pragma mark - 进入touchBegin
                //设置调用标记
                _isOk = YES;
            }else{
                [ball removeFromSuperview];
                [self.ballArr removeObject:ball];
                
            }
            
        }else if( ball.center.y <= 30 || ball.center.y >= (self.frame.size.height-30)){
            if (i == self.ballArr.count-1) {
                //提示
                MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self];
                hud.labelText = @"请选择主球位置";
                [self addSubview:hud];
                [hud show:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [hud removeFromSuperview];
                });

                //引用主球
                _newMainBall = ball;
                [self.animator removeAllBehaviors];
                _newMainBall.hidden = YES;
                _isOk = YES;
            }else{
                [ball removeFromSuperview];
                [self.ballArr removeObject:ball];
                
            }
        }
  
    }
  
}

#pragma mark - 任意球
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint loc = [[touches anyObject] locationInView:self];
    
    //根据标记判断
    if (_isOk) {
        
        //改变主球位置
        _newMainBall.center  = loc;
        //显示主球
        _newMainBall.hidden  = NO;
        //重新添加行为
        [self addBehavior:_newMainBall];
        //更改标记状态
        _isOk = NO;
    }
}



#pragma mark - 拖拽进入方法
- (void)panAction:(UIPanGestureRecognizer *) recognizer{
    CGPoint loc = [recognizer locationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //显示圆点
        _pointImage.hidden = NO;
        _pointImage.center = loc;
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
    
        //获取当前点
        _currentPoint = loc;
        //重绘
        [self setNeedsDisplay];
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        //计算偏移量
        CGFloat offSetX = _pointImage.center.x - loc.x;
        CGFloat offSetY = _pointImage.center.y - loc.y;
        
        //偏移角度
        CGFloat angle = atan2(offSetY,offSetX);
     
        //计算力度
        CGFloat dixtance = hypot(offSetX, offSetY);
        //设置推动行为的角度和力度
        _push.angle = angle;
#warning 推动力度
        _push.magnitude = dixtance * 0.01;
        //激活单次推动行为
        _push.active = YES;
        
        //结束后隐藏圆点清除线
        _pointImage.hidden = YES;
        _pointImage.center = CGPointZero;
        _currentPoint = CGPointZero;
        
        //重绘
        
        [self setNeedsDisplay];
    
    }
    
}


#pragma mark - 绘图
-(void)drawRect:(CGRect)rect{
    //创建路径对象
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_pointImage.center];
    [path addLineToPoint:_currentPoint];
    
    path.lineWidth = 10.0;
    path.lineCapStyle = kCGLineCapRound;
    [RandomColor set];

    [path stroke];
}

@end
