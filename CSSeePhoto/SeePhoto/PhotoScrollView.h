//
//  PhotoScrollView.h
//  
//
//  Created by e3mo on 16/5/5.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollView : UIScrollView <UIGestureRecognizerDelegate> {
    
}
@property (nonatomic,strong) UIView *childView;
@property (nonatomic,copy) void (^stopScrollView) (void);
@property (nonatomic,copy) void (^startScrollView) (void);


@end
