//
//  TableViewController.m
//  065-物理仿真集合
//
//  Created by 刘朝阳 on 16/1/9.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

#import "TableViewController.h"
#import "DemoViewController.h"

@interface TableViewController ()
//声明数组变量保存仿真名称
@property (nonatomic, strong) NSArray *dynamicArr;
@end

@implementation TableViewController
#pragma mark - 懒加载数组
-(NSArray *)dynamicArr{
    if (_dynamicArr == nil) {
        _dynamicArr = @[@"吸附行为", @"推动行为", @"刚性附着行为", @"弹性附着行为", @"碰撞检测"];
    }
    return _dynamicArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tableview的标题
    self.navigationItem.title = @"仿真行为";
    //设置返回按钮文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];

}
#pragma mark - 数据源代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dynamicArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //设置箭头
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dynamicArr[indexPath.row];
    
    return cell;
}
#pragma mark - 代理方法实现
//当前被选中行执行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DemoViewController *demoVc = [[DemoViewController alloc]init];
    //设置标题
    demoVc.navigationItem.title = self.dynamicArr[indexPath.row];
    //把标记序号赋值给demoview
    demoVc.index = (int)indexPath.row;

    //跳转
    [self.navigationController pushViewController:demoVc animated:YES];
}



@end
