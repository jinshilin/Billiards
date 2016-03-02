//
//  DemoViewController.h
//  065-物理仿真集合
//
//  Created by 刘朝阳 on 16/1/9.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义枚举
typedef enum{
    kDemoFunctionSnap = 0,
    kDemoFunctionPush,
    kDemoFunctionAttachment,
    kDemoFunctionSpring,
    kDemoFunctionCollision
} kDemoFunction;

@interface DemoViewController : UIViewController

@property (nonatomic, assign) kDemoFunction index;

@end
