//
//  JQGestureView.h
//  TTReplyView
//
//  Created by derek on 2018/5/30.
//  Copyright © 2018年 cckv. All rights reserved.
//

#import <UIKit/UIKit.h>
// 距离顶端的距离
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define Top (kDevice_Is_iPhoneX ? 30.f:20.f)


@interface JQGestureNavView:UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
//关闭
typedef void(^CloseBolok)(void);
@property (nonatomic, copy) CloseBolok closeBlock;


@end



@interface JQGestureView : UIView
//关闭
typedef void(^CloseBolok)(void);
@property (nonatomic, copy) CloseBolok closeBlock;

//透明度
typedef void(^EffectBlock)(CGFloat alpha);
@property (nonatomic, copy)EffectBlock effectBlock;

@property (nonatomic, strong) JQGestureNavView *navView;

- (void)addGesture;

@end
