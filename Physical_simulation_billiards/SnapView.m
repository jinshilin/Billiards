//
//  SnapView.m
//  065-物理仿真集合
//
//  Created by 刘朝阳 on 16/1/9.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

#import "SnapView.h"

@implementation SnapView

//触摸开始
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
#warning 清除行为
    [self.animator removeAllBehaviors];
    
    //获取触摸点
    CGPoint loc = [touches.anyObject locationInView:self];
    //创建吸附行为
    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:self.boxView snapToPoint:loc];
    
    snap.damping = 0.5;
    
    //给仿真者添加行为
    [self.animator addBehavior:snap];

}

@end
