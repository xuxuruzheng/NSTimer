//
//  ViewController.m
//  NSTimer
//
//  Created by 三米 on 16/11/14.
//  Copyright © 2016年 三米. All rights reserved.
//

#import "ViewController.h"
#import "AViewController.h"


/**
 * 这里讲述了NSTimer的使用
 * 手动将timer加载到runloop中的方法在AppDelegate中
 * 代码是从：http://www.jianshu.com/p/3ccdda0679c1 来的
 * 如果看不懂的话可以参照这篇文章！
 *
 */

@interface ViewController ()

@property (nonatomic, assign) int allTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    _button.backgroundColor = [UIColor redColor];
    [_button addTarget:self action:@selector(kaiShiJiShi:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_button];
    

    
}
- (void)kaiShiJiShi:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    self.button.backgroundColor = [UIColor lightGrayColor];
    //总时长
    self.allTime = 6;
    //开始倒计时
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    NSString *time = [NSString stringWithFormat:@"%d",self.allTime];
    [sender setTitle:time forState:(UIControlStateNormal)];
    
    [self performSelector:@selector(simulateBusy) withObject:nil afterDelay:3];
    
}

//加了一个很大的循环，模拟线程堵塞问题，反映NSTimer不是绝对准确的,而且中间耗时或阻塞错过下一个点,那么下一个点就pass过去了.
- (void)simulateBusy{
    NSLog(@"start simulate busy!");
    NSInteger cacu = 0x0FFFFFFF;
    CGFloat uselessValue = 0;
    for (NSUInteger i = 0; i < cacu; i++) {
        uselessValue = i / 0.3333;
    }
    NSLog(@"finish simulate busy!");
}

- (void)timeFireMethod {
    self.allTime --;
    NSString *time = [NSString stringWithFormat:@"%d",self.allTime];
    [self.button setTitle:time forState:UIControlStateNormal];
    if (self.allTime == 0) {
        // 从运行循环中移除，对运行循环的引用进行一次 release
        [self.timer invalidate];
        // 将销毁定时器
        self.timer = nil;
        
        self.button.userInteractionEnabled = YES;
        self.button.backgroundColor = [UIColor redColor];
        [self.button setTitle:@"计时结束" forState:UIControlStateNormal];
        AViewController *avc = [[AViewController alloc]init];
        [self presentViewController:avc animated:YES completion:nil];
    }
    
}

//NSTimer 的使用

/** 
 //不重复，只调用一次。timer运行一次就会自动停止运行
 myTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];
 
 需要重复调用， repeats参数改为 YES . ---> 定时器的模式是默认的
 //每1秒运行一次function方法。
 timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
 
 注意点：
 将计数器的repeats设置为YES的时候，self的引用计数会加1。
 因此可能会导致self（即viewController）不能release。
 所以，必须在viewWillAppear的时候，将计数器timer停止，否则可能会导致内存泄露。
 
 
 //取消定时器
 [timer invalidate];   // 将定时器从运行循环中移除，
 timer = nil;    // 销毁定时器 ---》 这样可以避免控制器不死
 
 
 要想实现：先停止，然后再某种情况下再次开启运行timer，可以使用下面的方法：
 首先关闭定时器不能使用上面的方法，应该使用下面的方法：
 //关闭定时器
 [myTimer setFireDate:[NSDate distantFuture]];
 
 然后就可以使用下面的方法再此开启这个timer了：
 //开启定时器
 [myTimer setFireDate:[NSDate distantPast]];
 
 
 例子：比如，在页面消失的时候关闭定时器，然后等页面再次打开的时候，又开启定时器。
 （主要是为了防止它在后台运行，暂用CPU）可以使用下面的代码实现：
 
 //页面将要进入前台，开启定时器
 -(void)viewWillAppear:(BOOL)animated
 {
 //开启定时器
 [scrollView.myTimer setFireDate:[NSDate distantPast]];
 }
 
 //页面消失，进入后台不显示该页面，关闭定时器
 -(void)viewDidDisappear:(BOOL)animated
 {
 //关闭定时器
 [scrollView.myTimer setFireDate:[NSDate distantFuture]];
 }
 */

/**注意点：
 [timer invalidate]是唯一的方法将定时器从循环池中移除
 NSTimer可以精确到50-100毫秒.
 NSTimeInterval类：是一个浮点数字，用来定义秒
 NSTimer不是绝对准确的,而且中间耗时或阻塞错过下一个点,那么下一个点就pass过去了.
 */


@end
