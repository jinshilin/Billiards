//
//  BaseView.h
//  065-物理仿真集合
//
//  Created by 刘朝阳 on 16/1/9.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView
//图片框
@property (nonatomic, weak) UIImageView *boxView;
//供外界使用的仿真者
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end
