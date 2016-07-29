//
//  ViewController.m
//  LHPageController
//
//  Created by 陈汉鑫 on 16/7/29.
//  Copyright © 2016年 陈汉鑫. All rights reserved.
//

#import "ViewController.h"
#import "LHPageController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController * vc1 = [[UIViewController alloc]init];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.title = @"今日天气";
    UIViewController * vc2 = [[UIViewController alloc]init];
    vc2.view.backgroundColor = [UIColor yellowColor];
    vc2.title = @"明日日天";
    UIViewController * vc3 = [[UIViewController alloc]init];
    vc3.view.backgroundColor = [UIColor blueColor];
    vc3.title = @"昨夜秋风";
    UIViewController * vc4 = [[UIViewController alloc]init];
    vc4.view.backgroundColor = [UIColor greenColor];
    vc4.title = @"春风不度玉门关";
    UIViewController * vc5 = [[UIViewController alloc]init];
    vc5.view.backgroundColor = [UIColor grayColor];
    vc5.title = @"小明小红小白";
    UIViewController * vc6 = [[UIViewController alloc]init];
    vc6.view.backgroundColor = [UIColor redColor];
    vc6.title = @"哈哈哈哈";
    UIViewController * vc7 = [[UIViewController alloc]init];
    vc7.view.backgroundColor = [UIColor yellowColor];
    vc7.title = @"冰与火之歌";
    UIViewController * vc8 = [[UIViewController alloc]init];
    vc8.view.backgroundColor = [UIColor blueColor];
    vc8.title = @"小学生";
    
    LHPageController * page = [[LHPageController alloc]initWithControllers:@[vc1,vc2,vc3,vc4,vc5,vc6,vc7,vc8]];
    page.view.frame = CGRectMake(0, 20, 375, 647);
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:page];
    
    [self.view addSubview:page.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
