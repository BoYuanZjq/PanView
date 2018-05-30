//
//  TestView.m
//  PanView
//
//  Created by derek on 2018/5/30.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "TestView.h"

@implementation TestView
- (void)dealloc {
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.navView.titleLabel.text = @"我的";
        [self addGesture];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
