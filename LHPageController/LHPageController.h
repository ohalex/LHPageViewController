//
//  LHPageController.h
//  LHScrollListAndTablesDemo
//
//  Created by 陈汉鑫 on 16/7/28.
//  Copyright © 2016年 陈汉鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

//样式属性
extern NSString const *kLPListBarTitleFontAttribute;
extern NSString const *kLPListBarIndicatorHeightAtrribute;
extern NSString const *kLPListBarSelectedTitleColorAttribute;
extern NSString const *kLPListBarNormalTitleColorAttribute;
extern NSString const *kLPListBarItemInterSpaceAttribute;
//extern NSString *kLPPageViewScrollEnabledAttribute;
extern NSString const *kLPListBarIndicatorBarColorAttribute;

@class LHPageController;
@protocol LHPageControllerDataSource <NSObject>

@required
//实现返回相应子控制器
- (UIViewController *)pageController:(LHPageController *)pageController childControllerAtIndex:(NSInteger)index;

//实现返回子控制器数目
- (NSInteger)numberOfChildControllersForPageController:(LHPageController *)pageController;

//返回相应tab栏标题
- (NSString *)titleForListBarItemAtIndex:(NSInteger)index;

@end
@interface LHPageController : UIViewController

@property (weak, nonatomic) id<LHPageControllerDataSource> datasource;

//attributes为样式参数
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
//- (instancetype)initWithControllers:(NSArray<UIViewController *> *) controllers;

//移除所有子控制器，从数据源获取新的子控制器
- (void)reloadControllers;


@end
