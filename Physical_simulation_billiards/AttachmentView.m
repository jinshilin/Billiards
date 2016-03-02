//
//  AttachmentView.m
//  065-物理仿真集合
//
//  Created by 刘朝阳 on 16/1/9.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

#import "AttachmentView.h"
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@interface AttachmentView()

@property (nonatomic, assign) UIView *anchorView;

@property (nonatomic, assign) CGPoint offSetCenter;

@end

@implementation AttachmentView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //图片下移
        self.boxView.center = CGPointMake(self.frame.size.width * 0.5, 200);
        //中心点偏移量
        UIOffset offSet = UIOffsetMake(20, 20);
        CGPoint anchorPoint = CGPointMake(self.frame.size.width * 0.5, 120);
        //创建附着行为
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]initWithItem:self.boxView offsetFromCenter:offSet attachedToAnchor:anchorPoint];
        _attachment = attachment;
        //添加到仿真者
        [self.animator addBehavior:attachment];
        
        //圆点图片
        UIImage *img = [UIImage imageNamed:@"AttachmentPoint_Mask"];
        //为附着点添加图片
        UIImageView *anchorImageView = [[UIImageView alloc]initWithImage:img];
        anchorImageView.center = anchorPoint;
        _anchorView = anchorImageView;

        [self addSubview:anchorImageView];
        //为偏移点添加图片
#warning 偏移点图片必须添加到boxview上
        UIImageView *offSetImageView = [[UIImageView alloc]initWithImage:img];
        offSetImageView.center = CGPointMake(self.boxView.frame.size.width * 0.5 + offSet.horizontal, self.boxView.frame.size.height * 0.5 + offSet.vertical);
        [self.boxView addSubview:offSetImageView];
        
        //赋值
        _offSetCenter = offSetImageView.center;
        
        //创建手势识别器
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        //添加
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

#pragma mark - 识别器方法
- (void)panAction:(UIPanGestureRecognizer *) recognizer{
    //获取当前点
    CGPoint loc = [recognizer locationInView:self];
    //拖动时候
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        //设置附着点
        
        _attachment.anchorPoint = loc;
        _anchorView.center = _attachment.anchorPoint;
        
        //重绘
        [self setNeedsDisplay];
    }
}

#pragma mark - 绘制
-(void)drawRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //起始点
    [path moveToPoint:_anchorView.center];
    
    //计算偏移点在self中位置
    CGPoint newPoint = [self convertPoint:_offSetCenter fromView:self.boxView];
    //连线
    [path addLineToPoint:newPoint];
    path.lineWidth = 10;
    path.lineCapStyle = kCGLineCapRound;
    [RandomColor set];
    //渲染
    [path stroke];
}








@end
