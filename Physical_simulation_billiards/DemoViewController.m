//
//  DemoViewController.m
//  065-物理仿真集合
//
//  Created by 刘朝阳 on 16/1/9.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

#import "DemoViewController.h"
#import "BaseView.h"
#import "SnapView.h"
#import "PushView.h"
#import "AttachmentView.h"
#import "SpringView.h"
#import "CollsionView.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建基View
    BaseView *baseView = nil;
    //判断显示哪个view
    switch (self.index) {
        case kDemoFunctionSnap:
            baseView = [[SnapView alloc]initWithFrame:self.view.bounds];
            break;
        case kDemoFunctionPush:
            //隐藏导航栏
            self.navigationController.navigationBarHidden = YES;
            baseView = [[PushView alloc]initWithFrame:self.view.bounds];
            break;
        case kDemoFunctionAttachment:
            baseView = [[AttachmentView alloc]initWithFrame:self.view.bounds];
            break;
        case kDemoFunctionSpring:
            baseView = [[SpringView alloc]initWithFrame:self.view.bounds];
            break;
        case kDemoFunctionCollision:
            baseView = [[CollsionView alloc]initWithFrame:self.view.bounds];
            break;
            
        default:
            break;
    }
    //添加到view上
    [self.view addSubview:baseView];
    
}


@end
