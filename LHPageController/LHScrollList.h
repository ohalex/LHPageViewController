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
-(void)scrollList:(LHScrollList *)scrollList didClickItemAtIndex:(NSInteger)index;

@end

@interface LHScrollList : UIView


/**
 *  移动至索引项
 *
 *  @param index 索引
 */

- (void)moveToItemAtIndex:(NSInteger)index;


/**
 *  列表项title数组
 */
@property (copy, nonatomic) NSArray<NSString *> * titles;

@property (weak, nonatomic) id<LHScrollListDelegate> delegate;

@end
