//
//  JQGestureView.m
//  TTReplyView
//
//  Created by derek on 2018/5/30.
//  Copyright © 2018年 cckv. All rights reserved.
//

#import "JQGestureView.h"
#import "YYKit.h"
#import <Masonry.h>

@interface JQGestureNavView()

@end

@implementation JQGestureNavView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)layoutSubviews {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    [self.closeButton setImage:[UIImage imageNamed:@"close_nav_bar"] forState:UIControlStateNormal];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@10);
        make.height.equalTo(self.mas_height).multipliedBy(.6);
        make.width.equalTo(self.closeButton.mas_height);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
   
    UIImageView *line = [[UIImageView alloc] init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = [UIColor lightGrayColor];
    
}
- (void)close {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end

@interface JQGestureView()

@property (nonatomic, assign) BOOL isX;
@property (nonatomic, assign) BOOL isY;


@end

@implementation JQGestureView
- (instancetype)init
{
    self = [super init];
    if (self) {
         [self createUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    //更改bar颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
    [self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
    
    self.navView = [[JQGestureNavView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.navView];
    __weak typeof(self)weakSelf = self;
    self.navView.closeBlock = ^{
        [weakSelf close];
       
    };
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@49);
    }];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([@"center" isEqualToString:keyPath]) {
        if (self.top>20) {
            CGFloat effect = 1 - self.top/self.height;
            if (self.effectBlock) {
                self.effectBlock(effect);
            }
        }else if (self.left>0){
            CGFloat effect = 1 - self.left/self.width;
            if (self.effectBlock) {
                self.effectBlock(effect);
            }
        }
    }
}
- (void)close {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self removeObserver:self forKeyPath:@"center"];
    if (self.closeBlock) {
        self.closeBlock();
    }
}
- (void)addGesture {
    NSLog(@"%f",Top);
    UIPanGestureRecognizer *panGestureRecognizerRight = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGestureRecognizerRight];

}
- (void)pan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:sender.view];
    CGFloat  draggingY = 0.0;
    CGFloat  draggingX = 0.0;
    
    if (translation.y>0) {
        if (self.isX) {
            [self moveX:translation withX:YES withUIPanGestureRecognizer:sender];
            return;
        }
        self.isY = YES;
        draggingY = translation.y;
        self.center = CGPointMake(self.center.x, self.center.y + draggingY);
    
        [sender setTranslation:CGPointZero inView:sender.view];
        if (sender.state == UIGestureRecognizerStateEnded) {
           
             __weak typeof(self)weakSelf = self;
            if (self.top>self.height/2) {
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.top = weakSelf.height;
                } completion:^(BOOL finished) {
                    [weakSelf close];
                }];
            }else{
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.top = Top;
                } completion:^(BOOL finished) {
                    weakSelf.isY = NO;
                    weakSelf.isX = NO;
                }];
            }
        }
    }else if(translation.y<= 0){
        if (self.top < Top) {
            draggingY = 0;
        }else{
            draggingY = translation.y;
        }
       
        self.center = CGPointMake(self.center.x, self.center.y + draggingY);
        [sender setTranslation:CGPointZero inView:sender.view];
        if (sender.state == UIGestureRecognizerStateEnded) {
            __weak typeof(self)weakSelf = self;
            if (self.top>self.height/2) {
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.top = self.height;
                } completion:^(BOOL finished) {
                    [weakSelf close];
                }];
            }else{
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.top = Top;
                } completion:^(BOOL finished) {
                    weakSelf.isY = NO;
                    weakSelf.isX = NO;
                }];
            }
        }
    }
    if (translation.x>0) {
        if (self.isY) {
            [self moveX:translation withX:NO withUIPanGestureRecognizer:sender];
            return;
        }
        self.isX = YES;
        draggingX = translation.x;
        self.center = CGPointMake(self.center.x+draggingX, self.center.y);
        [sender setTranslation:CGPointZero inView:sender.view];
        if (sender.state == UIGestureRecognizerStateEnded) {
            __weak typeof(self)weakSelf = self;
            if (self.left>self.width/2) {
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.left = weakSelf.width;
                } completion:^(BOOL finished) {
                    [weakSelf close];
                }];
            }else{
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.left = 0;
                } completion:^(BOOL finished) {
                    weakSelf.isY = NO;
                    weakSelf.isX = NO;
                }];
            }
        }
    }else if(translation.x<= 0){
        if (self.left < 0) {
            draggingX = 0;
        }else{
            draggingX = translation.x;
        }
       
        
        self.center = CGPointMake(self.center.x+draggingX, self.center.y);
        [sender setTranslation:CGPointZero inView:sender.view];
        if (sender.state == UIGestureRecognizerStateEnded) {
           
            __weak typeof(self)weakSelf = self;
            if (self.left>self.width/2) {
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.left = weakSelf.width;
                } completion:^(BOOL finished) {
                    [weakSelf close];
                }];
            }else{
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.left = 0;
                } completion:^(BOOL finished) {
                    weakSelf.isY = NO;
                    weakSelf.isX = NO;
                }];
            }
        }
    }
}


- (void)moveX:(CGPoint)translation withX:(BOOL)isX withUIPanGestureRecognizer:(UIPanGestureRecognizer*)sender{
    
    CGFloat  draggingY = 0.0;
    CGFloat  draggingX = 0.0;
    
    if (isX) {
        draggingX = translation.x;
        self.center = CGPointMake(self.center.x+draggingX, self.center.y);
       
        
        [sender setTranslation:CGPointZero inView:sender.view];
        if (sender.state == UIGestureRecognizerStateEnded) {
            
            __weak typeof(self)weakSelf = self;
            if (self.left>self.width/2) {
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.left = weakSelf.width;
                } completion:^(BOOL finished) {
                   [weakSelf close];
                }];
            }else{
                
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.left = 0;
                } completion:^(BOOL finished) {
                    weakSelf.isY = NO;
                    weakSelf.isX = NO;
                }];
            }
        }
    }else{
        draggingY = translation.y;
        self.center = CGPointMake(self.center.x, self.center.y + draggingY);
        NSLog(@"drag:%f",draggingY);
       
        [sender setTranslation:CGPointZero inView:sender.view];
        if (sender.state == UIGestureRecognizerStateEnded) {
              __weak typeof(self)weakSelf = self;
            if (self.top>self.height/2) {
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.top = weakSelf.height;
                } completion:^(BOOL finished) {
                    [weakSelf close];
                }];
            }else{
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.top = Top;
                } completion:^(BOOL finished) {
                    weakSelf.isY = NO;
                    weakSelf.isX = NO;
                }];
            }
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
