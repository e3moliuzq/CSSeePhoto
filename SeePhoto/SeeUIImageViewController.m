//
//  SeeUIImageViewController.m
//  CCJPhotoBrowser
//
//  Created by e3mo on 16/4/29.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import "SeeUIImageViewController.h"
#import "DefineKey.h"
#import "LoadingViewController.h"
#import "PhotoScrollView.h"
#import "DefineKey.h"

@interface SeeUIImageViewController ()

@end

#define SYS_SHOW_IMAGE_TAG          9999

@implementation SeeUIImageViewController

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
    
    //dict url为网络图片，image为本地图片，base_image工程中的文件，  desc为文字描述  title为标题文字
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
    if (is_show_save_btn) {
        [save_btn setHidden:NO];
        [save_btn setEnabled:YES];
    }
    else {
        [save_btn setHidden:YES];
        [save_btn setEnabled:NO];
    }
    
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

- (void)enableSavePhoto:(BOOL)isEnable {
    is_show_save_btn = isEnable;
    if (is_show_save_btn) {
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
    scrollview.bounces = YES;
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
        
        if (images_arr && images_arr.count > 0) {
            [imageview setImage:[images_arr objectAtIndex:i]];
        }
        
        sc_view.childView = imageview;
        
        [sc_view setZoomScale:1 animated:NO];
    }
    
    [scrollview setContentSize:CGSizeMake(winsize.width*images_arr.count, winsize.height)];//设置滑动范围
    [scrollview setContentOffset:CGPointMake(winsize.width*choose_index, 0)];//设置当前显示位置
    [self.view addSubview:scrollview];
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
        }
        else {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            isHiddenStateBar = YES;
            [self setNeedsStatusBarAppearanceUpdate];
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
        [[LoadingViewController sharedViewController] showDelayTipsWithCenter:CGPointZero text:@"保存失败" view:self.view delay:2.f];
    }
    else {
        [[LoadingViewController sharedViewController] showDelayTipsWithCenter:CGPointZero text:@"保存成功" view:self.view delay:2.f];
    }
}

@end
