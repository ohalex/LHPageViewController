//
//  LHScrollList.h
//  LHScrollListAndTablesDemo
//
//  Created by 陈汉鑫 on 15/12/30.
//  Copyright © 2015年 陈汉鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHScrollList;

@protocol LHScrollListDelegate <NSObject>

/**
 *  点击滑动列表项时回调
 *
 *  @param scrollList 滑动列表
 *  @param index      列表项索引
 */
- (void)scrollList:(LHScrollList *)scrollList didClickItemAtIndex:(NSInteger)index;

- (NSString *)scrollList:(LHScrollList *)scrollList titleForItemAtIndex:(NSInteger)index;

- (NSInteger)numberOfItemsForScrollList:(LHScrollList *)scrollList;

@end

@interface LHScrollList : UIView


/**
 *  移动至索引项
 *
 *  @param index 索引
 */

- (void)moveToItemAtIndex:(NSInteger)index;

//移除所有item，根据数据源重新布局
- (void)reloadlist;

/**
 *  列表项title数组
 */
@property (copy, nonatomic, readonly) NSArray<NSString *> * titles;

@property (strong, nonatomic) UIFont *titleFont;
@property (assign, nonatomic) CGFloat indicatorBarHeight;
@property (strong, nonatomic) UIColor *indicatorBarColor;
@property (strong, nonatomic) UIColor *selectedTitleColor;
@property (strong, nonatomic) UIColor *normalTitleColor;
@property (assign, nonatomic) CGFloat itemInterSpace;
@property (assign, nonatomic) CGSize itemSize;
@property (assign, nonatomic) BOOL itemShouldSizeFit;

@property (weak, nonatomic) id<LHScrollListDelegate> delegate;

@end
