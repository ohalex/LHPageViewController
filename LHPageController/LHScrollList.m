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
        
        [self setupBackgroundView];
        [self setupTitlesBar];
        
        
    }
    
    
    return self;
    
}
- (UIView *)selectionIndicator
{
    if (!_selectionIndicator) {
        _selectionIndicator = [UIView new];
        _selectionIndicator.backgroundColor = [UIColor orangeColor];
        
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

- (void)setFrame:(CGRect)frame
{
    frame.size.height = 38;
    [super setFrame:frame];
}

- (void)setTitles:(NSArray<NSString *> *)titles
{
    _titles = titles;
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
   
        
        
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.backgroundColor = [UIColor clearColor];
        [item setTitle:title forState:UIControlStateNormal];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        item.titleLabel.font = [UIFont systemFontOfSize:15];
        item.tag = index;
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [item sizeToFit];
        item.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [contentView addSubview:item];
        [self.barItems addObject:item];
        
        
        if (previousItem) {
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[previousItem]-spacing-[item]"
                                                                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                   metrics:@{@"spacing":@20}
                                                                                     views:NSDictionaryOfVariableBindings(previousItem,item)]];
        }
        
        else {
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[item]"
                                                                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                   metrics:@{@"padding":@8}
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
                                                                               metrics:@{@"padding":@8}
                                                                                 views:NSDictionaryOfVariableBindings(previousItem)]];
    }
    
    
    [self layoutIfNeeded];
    
    if (self.titles) {
        [self.titlesBar addSubview:self.selectionIndicator];
        
        [self.titlesBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_selectionIndicator(height)]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:@{@"height":@2}
                                                                       views:NSDictionaryOfVariableBindings(_selectionIndicator)]];
        
        
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
    
    [self layoutIfNeeded];
    
}

- (void)moveToItemAtIndex:(NSInteger)index
{
    self.barItems[_selectedItemIndex].selected = NO;
    UIButton * nextSelecteditem = self.barItems[index];
    nextSelecteditem.selected = YES;
    _selectedItemIndex = index;
    
    
    [UIView animateWithDuration:0.38 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
        [self alignSelectionIndicatorForItem:nextSelecteditem];
        
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
