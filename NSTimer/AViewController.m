//
//  AViewController.m
//  NSTimer
//
//  Created by 三米 on 16/11/15.
//  Copyright © 2016年 三米. All rights reserved.
//

#import "AViewController.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"dealloc:%@",[self class]);
}

@end
