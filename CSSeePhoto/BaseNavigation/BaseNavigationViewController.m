//
//  BaseNavigationViewController.m
//
//
//  Created by e3mo on 16/5/5.
//  Copyright (c) 2016年 e3mo. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "DefineKey.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationBar.barTintColor = SYS_UI_DEFINE_BG;
    }
    else {
        self.navigationBar.tintColor = SYS_UI_DEFINE_BG;
    }
    
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                          NSFontAttributeName:[UIFont systemFontOfSize:17],
                          };
    self.navigationBar.titleTextAttributes = dic;
    
}

@end
