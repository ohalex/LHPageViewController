//
//  LHScrollList.m
//  LHScrollListAndTablesDemo
//
//  Created by 陈汉鑫 on 15/12/30.
//  Copyright © 2015年 陈汉鑫. All rights reserved.
//

#import "LHScrollList.h"

@interface LHScrollList()
@property(weak,nonatomic)UIScrollView * titlesBar;

@property(strong,nonatomic)UIView * selectionIndicator;

@property(strong,nonatomic)NSMutableArray<UIButton *> * barItems;

@end

@implementation LHScrollList
{
    NSInteger _selectedItemIndex;
    UIView * _contentView;
    NSArray <NSLayoutConstraint *> * _indicatorConstraints;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context,rect.origin.x , rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    
    [[UIColor blackColor]setStroke];
    
    CGContextSetLineWidth(context, 0.5);
    CGContextStrokePath(context);
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        [self initialize];
        [self setupBackgroundView];
        [self setupTitlesBar];
        
        
    }
    
    
    return self;
    
}

- (void)initialize
{
    _indicatorBarHeight = 2;
    _titleFont = [UIFont systemFontOfSize:13];
    _selectedTitleColor = [UIColor blueColor];
    _indicatorBarColor = [UIColor blueColor];
    _normalTitleColor = [UIColor blackColor];
    _itemInterSpace = 20;
    
}
- (UIView *)selectionIndicator
{
    if (!_selectionIndicator) {
        _selectionIndicator = [UIView new];
        _selectionIndicator.backgroundColor = _indicatorBarColor;
        
        _selectionIndicator.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return _selectionIndicator;
}

- (NSMutableArray<UIButton *> *)barItems
{
    if (!_barItems) {
        _barItems = [NSMutableArray array];
    }
    return _barItems;
}

- (void)setupTitlesBar
{
    UIScrollView * titlesBar = [UIScrollView new];
    titlesBar.canCancelContentTouches = YES;
    titlesBar.showsHorizontalScrollIndicator = NO;
    titlesBar.showsVerticalScrollIndicator = NO;
    titlesBar.scrollsToTop = NO;
    [self addSubview:titlesBar];
    self.titlesBar = titlesBar;
   
    titlesBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titlesBar]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(titlesBar)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titlesBar]|"
                                                                options:NSLayoutFormatDirectionLeadingToTrailing
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(titlesBar)]];
}

- (void)setupBackgroundView
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIVisualEffectView * effectBackground = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    [self addSubview:effectBackground];
    
    effectBackground.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[effectBackground]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(effectBackground)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[effectBackground]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(effectBackground)]];

}

- (void)reloadlist
{
    NSInteger numberOfItems = [self.delegate numberOfItemsForScrollList:self];
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < numberOfItems; i++) {
        NSString *title = [self.delegate scrollList:self titleForItemAtIndex:i];
        [titles addObject:title];
    }
    
    _titles = [titles copy];
    
    [self setupIndicatorAndBarItems];
    
}


- (void)setupIndicatorAndBarItems
{
    [_selectionIndicator removeFromSuperview];
    
    for (UIButton * barItem in self.barItems) {
        [barItem removeFromSuperview];
        
    }
    
    [self.barItems removeAllObjects];
    
    [self addItemsAndIndicatorWithTitles:self.titles];
    
    
}
- (void)addItemsAndIndicatorWithTitles:(NSArray<NSString*> * )titles
{
    UIView * contentView = [UIView new];
    [self.titlesBar addSubview:contentView];
    _contentView = contentView;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
   [self.titlesBar addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.titlesBar
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1
                                                               constant:0]];

    
    [self.titlesBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|"
                                                                           options:NSLayoutFormatDirectionLeadingToTrailing
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(contentView)]];
    [self.titlesBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|"
                                                                           options:NSLayoutFormatDirectionLeadingToTrailing
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(contentView)]];
    
    __block UIButton * previousItem;
    
    [titles enumerateObjectsUsingBlock:^(NSString *  title, NSUInteger index, BOOL *  stop) {
   
        
        
        UIButton * item = [UIButton new];
        item.backgroundColor = [UIColor clearColor];
        [item setTitle:title forState:UIControlStateNormal];
        [item setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
        [item setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
        item.titleLabel.font = self.titleFont;
        item.titleLabel.textAlignment = NSTextAlignmentCenter;
        item.tag = index;
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.itemShouldSizeFit) {
            [item sizeToFit];
        } else {
            item.bounds = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
        }
        
        item.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [contentView addSubview:item];
        [self.barItems addObject:item];
        
        
        if (previousItem) {
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[previousItem]-spacing-[item]"
                                                                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                   metrics:@{@"spacing":@(self.itemInterSpace)}
                                                                                     views:NSDictionaryOfVariableBindings(previousItem,item)]];
        }
        
        else {
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[item]"
                                                                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                   metrics:@{@"padding":@(self.itemInterSpace)}
                                                                                     views:NSDictionaryOfVariableBindings(item)]];
        }
        
        
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:item
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:contentView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1
                                                                    constant:0]];
        
        
        previousItem = item;
        
    }];
    
    if (previousItem) {
        [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[previousItem]-padding-|"
                                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                                               metrics:@{@"padding":@(self.itemInterSpace)}
                                                                                 views:NSDictionaryOfVariableBindings(previousItem)]];
    }
    
    
    
    if (self.titles) {
        [self.titlesBar addSubview:self.selectionIndicator];
        
        [self.titlesBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_selectionIndicator(height)]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:@{@"height":@(self.indicatorBarHeight)}
                                                                       views:NSDictionaryOfVariableBindings(_selectionIndicator)]];
        [self layoutIfNeeded];
        
        [self itemClicked:[self.barItems firstObject]];
    }
    
    

}
- (void)alignSelectionIndicatorForItem:(UIButton *)item
{
    [self.titlesBar removeConstraints:_indicatorConstraints];

    
    NSLayoutConstraint * leadingConstraint = [NSLayoutConstraint constraintWithItem:self.selectionIndicator
                                                                          attribute:NSLayoutAttributeLeading
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:item
                                                                          attribute:NSLayoutAttributeLeading
                                                                         multiplier:1
                                                                           constant:0];
    
    NSLayoutConstraint * trailingConstraint = [NSLayoutConstraint constraintWithItem:self.selectionIndicator
                                                                           attribute:NSLayoutAttributeTrailing
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:item
                                                                           attribute:NSLayoutAttributeTrailing
                                                                          multiplier:1
                                                                            constant:0];
    
    
    _indicatorConstraints = @[leadingConstraint,trailingConstraint];
    
    
    [self.titlesBar addConstraints:_indicatorConstraints];
    
    
}

- (void)moveToItemAtIndex:(NSInteger)index
{
    if (self.barItems.count <= index) {
        return;
    }
    
    self.barItems[_selectedItemIndex].selected = NO;
    UIButton * nextSelecteditem = self.barItems[index];
    nextSelecteditem.selected = YES;
    _selectedItemIndex = index;
    
    
    [UIView animateWithDuration:0.38 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
        [self alignSelectionIndicatorForItem:nextSelecteditem];
        [self layoutIfNeeded];
        
    } completion:nil];

    CGFloat distanceFromborder = (self.titlesBar.frame.size.width - nextSelecteditem.frame.size.width)/2;
    [self.titlesBar scrollRectToVisible:CGRectInset(nextSelecteditem.frame, -distanceFromborder, 0) animated:YES];
    
}

- (void)itemClicked:(UIButton *)item
{
    
    [self moveToItemAtIndex:item.tag];
    
    if([self.delegate respondsToSelector:@selector(scrollList:didClickItemAtIndex:)]){
        
        [self.delegate scrollList:self didClickItemAtIndex:_selectedItemIndex];
        
    }
}
@end
