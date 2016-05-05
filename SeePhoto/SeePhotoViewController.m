//
//  SeePhotoViewController.m
//
//
//  Created by e3mo on 16/5/5.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "SeePhotoViewController.h"
#import "DefineKey.h"
#import "PhotoScrollView.h"
#import "UIImageView+WebCache.h"

@interface SeePhotoViewController ()

@end

#define SYS_SHOW_IMAGE_TAG          9999

@implementation SeePhotoViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return isHiddenStateBar;
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (isNoNaviMode) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            isHiddenStateBar = YES;
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if (isNoNaviMode) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            isHiddenStateBar = YES;
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    if (!images_arr) {
        images_arr = [[NSMutableArray alloc] init];
    }
    
    NSString *title = [NSString stringWithFormat:@"%d/%d",choose_index+1,(int)images_arr.count];
    self.navigationItem.title = title;
    
    UIButton *back_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [back_btn setFrame:CGRectMake(0, 0, 30, 30)];
    [back_btn setImage:[UIImage imageNamed:@"btn_navback_normal.png"] forState:UIControlStateNormal];
    [back_btn setImage:[UIImage imageNamed:@"btn_navback_press.png"] forState:UIControlStateHighlighted];
    [back_btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:back_btn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: leftItem, nil]];
    
    save_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [save_btn setFrame:CGRectMake(0, 0, 70, 30)];
    [save_btn setTitle:@"储存图片" forState:UIControlStateNormal];
    [save_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [save_btn setTitleColor:SYS_UI_LIGHT_GRAY_COLOR forState:UIControlStateHighlighted];
    [save_btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [save_btn setBackgroundColor:[UIColor clearColor]];
    [save_btn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:save_btn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        //这两句话保证uiscrollview系列的位置不会因为回到应用而改变
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        isNoNaviMode = YES;
    }
    
    [self addGR];
    [self initScrollView];
    [self initTextView];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setImages:(NSArray*)images_array {
    images_arr = [[NSMutableArray alloc] initWithArray:images_array];
}

- (void)setIsNoNaviMode:(BOOL)isNo {
    isNoNaviMode = isNo;
}

- (void)chooseImage:(int)index {
    choose_index = index;
}

- (void)isShowLabel:(BOOL)isShowLabel {
    is_show_label = isShowLabel;
    if (is_show_label) {
        text_view.hidden = NO;
    }
    else {
        text_view.hidden = YES;
    }
}

- (void)isHideLabelWithNaviBar:(BOOL)isHideWith {
    is_label_hide_with_navi = isHideWith;
    if (is_show_label) {
        if (is_label_hide_with_navi) {
            if (self.navigationController.navigationBar.hidden) {
                text_view.hidden = YES;
            }
            else {
                text_view.hidden = NO;
            }
        }
        else {
            text_view.hidden = NO;
        }
    }
}

- (void)enableSavePhoto:(BOOL)isEnable {
    if (isEnable) {
        [save_btn setHidden:NO];
        [save_btn setEnabled:YES];
    }
    else {
        [save_btn setHidden:YES];
        [save_btn setEnabled:NO];
    }
}

- (void)initScrollView {
    CGSize winsize = [[UIScreen mainScreen] bounds].size;
    
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height)];
    [scrollview setBackgroundColor:[UIColor clearColor]];
    scrollview.delegate = self;
    [scrollview setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [scrollview setShowsVerticalScrollIndicator:NO];
    [scrollview setShowsHorizontalScrollIndicator:NO];
    scrollview.pagingEnabled = YES;
    scrollview.bounces = NO;
    [scrollview setBouncesZoom:NO];
    
    for (int i=0; i<images_arr.count; i++) {
        PhotoScrollView *sc_view = [[PhotoScrollView alloc] initWithFrame:CGRectMake(i*winsize.width, 0, winsize.width, winsize.height)];
        sc_view.delegate = self;
        sc_view.tag = SYS_SHOW_IMAGE_TAG+i;
        sc_view.maximumZoomScale = 2.f;
        sc_view.minimumZoomScale = 0.1f;
        [sc_view setBouncesZoom:NO];
        sc_view.backgroundColor = [UIColor clearColor];
        sc_view.contentSize = CGSizeMake(winsize.width, winsize.height);
        sc_view.startScrollView = ^{
            scrollview.scrollEnabled = YES;
        };
        sc_view.stopScrollView = ^{
            scrollview.scrollEnabled = NO;
        };
        [scrollview addSubview:sc_view];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height)];
        [imageview setBackgroundColor:[UIColor clearColor]];
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.userInteractionEnabled = YES;
        
        NSDictionary *dict = [images_arr objectAtIndex:i];
        NSString *image_str = [dict objectForKey:@"url"];
        
        if (image_str && image_str.length > 0) {
            image_str = [image_str stringByReplacingOccurrencesOfString:@"_cut" withString:@""];//切除string中的cut
            [imageview sd_setImageWithURL:[NSURL URLWithString:image_str] placeholderImage:[UIImage imageNamed:@"view_loading.png"]];
        }
        else {
            image_str = [dict objectForKey:@"image"];
            if (image_str && image_str.length > 0) {
                [imageview setImage:[UIImage imageNamed:image_str]];
            }
            else {
                image_str = [dict objectForKey:@"base_image"];
                if (image_str && image_str.length > 0) {
                    [imageview setImage:[UIImage imageNamed:image_str]];
                }
                else {
                    [imageview setImage:[UIImage imageNamed:@"view_loading.png"]];
                }
            }
        }
        
        sc_view.childView = imageview;
        
        [sc_view setZoomScale:1 animated:NO];
    }
    
    [scrollview setContentSize:CGSizeMake(winsize.width*images_arr.count, winsize.height)];//设置滑动范围
    [scrollview setContentOffset:CGPointMake(winsize.width*choose_index, 0)];//设置当前显示位置
    [self.view addSubview:scrollview];
}

- (void)initTextView {
    CGSize winsize = [[UIScreen mainScreen] bounds].size;
    text_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, 0)];
    [text_view setBackgroundColor:SYS_UI_COLOR(0, 0, 0, 0.5)];
    [self.view addSubview:text_view];
    
    NSDictionary *dict = [images_arr objectAtIndex:choose_index];
    NSString *title = [dict objectForKey:@"title"];
    float desc_y = SYS_UI_SCALE_WIDTH_SIZE(25);
    if (!title || title.length == 0) {
        desc_y = SYS_UI_SCALE_WIDTH_SIZE(5);
        title = @"";
    }
    NSString *desc = [dict objectForKey:@"desc"];
    if (!desc || desc.length == 0) {
        desc = @"";
    }
    
    UILabel *title_label = [[UILabel alloc] initWithFrame:CGRectMake(SYS_UI_SCALE_WIDTH_SIZE(10), SYS_UI_SCALE_WIDTH_SIZE(5), winsize.width-SYS_UI_SCALE_WIDTH_SIZE(20), SYS_UI_SCALE_WIDTH_SIZE(15))];
    [title_label setText:title];
    [title_label setTextColor:[UIColor whiteColor]];
    [title_label setTextAlignment:NSTextAlignmentLeft];
    [title_label setFont:[UIFont systemFontOfSize:SYS_UI_SCALE_WIDTH_SIZE(14)]];
    [title_label setBackgroundColor:[UIColor clearColor]];
    title_label.tag = 999;
    [text_view addSubview:title_label];
    
    
    UILabel *desc_label = [[UILabel alloc] initWithFrame:CGRectMake(SYS_UI_SCALE_WIDTH_SIZE(10), desc_y, winsize.width-SYS_UI_SCALE_WIDTH_SIZE(20), 0)];
    [desc_label setText:desc];
    [desc_label setTextColor:[UIColor lightGrayColor]];
    [desc_label setTextAlignment:NSTextAlignmentLeft];
    desc_label.lineBreakMode = UILineBreakModeCharacterWrap;
    desc_label.numberOfLines = 0;
    [desc_label setFont:[UIFont systemFontOfSize:SYS_UI_SCALE_WIDTH_SIZE(12)]];
    [desc_label setBackgroundColor:[UIColor clearColor]];
    desc_label.tag = 1000;
    [desc_label sizeToFit];
    if (desc_label.frame.size.height > winsize.height/3) {
        desc_label.frame = CGRectMake(SYS_UI_SCALE_WIDTH_SIZE(10), desc_y, winsize.width-SYS_UI_SCALE_WIDTH_SIZE(20), winsize.height/3);
    }
    [text_view addSubview:desc_label];
    
    float height = desc_y+desc_label.frame.size.height+SYS_UI_SCALE_WIDTH_SIZE(5);
    text_view.frame = CGRectMake(0, winsize.height-height, winsize.width, height);
    
    if (!is_show_label) {
        text_view.hidden = YES;
    }
}

- (void)changeTextView {
    CGSize winsize = [[UIScreen mainScreen] bounds].size;
    
    NSDictionary *dict = [images_arr objectAtIndex:choose_index];
    NSString *title = [dict objectForKey:@"title"];
    float desc_y = SYS_UI_SCALE_WIDTH_SIZE(25);
    if (!title || title.length == 0) {
        desc_y = SYS_UI_SCALE_WIDTH_SIZE(5);
        title = @"";
    }
    NSString *desc = [dict objectForKey:@"desc"];
    if (!desc || desc.length == 0) {
        desc = @"";
    }
    
    UILabel *title_label = (UILabel*)[text_view viewWithTag:999];
    UILabel *desc_label = (UILabel*)[text_view viewWithTag:1000];
    
    [title_label setText:title];
    
    [desc_label setText:desc];
    
    desc_label.frame = CGRectMake(SYS_UI_SCALE_WIDTH_SIZE(10), desc_y, winsize.width-SYS_UI_SCALE_WIDTH_SIZE(20), 0);
    [desc_label sizeToFit];
    desc_label.tag = 1000;
    if (desc_label.frame.size.height > winsize.height/3) {
        desc_label.frame = CGRectMake(SYS_UI_SCALE_WIDTH_SIZE(10), desc_y, winsize.width-SYS_UI_SCALE_WIDTH_SIZE(20), winsize.height/3);
    }
    
    float height = desc_y+desc_label.frame.size.height+SYS_UI_SCALE_WIDTH_SIZE(5);
    text_view.frame = CGRectMake(0, winsize.height-height, winsize.width, height);
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == scrollview) {
        if (!self.navigationController.navigationBar.hidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                isHiddenStateBar = YES;
                [self setNeedsStatusBarAppearanceUpdate];
            }
            
            if (is_show_label && is_label_hide_with_navi) {
                CGSize winsize = [[UIScreen mainScreen] bounds].size;
                
                [UIView animateWithDuration:0.2 animations:^{
                    CGRect frame = text_view.frame;
                    frame.origin.y = winsize.height;
                    text_view.frame = frame;
                    
                } completion:^(BOOL finished) {
                    text_view.hidden = YES;
                }];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == scrollview) {
        int old_choose_index = choose_index;
        CGFloat pageWidth = scrollView.frame.size.width;
        choose_index = floor((scrollView.contentOffset.x - pageWidth/ 2) / pageWidth)+ 1;
        
        NSString *title = [NSString stringWithFormat:@"%d/%d",choose_index+1,(int)images_arr.count];
        self.navigationItem.title = title;
        
        if (old_choose_index != choose_index) {
            PhotoScrollView *sc_view = (PhotoScrollView*)[scrollview viewWithTag:SYS_SHOW_IMAGE_TAG+old_choose_index];
            [sc_view setZoomScale:1 animated:NO];
            [self changeTextView];
        }
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if (scrollView != scrollview) {
        if (scale < 1) {
            [UIView animateWithDuration:0.3 animations:^{
                [scrollView setZoomScale:1.0];
            }];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(PhotoScrollView *)scrollView {
    if (scrollView != scrollview) {
        return [scrollView childView];
    }
    return nil;
}

#pragma mark - GR
- (void)addGR {
    UITapGestureRecognizer *tap_gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tap_gr];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (void)tapView:(UITapGestureRecognizer*)tap {
    
    if (!isNoNaviMode) {
        if (self.navigationController.navigationBar.hidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            isHiddenStateBar = NO;
            [self setNeedsStatusBarAppearanceUpdate];
            
            if (is_show_label && is_label_hide_with_navi) {
                CGSize winsize = [[UIScreen mainScreen] bounds].size;
                CGRect frame = text_view.frame;
                frame.origin.y = winsize.height;
                text_view.frame = frame;
                
                text_view.hidden = NO;
                
                [UIView animateWithDuration:0.2 animations:^{
                    CGRect frame = text_view.frame;
                    frame.origin.y = winsize.height-frame.size.height;
                    text_view.frame = frame;
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
        else {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            isHiddenStateBar = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            
            if (is_show_label && is_label_hide_with_navi) {
                CGSize winsize = [[UIScreen mainScreen] bounds].size;
                
                [UIView animateWithDuration:0.2 animations:^{
                    CGRect frame = text_view.frame;
                    frame.origin.y = winsize.height;
                    text_view.frame = frame;
                    
                } completion:^(BOOL finished) {
                    text_view.hidden = YES;
                }];
            }
        }
    }
    else {
        [self back:nil];
    }
}

#pragma mark - save image
- (void)saveImage {
    PhotoScrollView *sc_view = (PhotoScrollView*)[scrollview viewWithTag:SYS_SHOW_IMAGE_TAG+choose_index];
    UIImageView *imageview = (UIImageView*)sc_view.childView;
    UIImage *image = imageview.image;
    
    if (image) {
        [self saveImageToPhotos:image];
    }
}

//存储图片到相册
- (void)saveImageToPhotos:(UIImage*)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
//        [[LoadingViewController sharedViewController] showDelayTipsWithCenter:CGPointZero text:@"保存失败" view:self.view delay:2.f];
    }
    else {
//        [[LoadingViewController sharedViewController] showDelayTipsWithCenter:CGPointZero text:@"保存成功" view:self.view delay:2.f];
    }
}

@end
