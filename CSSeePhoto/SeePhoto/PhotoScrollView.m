//
//  PhotoScrollView.m
//  
//
//  Created by e3mo on 16/5/5.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "PhotoScrollView.h"

#define kMaxDragLength          (200)
#define kMaxToggleLength        (25)

@interface PhotoScrollView ()
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) BOOL flipped;

@end


@implementation PhotoScrollView

- (id)initWithFrame:(CGRect)frame {
    if (([super initWithFrame:frame])) {
        [self setShowsVerticalScrollIndicator:NO];
        [self setShowsHorizontalScrollIndicator:NO];
    }
    return self;
}

-(void)setChildView:(UIView *)aChildView {
    if (_childView != aChildView) {
        [_childView removeFromSuperview];
        _childView = aChildView;
        [super addSubview:_childView];
        [self addgestureWithChildView];
        
        [self setContentOffset:CGPointZero];
    }
}

-(void)addgestureWithChildView {
    UIPanGestureRecognizer *aPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    aPanGesture.minimumNumberOfTouches = 2;
    aPanGesture.maximumNumberOfTouches = 2;
    aPanGesture.delegate = self;
    [self addGestureRecognizer:aPanGesture];
}

- (void)panned:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _startPoint = panGesture.view.center;
        _flipped = NO;
        
        if(_stopScrollView) {
            _stopScrollView();
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [panGesture translationInView:self];
        
        UIView *pannedView = panGesture.view;
        
        CGFloat distance = sqrtf(point.x * point.x + point.y * point.y);
        
        if (distance < kMaxDragLength) {
            pannedView.center = CGPointMake(_startPoint.x + point.x, _startPoint.y + point.y);
        }
        else {
            float x = (point.x / distance) * kMaxDragLength;
            float y = (point.y / distance) * kMaxDragLength;
            
            pannedView.center = CGPointMake(_startPoint.x + x, _startPoint.y + y);
        }
        
        if (distance > kMaxToggleLength && !_flipped) {
            _flipped = YES;
            
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (_startScrollView) {
            _startScrollView();
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            panGesture.view.center = _startPoint;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIGestureRecognizer class]]) {
        if(gestureRecognizer.view == self){
            
            if (self.zoomScale > 1) {
                return NO;
            }
            else {
                return YES;
            }
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}

#pragma mark UIScrollView
- (void)setContentOffset:(CGPoint)anOffset {
    if (_childView != nil) {
        CGSize zoomViewSize = _childView.frame.size;
        CGSize scrollViewSize = self.bounds.size;
        
        if (zoomViewSize.width < scrollViewSize.width) {
            anOffset.x = -(scrollViewSize.width - zoomViewSize.width) / 2.0;
        }
        
        if (zoomViewSize.height < scrollViewSize.height) {
            anOffset.y = -(scrollViewSize.height - zoomViewSize.height) / 2.0;
        }
    }
    
    super.contentOffset = anOffset;
}

@end
