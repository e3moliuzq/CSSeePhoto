//
//  SeeUIImageViewController.h
//  CCJPhotoBrowser
//
//  Created by e3mo on 16/4/29.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeeUIImageViewController : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate> {
    
    UIButton *save_btn;
    
    NSMutableArray *images_arr;
    int choose_index;
    
    BOOL isHiddenStateBar;
    
    UIScrollView *scrollview;
    
    BOOL isNoNaviMode;
    
    BOOL is_show_save_btn;
}

/**
 设置显示内容
 array中为UIImage的数组
 */
- (void)setImages:(NSArray*)images_array;

- (void)setIsNoNaviMode:(BOOL)isNo;//设置是否显示navigationController,默认显示，点击屏幕则关闭viewcontroller
- (void)chooseImage:(int)index;//设置当前显示哪一张图片及其数据，现在只能初始化时使用，默认为0
- (void)enableSavePhoto:(BOOL)isEnable;//设置是否能存储图片，默认显示按钮

@end
