//
//  LoadingViewController.h
//
//
//  Created by e3mo on 16/5/5.
//  Copyright (c) 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController {
    UIView *small_loading_view;
    UIView *full_loading_view;
    UIView *delay_tips_view;
    UIView *progress_loading_view;
}

+ (LoadingViewController *)sharedViewController;

/**
 只能同时出现一个
 */

/**
 小屏loading，不会阻碍其他操作
 center：传入CGPointZero为默认位置，也可传值设定位置
 text：显示文字，不能换行，文字大小自适应
 view：显示的view，可不传，不传时为window添加
 */
- (void)showSmallLoadingWithCenter:(CGPoint)center text:(NSString*)text view:(UIView*)view;

/**
 全屏loading，会阻碍loading覆盖的所有操作
 text：显示文字，不能换行，文字大小自适应
 view：显示的view，可不传，不传时为window添加
 */
- (void)showFullLoadingWithText:(NSString*)text view:(UIView*)view;

/**
 提示消息，不会阻碍其他操作
 center：传入CGPointZero为默认位置，也可传值设定位置
 text：显示文字，不能换行，文字大小自适应
 view：显示的view，可不传，不传时为window添加
 delay:移除时间
 */
- (void)showDelayTipsWithCenter:(CGPoint)center text:(NSString*)text view:(UIView*)view delay:(float)delay;

- (void)showProgressLoadingWithCount:(int)count view:(UIView*)view auto:(BOOL)isAuto;//loading进度条，未完成
- (void)changeProgressLoadingIndex:(int)index;//loading进度条进度调整，未完成
- (void)hideLoading;//移除loading

@end
