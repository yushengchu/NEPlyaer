//
//  AppDelegate.m
//  NEPlyaer
//
//  Created by fhzx_mac on 2017/3/6.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayObj.h"
#import "PlayerShowView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlayerSuspend)name:@"PlayerSuspend" object:nil];
    return YES;
}


- (void)PlayerSuspend{
    NSLog(@"PlayerSuspend");
    PlayerShowView* View = [[PlayerShowView alloc]initWithFrame:CGRectMake(0, 100, self.window.width/2, self.window.width*0.6/2)
                                                 connectWithUrl:@"http://hls.quanmin.tv/live/3191756/playlist.m3u8"];
    View.isSuspend = true;
    [self.window addSubview:View];
    
        
        //创建拖拽手势
        UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(handlePanGestures:)];
        //无论最大还是最小都只允许一个手指
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [View addGestureRecognizer:panGestureRecognizer];
    
}

- (void) handlePanGestures:(UIPanGestureRecognizer*)paramSender{
    CGPoint point = [paramSender translationInView:[[UIApplication sharedApplication] keyWindow]];
    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    [paramSender setTranslation:CGPointMake(0, 0) inView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
