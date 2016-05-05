//
//  DefineKey.h
//
//
//  Created by e3mo on 16/5/5.
//  Copyright (c) 2016年 times. All rights reserved.
//

#ifndef _DefineKey_h
#define _DefineKey_h


//屏幕尺寸
#define SYS_UI_WINSIZE_WIDTH                        [[UIScreen mainScreen] bounds].size.width
#define SYS_UI_BASE_WIDTH                           320.f
#define SYS_UI_WIDTH_RADIO                          (SYS_UI_WINSIZE_WIDTH/SYS_UI_BASE_WIDTH)
#define SYS_UI_SCALE_WIDTH_SIZE(ScaleSize)          (SYS_UI_WIDTH_RADIO*ScaleSize)


//系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



//颜色
#define SYS_UI_COLOR(r,g,b,a)                       [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]


#define SYS_UI_DEFINE_BG                            SYS_UI_COLOR(57,212,85,1)

//字体颜色
#define SYS_UI_DARK_GRAY_COLOR                      SYS_UI_COLOR(51,51,51,1)
#define SYS_UI_NORMAL_GRAY_COLOR                    SYS_UI_COLOR(102,102,102,1)
#define SYS_UI_LIGHT_GRAY_COLOR                     SYS_UI_COLOR(153,153,153,1)




#endif
