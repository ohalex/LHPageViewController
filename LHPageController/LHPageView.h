//
//  LHPageView.h
//  LHScrollListAndTablesDemo
//
//  Created by 陈汉鑫 on 16/1/4.
//  Copyright © 2016年 陈汉鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHPageView;


@protocol LHPageViewDelegate <NSObject>

@required
- (NSInteger)numberOfPagesForPageView:(LHPageView *)pageView;

@optional
/**
 *  停止拖动pageView时回调
 *
 *  @param pageView pageView
 *  @param index    最终目标页面索引
 */
- (void)pageView:(LHPageView *)pageView WillEndDraggingAtIndex:(NSInteger)index;

//-(void)pageViewDidScroll:(LHPageView *)pageView
//       withLeftPageIndex:(NSInteger)index
//    rightPageVisibleRect:(CGFloat)ratio ;


@end

@interface LHPageView : UIView

@property (assign, readonly, nonatomic) CGPoint contentOffset;
@property (assign, readonly, nonatomic) NSInteger numberOfPages;
@property (weak, nonatomic) id<LHPageViewDelegate> delegate;

- (instancetype)initWithNumberOfPages:(NSInteger)numberOfPages;

/**
 *  重置页数
 */
- (void)resetPages;

/**
 *  页面移动
 *
 *  @param index 页面索引
 */
- (void)moveToPageAtIndex:(NSInteger)index;

/**
 *  添加内容页面
 *
 *  @param contentView 内容页面
 *  @param index    索引
 */
- (void)addPageWithView:(UIView *)contentView atIndex:(NSInteger)index;
/**
 *  移除内容页面
 *
 *  @param contentView 内容页面
 *  @param index    索引
 */
- (void)removePageAtIndex:(NSInteger)index;

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)gesture;
@end
