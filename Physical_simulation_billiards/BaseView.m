//
//  BaseView.m
//  065-物理仿真集合
//
//  Created by 刘朝阳 on 16/1/9.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundTile"]];
        
        //设置图片框
        UIImageView *boxView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Box1"]];
        //设置位置
        boxView.center = CGPointMake(self.bounds.size.width * 0.5, 150);
        
        //赋值属性
        _boxView = boxView;
        //添加
        
        [self addSubview:boxView];
        
        //创建仿真者并赋值
        
        UIDynamicAnimator *animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
        _animator = animator;
    }
    return self;
}

@end
