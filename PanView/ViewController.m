//
//  ViewController.m
//  PanView
//
//  Created by derek on 2018/5/30.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "ViewController.h"
#import "TestView.h"
#import "YYKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)startEvent:(id)sender {
   __block UIView *bgView = [UIView new];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    [self.navigationController.view addSubview:bgView];
    bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    
    TestView *testView = [[TestView alloc] init];
    __block TestView *tempView = testView;
    testView.effectBlock = ^(CGFloat alpha) {
        NSLog(@"%f",alpha);
        bgView.alpha = alpha;
    };
    testView.closeBlock = ^{
        [tempView removeFromSuperview];
        tempView = nil;
       
        [bgView removeFromSuperview];
        bgView = nil;
    };
    
    [self.navigationController.view addSubview:testView];
    testView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-10);
    [UIView animateWithDuration:0.25 animations:^{
        testView.top = Top;
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
