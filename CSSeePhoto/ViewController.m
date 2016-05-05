//
//  ViewController.m
//  CSSeePhoto
//
//  Created by e3mo on 16/5/4.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ViewController.h"
#import "SeePhotoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(30, 80, 230, 80)];
    [btn setTitle:@"see photo" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(seeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn0 setFrame:CGRectMake(30, 180, 230, 80)];
    [btn0 setTitle:@"see photo no navi" forState:UIControlStateNormal];
    [btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn0 setBackgroundColor:[UIColor redColor]];
    [btn0 addTarget:self action:@selector(seeNoNaviBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)seeBtn {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++) {
        NSArray *keys = [NSArray arrayWithObjects: @"base_image", @"desc", @"title", nil];
        NSArray *objs = [NSArray arrayWithObjects: [NSString stringWithFormat:@"chequer_%d.png",i+1], @"描述文字，文字自动换行，文字大小根据屏幕适配，可无该字段", [NSString stringWithFormat:@"标题%d，不换行，可无，文字大小适配",i+1], nil];
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
        [array addObject:dict];
    }
    
    SeePhotoViewController *sp_vc = [[SeePhotoViewController alloc] init];
    [sp_vc setImages:array];
    [sp_vc chooseImage:2];
    [sp_vc isShowLabel:YES];
    [sp_vc isHideLabelWithNaviBar:YES];
    [sp_vc enableSavePhoto:YES];
    [self.navigationController pushViewController:sp_vc animated:YES];
}

- (void)seeNoNaviBtn {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++) {
        NSArray *keys = [NSArray arrayWithObjects: @"base_image", @"desc", @"title", nil];
        NSArray *objs = [NSArray arrayWithObjects: [NSString stringWithFormat:@"chequer_%d.png",i+1], @"描述文字，文字自动换行，文字大小根据屏幕适配，可无该字段", [NSString stringWithFormat:@"标题%d，不换行，可无，文字大小适配",i+1], nil];
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
        [array addObject:dict];
    }
    
    SeePhotoViewController *sp_vc = [[SeePhotoViewController alloc] init];
    [sp_vc setImages:array];
    [sp_vc chooseImage:2];
    [sp_vc isShowLabel:YES];
    [sp_vc enableSavePhoto:YES];
    [sp_vc setIsNoNaviMode:YES];
    [self.navigationController pushViewController:sp_vc animated:YES];
}

@end
