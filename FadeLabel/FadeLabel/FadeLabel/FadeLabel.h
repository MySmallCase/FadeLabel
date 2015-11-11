//
//  FadeLabel.h
//  FadeLabel
//
//  Created by MyMac on 15/11/11.
//  Copyright © 2015年 MyMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FadeLabel : UILabel

//淡入文字动画持续时间 默认2.5s
@property (assign, nonatomic, readwrite) CFTimeInterval shineDuration;

//淡出文字动画持续时间  默认2.5s
@property (assign, nonatomic, readwrite) CFTimeInterval fadeOutDuration;

//自动播放动画 默认为NO
@property (assign, nonatomic, readwrite, getter = isAutoStart) BOOL autoStart;

//检查动画是否结束
@property (assign, nonatomic, readonly, getter = isShining) BOOL shining;

//检查是否可见
@property (assign, nonatomic, readonly, getter = isVisible) BOOL visible;


- (void)fade;
- (void)fadeWithCompletion:(void (^)())completion;
- (void)fadeOut;
- (void)fadeOutWithCompletion:(void (^)())completion;

@end
