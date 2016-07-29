//
//  LHPageController.m
//  LHScrollListAndTablesDemo
//
//  Created by 陈汉鑫 on 16/7/28.
//  Copyright © 2016年 陈汉鑫. All rights reserved.
//

#import "LHPageController.h"
#import "LHScrollList.h"
#import "LHPageView.h"

@interface LHPageController ()<LHPageViewDelegate, LHScrollListDelegate>

@property (weak, nonatomic) LHScrollList * scrollList;
@property (weak, nonatomic) LHPageView * pageView;
//@property (strong, nonatomic) NSArray<UIViewController *> * childcontrollers;

@end

@implementation LHPageController

- (instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers
{
    if (self = [super init]) {
        [self addChildControllers:controllers];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollList];
    [self setupPageView];
    
    
}

- (void)setupPageView
{
    CGFloat pageViewY = _scrollList.frame.size.height;
    
    
    LHPageView * pageView = [[LHPageView alloc] initWithFrame:CGRectMake(0, pageViewY, self.view.frame.size.width, self.view.frame.size.height - pageViewY) ];
    
    self.pageView = pageView;
    [self.view addSubview:pageView];
    [pageView initializeWithNumberOfPages:self.childViewControllers.count];
    pageView.delegate = self;
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController * controller, NSUInteger idx, BOOL * stop) {
        [pageView addPageWithView:controller.view atIndex:idx];
        
    }];
    
}
- (void)setupScrollList
{
    
    NSMutableArray<NSString *> * titles = [NSMutableArray array];
    for (UIViewController * controller in self.childViewControllers) {
        NSString * title = controller.title ? controller.title : @"无标题";
        [titles addObject:title];
        
    }
    
    LHScrollList * scrollList = [[LHScrollList alloc]initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 38)];
    scrollList.titles = titles;
    scrollList.delegate = self;
    self.scrollList = scrollList;
    [self.view addSubview:scrollList];
    
}

-(void)addChildControllers:(NSArray<UIViewController *> *)childViewControllers
{
    for (UIViewController * childController in childViewControllers) {
        [self addChildViewController:childController];
    }
}
-(void)pageView:(LHPageView *)pageView WillEndDraggingAtIndex:(NSInteger)index
{
    [self.scrollList moveToItemAtIndex:index];
}

-(void)scrollList:(LHScrollList *)scrollList didClickItemAtIndex:(NSInteger)index
{
    [self.pageView moveToPageAtIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
