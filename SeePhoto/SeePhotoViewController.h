//
//  SeePhotoViewController.h
//
//
//  Created by e3mo on 16/5/5.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeePhotoViewController : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate> {
    
    UIButton *save_btn;
    
    NSMutableArray *images_arr;
    int choose_index;
    
    BOOL isHiddenStateBar;
    
    BOOL is_show_label;
    BOOL is_label_hide_with_navi;
    BOOL is_show_save_btn;
    
    UIScrollView *scrollview;
    
    UIView *text_view;
    
    BOOL isNoNaviMode;
}

/**
 需要使用第三方库SDWebImage
 */

/**
 设置显示内容
 array中为NSDictionary
 key：url为网络图片，image为本地图片，base_image工程中的图片，每个字典中有只能存在一个，多个情况下优先级为url->image->base_image
    desc为文字描述，可为空，可换行，文字大小自适应屏幕
    title为标题文字，可为空，不可换行，文字大小自适应屏幕
 */
- (void)setImages:(NSArray*)images_array;

- (void)setIsNoNaviMode:(BOOL)isNo;//设置是否显示navigationController,默认显示，YES时如果有label则不会隐藏，点击屏幕则关闭viewcontroller，暂时不能存储图片
- (void)chooseImage:(int)index;//设置当前显示哪一张图片及其数据，现在只能初始化时使用，默认为0
- (void)isShowLabel:(BOOL)isShowLabel;//设置是否显示文字title和desc，默认不显示
- (void)isHideLabelWithNaviBar:(BOOL)isHideWith;//设置文字是否随navi隐藏，主要用于显示navi的情况下滑动图片navi会收起时，默认不隐藏
- (void)enableSavePhoto:(BOOL)isEnable;//设置是否能存储图片，默认显示

@end
