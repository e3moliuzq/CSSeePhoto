//
//  LoadingViewController.m
//
//
//  Created by e3mo on 16/5/5.
//  Copyright (c) 2016年 e3mo. All rights reserved.
//

#import "LoadingViewController.h"
#import "AppDelegate.h"
#import "DefineKey.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController
static LoadingViewController *_sharedViewController = nil;

+ (LoadingViewController *)sharedViewController
{
    if (_sharedViewController == nil) {
        _sharedViewController = [[LoadingViewController alloc] init];
    }
    
    return _sharedViewController;
}

#pragma mark - UIView
- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
    }
    
    return self;
}


- (void)showSmallLoadingWithCenter:(CGPoint)center text:(NSString *)text view:(UIView*)view {
    [self hideLoading];
    
    small_loading_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, SYS_UI_SCALE_WIDTH_SIZE(25))];
    [small_loading_view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    //不能和加阴影同时使用
    small_loading_view.layer.masksToBounds = YES;
    small_loading_view.layer.cornerRadius = 5;//如果圆角为一半，则可以截成圆形
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SYS_UI_SCALE_WIDTH_SIZE(10), SYS_UI_SCALE_WIDTH_SIZE(5), 0, SYS_UI_SCALE_WIDTH_SIZE(15))];
    [label setText:text];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:SYS_UI_SCALE_WIDTH_SIZE(12)]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label sizeToFit];
    [small_loading_view addSubview:label];
    
    small_loading_view.frame = CGRectMake(0, 0, label.frame.size.width+SYS_UI_SCALE_WIDTH_SIZE(20), SYS_UI_SCALE_WIDTH_SIZE(25));
    if (center.x > 0 && center.y > 0) {
        [small_loading_view setCenter:center];
    }
    else {
        CGSize winsize = [[UIScreen mainScreen] bounds].size;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [small_loading_view setCenter:CGPointMake(winsize.width/2, 5*winsize.height/6)];
        }
        else {
            [small_loading_view setCenter:CGPointMake(winsize.width/2, 5*(winsize.height-64)/6)];
        }
    }
    
    if (view) {
        [view addSubview:small_loading_view];
    }
    else {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[app window] addSubview:small_loading_view];
    }
}

- (void)hideSmallLoading {
    if (small_loading_view) {
        [small_loading_view removeFromSuperview];
        small_loading_view = nil;
    }
}

- (void)showFullLoadingWithText:(NSString *)text view:(UIView*)view{
    [self hideLoading];
    
    CGSize winsize = [[UIScreen mainScreen] bounds].size;
    full_loading_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height)];
    [full_loading_view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    UIView *base_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYS_UI_SCALE_WIDTH_SIZE(100), SYS_UI_SCALE_WIDTH_SIZE(100))];
    [base_view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    //不能和加阴影同时使用
    base_view.layer.masksToBounds = YES;
    base_view.layer.cornerRadius = SYS_UI_SCALE_WIDTH_SIZE(10);//如果圆角为一半，则可以截成圆形
    [base_view setCenter:CGPointMake(full_loading_view.frame.size.width/2, full_loading_view.frame.size.height/2)];
    [full_loading_view addSubview:base_view];
    
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicatorView setHidesWhenStopped:YES];//自动隐藏，YES的情况下如果stop时自动hidden
    [activityIndicatorView setColor:[UIColor whiteColor]];//设置小菊花的颜色
    [activityIndicatorView setCenter:CGPointMake(base_view.frame.size.width/2, base_view.frame.size.height/2-SYS_UI_SCALE_WIDTH_SIZE(10))];//大小设置无效，只能设置位置
    [activityIndicatorView startAnimating];
    [base_view addSubview:activityIndicatorView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, SYS_UI_SCALE_WIDTH_SIZE(20))];
    [label setText:text];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:SYS_UI_SCALE_WIDTH_SIZE(12)]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label sizeToFit];
    [label setCenter:CGPointMake(base_view.frame.size.width/2, base_view.frame.size.height-SYS_UI_SCALE_WIDTH_SIZE(20))];
    [base_view addSubview:label];
    
    if (view) {
        [view addSubview:full_loading_view];
    }
    else {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[app window] addSubview:full_loading_view];
    }
}

- (void)hideFullLoading {
    if (full_loading_view) {
        [full_loading_view removeFromSuperview];
        full_loading_view = nil;
    }
}

- (void)showDelayTipsWithCenter:(CGPoint)center text:(NSString *)text view:(UIView *)view delay:(float)delay {
    [self hideLoading];
    
    delay_tips_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, SYS_UI_SCALE_WIDTH_SIZE(25))];
    [delay_tips_view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    //不能和加阴影同时使用
    delay_tips_view.layer.masksToBounds = YES;
    delay_tips_view.layer.cornerRadius = 5;//如果圆角为一半，则可以截成圆形
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SYS_UI_SCALE_WIDTH_SIZE(10), SYS_UI_SCALE_WIDTH_SIZE(5), 0, SYS_UI_SCALE_WIDTH_SIZE(15))];
    [label setText:text];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:SYS_UI_SCALE_WIDTH_SIZE(12)]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label sizeToFit];
    [delay_tips_view addSubview:label];
    
    delay_tips_view.frame = CGRectMake(0, 0, label.frame.size.width+SYS_UI_SCALE_WIDTH_SIZE(20), SYS_UI_SCALE_WIDTH_SIZE(25));
    if (center.x > 0 && center.y > 0) {
        [delay_tips_view setCenter:center];
    }
    else {
        CGSize winsize = [[UIScreen mainScreen] bounds].size;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [delay_tips_view setCenter:CGPointMake(winsize.width/2, 5*winsize.height/6)];
        }
        else {
            [delay_tips_view setCenter:CGPointMake(winsize.width/2, 5*(winsize.height-64)/6)];
        }
    }
    
    if (view) {
        [view addSubview:delay_tips_view];
    }
    else {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[app window] addSubview:delay_tips_view];
    }
    
    [self performSelector:@selector(hideDelayTips) withObject:nil afterDelay:delay];
}

- (void)hideDelayTips {
    if (delay_tips_view) {
        [delay_tips_view removeFromSuperview];
        delay_tips_view = nil;
    }
}

- (void)showProgressLoadingWithCount:(int)count view:(UIView*)view auto:(BOOL)isAuto {
    
}

- (void)changeProgressLoadingIndex:(int)index {
    
}

- (void)hideProgressLoading {
    if (progress_loading_view) {
        [progress_loading_view removeFromSuperview];
        progress_loading_view = nil;
    }
}

- (void)hideLoading {
    [self hideSmallLoading];
    [self hideFullLoading];
    [self hideDelayTips];
    [self hideProgressLoading];
}


@end
