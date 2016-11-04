//
//  LHPageView.m
//  LHScrollListAndTablesDemo
//
//  Created by 陈汉鑫 on 16/1/4.
//  Copyright © 2016年 陈汉鑫. All rights reserved.
//

#import "LHPageView.h"
@interface LHPage : NSObject

@property (strong, nonatomic) UIView * contentView;


@end

@implementation LHPage

-(instancetype)initWithContentView:(UIView *)contentView
{
    self = [super init];
    if (self) {
        _contentView = contentView;
       
    }
    return self;
    
}

@end

@interface LHPageView()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) NSMutableArray <LHPage *> * pages;


@end
@implementation LHPageView
{
    CGSize _pageSize;
    NSInteger _currentPageIndex;
}

- (instancetype)initWithNumberOfPages:(NSInteger)numberOfPages
{
    if (self = [super init]) {
        _numberOfPages = numberOfPages;
        [self resetPages];
    }
    return self;
}

- (CGPoint)contentOffset
{
    return self.scrollView.contentOffset;
}
- (NSMutableArray<LHPage *> *)pages
{
    if (!_pages) {
        _pages = [NSMutableArray array];
    }
    
    return _pages;
}

- (void)removePageAtIndex:(NSInteger)index
{
    if(self.pages.count <= index){
        return;
    }
    
    [self.pages[index].contentView removeFromSuperview];
    self.pages[index].contentView = nil;
}

- (void)resetPages
{
    for (LHPage * page in self.pages) {
        [page.contentView removeFromSuperview];
        page.contentView = nil;
    }
    _numberOfPages = [self.delegate numberOfPagesForPageView:self];
    
    for(int i = 0;i < _numberOfPages;i++){
        LHPage * page = [[LHPage alloc]initWithContentView:nil];
        [self.pages addObject:page];
    }
}

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)gesture
{
    if ([gesture isKindOfClass:[UIGestureRecognizer class]]) {
        [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:gesture];
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor colorWithWhite:246 alpha:1];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
- (void)setFrame:(CGRect)frame
{
    _pageSize = frame.size;
    [super setFrame:frame];
}


- (void)moveToPageAtIndex:(NSInteger)index
{
    if (self.pages.count <= index ) {
        return;
    }
    
    [self.scrollView setContentOffset:CGPointMake(index* _pageSize.width, 0) animated:labs(_currentPageIndex-index)>1?NO:YES];
//    self.scrollView.contentOffset = CGPointMake(index * _pageSize.width, 0);
    _currentPageIndex = index;
    
}

- (void)addPageWithView:(UIView *)contentView atIndex:(NSInteger)index
{
    
    if (self.pages.count <= index) {
        return;
    }
    LHPage *page = [[LHPage alloc] initWithContentView:contentView];
    
    [self.pages insertObject:page atIndex:index];
    
    [self.scrollView addSubview:page.contentView];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    
//    NSInteger leftPageindex =floor(scrollView.contentOffset.x/_pageSize.width);
//    
//    CGFloat rightPageRatio = (scrollView.contentOffset.x-leftPageindex *_pageSize.width)/_pageSize.width;
//    
//    if ([self.delegate respondsToSelector:@selector(pageViewDidScroll:withLeftPageIndex:rightPageVisibleRect:)]) {
//        [self.delegate pageViewDidScroll:self withLeftPageIndex:leftPageindex rightPageVisibleRect:rightPageRatio];
//    }
//    
//
//    
//}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger targetIndex = floor(targetContentOffset->x / _pageSize.width);
    
    if ([self.delegate respondsToSelector:@selector(pageView:WillEndDraggingAtIndex:)]) {
        [self.delegate pageView:self WillEndDraggingAtIndex:targetIndex];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake( self.numberOfPages * _pageSize.width,_pageSize.height);
    
    [self.pages enumerateObjectsUsingBlock:^(LHPage * page, NSUInteger index, BOOL * stop) {
       
        if (page.contentView) {
            page.contentView.frame = CGRectMake(_pageSize.width * index, 0, _pageSize.width, _pageSize.height);
        }
        
    }];
}

@end
