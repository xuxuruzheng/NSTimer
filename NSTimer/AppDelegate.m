//
//  AppDelegate.m
//  NSTimer
//
//  Created by 三米 on 16/11/14.
//  Copyright © 2016年 三米. All rights reserved.
//

#import "AppDelegate.h"
#import "SvTestObject.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"SvTimerSample Will resign Avtive!");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //NSThread 创建一个子线程
    [NSThread detachNewThreadSelector:@selector(testTimerSheduleToRunloop1) toTarget:self withObject:nil];
    
    
//    [self testTimerWithOutShedule];
}

// NSTimer加到了RunLoop中但迟迟的不触发事件
//原因主要有以下两个:
//1、runloop是否运行
//每一个线程都有它自己的runloop，程序的主线程会自动的使runloop生效，但对于我们自己新建的线程，它的runloop是不会自己运行起来，当我们需要使用它的runloop时，就得自己启动。
- (void)testTimerSheduleToRunloop1
{
    NSLog(@"Test timer shedult to a non-running runloop");
    SvTestObject *testObject4 = [[SvTestObject alloc] init];
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:1 target:testObject4 selector:@selector(timerAction:) userInfo:nil repeats:NO];
    //把timer加到runloop中
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    // 打开下面一行输出runloop的内容就可以看出，timer确实已经被添加进去
    //NSLog(@"the thread's runloop: %@", [NSRunLoop currentRunLoop]);
    
    // 打开下面一行, 该线程的runloop就会运行起来，timer才会起作用 //手动启动RunLoop
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    
    NSLog(@"invoke release to testObject4");
    
}

//timer不会启动
- (void)testTimerWithOutShedule
{
    NSLog(@"Test timer without shedult to runloop");
    SvTestObject *testObject3 = [[SvTestObject alloc] init];
    //距离现在1秒钟后
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:1 target:testObject3 selector:@selector(timerAction:) userInfo:nil repeats:NO];
    
    NSLog(@"invoke release to testObject3");
}

-(void)timerAction:(NSString *)str
{
    NSLog(@"timer执行");
}
//综上: 要让timer生效，必须保证该线程的runloop已启动，而且其运行的runloopmode也要匹配。


//- (void)applicationWillTerminate:(UIApplication *)application {
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    // Saves changes in the application's managed object context before the application terminates.
//    [self saveContext];
//}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.sanmi.NSTimer" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NSTimer" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NSTimer.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
