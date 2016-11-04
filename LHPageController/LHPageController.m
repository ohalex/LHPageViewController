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
NSString const *kLPListBarTitleFontAttribute = @"titleFont";
NSString const *kLPListBarIndicatorHeightAtrribute = @"indicatorBarHeight";
NSString const *kLPListBarSelectedTitleColorAttribute = @"selectedTitleColor";
NSString const *kLPListBarNormalTitleColorAttribute = @"normalTitleColor";
NSString const *kLPListBarItemInterSpaceAttribute = @"itemInterSpace";
NSString const *kLPListBarIndicatorBarColorAttribute = @"indicatorBarColor";

@interface LHPageController ()<LHPageViewDelegate, LHScrollListDelegate>

@property (strong, nonatomic) LHScrollList * scrollList;
@property (strong, nonatomic) LHPageView * pageView;
//@property (strong, nonatomic) UIViewController * currentChildController;
//@property (strong, nonatomic) NSArray<UIViewController *> * childcontrollers;
@property (strong, nonatomic) NSDictionary * attributes;

@end

@implementation LHPageController

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self  = [super init]) {
        _attributes = attributes;
    }
    
    return self;
    
}

- (void)reloadControllers
{
    for (UIViewController *childController in self.childViewControllers) {
        [childController willMoveToParentViewController:nil];
        [childController removeFromParentViewController];
        
    }
    
    NSInteger numberOfChildControllers = [self.datasource numberOfChildControllersForPageController:self];
    
            
    for (int i = 0; i < numberOfChildControllers; i++) {
        UIViewController *childController = [self.datasource pageController:self childControllerAtIndex:i];
        [self addChildViewController:childController];
        [childController didMoveToParentViewController:self];
                
    }
   
    [self.scrollList reloadlist];
   
    [self.pageView resetPages];
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController * controller, NSUInteger idx, BOOL * stop) {
        [self.pageView addPageWithView:controller.view atIndex:idx];
                
    }];
    
    
    
}
- (void)viewDidLoad {
   
    [super viewDidLoad];
    [self.view addSubview:self.scrollList];
    [self.view addSubview:self.pageView];
    
    [self reloadControllers];
    
}


-(LHPageView *)pageView
{
    if (!_pageView) {
        CGFloat pageViewY = self.scrollList.frame.size.height;
        _pageView = [[LHPageView alloc] initWithFrame:CGRectMake(0, pageViewY, self.view.frame.size.width, self.view.frame.size.height - pageViewY) ];
        
        _pageView.delegate = self;
    }
    return _pageView;
}

-(LHScrollList *)scrollList
{
    if (!_scrollList) {
        _scrollList = [[LHScrollList alloc]initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 38)];
        
        _scrollList.delegate = self;
        
        if (_attributes[kLPListBarTitleFontAttribute]) {
            _scrollList.titleFont = _attributes[kLPListBarTitleFontAttribute];
        }
        if (_attributes[kLPListBarIndicatorHeightAtrribute]) {
            _scrollList.indicatorBarHeight = [_attributes[kLPListBarIndicatorHeightAtrribute] floatValue];
        }
        if (_attributes[kLPListBarItemInterSpaceAttribute]) {
            _scrollList.itemInterSpace = [_attributes[kLPListBarItemInterSpaceAttribute] floatValue];
        }
        if (_attributes[kLPListBarSelectedTitleColorAttribute]) {
            _scrollList.selectedTitleColor = _attributes[kLPListBarSelectedTitleColorAttribute];
        }
        if (_attributes[kLPListBarNormalTitleColorAttribute]) {
            _scrollList.normalTitleColor = _attributes[kLPListBarNormalTitleColorAttribute];
        }
        if (_attributes[kLPListBarIndicatorHeightAtrribute]) {
            _scrollList.indicatorBarColor = _attributes[kLPListBarIndicatorBarColorAttribute];
        }
        
    }
    return _scrollList;
}

-(void)pageView:(LHPageView *)pageView WillEndDraggingAtIndex:(NSInteger)index
{
    [self.scrollList moveToItemAtIndex:index];
}

-(NSInteger)numberOfPagesForPageView:(LHPageView *)pageView
{
    
    return [self.datasource numberOfChildControllersForPageController:self];
}


- (NSString *)scrollList:(LHScrollList *)scrollList titleForItemAtIndex:(NSInteger)index
{
    return [self.datasource titleForListBarItemAtIndex:index];
}

- (NSInteger)numberOfItemsForScrollList:(LHScrollList *)scrollList
{
    return [self.datasource numberOfChildControllersForPageController:self];
}

-(void)scrollList:(LHScrollList *)scrollList didClickItemAtIndex:(NSInteger)index
{
    [self.pageView moveToPageAtIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
