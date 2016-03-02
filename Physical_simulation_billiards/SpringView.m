//
//  SpringView.m
//  065-物理仿真集合
//
//  Created by 刘朝阳 on 16/1/9.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

#import "SpringView.h"
#import "AttachmentView.h"

@implementation SpringView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        //修改为弹性附着
        //振幅
        self.attachment.damping = 1.0;
        //频率
        self.attachment.frequency = 2;
        //添加重力行为
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[self.boxView]];
        [self.animator addBehavior:gravity];
        
        //KVO
        [self.boxView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

//值变化回来到此方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    [self setNeedsDisplay];
}
//销毁
-(void)dealloc{
    [self.boxView removeObserver:self forKeyPath:@"center" context:nil];
}

@end
