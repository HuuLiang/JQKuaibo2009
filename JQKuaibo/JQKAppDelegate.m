//
//  JQKAppDelegate.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKAppDelegate.h"
#import "JQKHomeViewController.h"
#import "JQKLiveShowViewController.h"
#import "JQKMoreViewController.h"
#import "MobClick.h"
#import "JQKActivateModel.h"
#import "JQKUserAccessModel.h"
#import "JQKPaymentModel.h"
#import "JQKSystemConfigModel.h"
#import "JQKPaymentViewController.h"
#import "JQKChannelViewController.h"
#import "JQKMineViewController.h"

@interface JQKAppDelegate ()

@end

@implementation JQKAppDelegate

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    _window                              = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor              = [UIColor whiteColor];
    
    JQKHomeViewController *homeVC        = [[JQKHomeViewController alloc] init];
    homeVC.title                         = @"乐播";
    
    UINavigationController *homeNav      = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    UIImage *homeImage                   = [UIImage imageNamed:@"home_tabbar"];
    homeNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:homeVC.title
                                                                         image:homeImage
                                                                 selectedImage:[homeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JQKLiveShowViewController *liveShowVC = [[JQKLiveShowViewController alloc] init];
    liveShowVC.title                      = @"主播";

    UINavigationController *liveShowNav   = [[UINavigationController alloc] initWithRootViewController:liveShowVC];

    UIImage *liveShowImage                = [UIImage imageNamed:@"show_tabbar"];
    liveShowNav.tabBarItem                = [[UITabBarItem alloc] initWithTitle:liveShowVC.title
                                                                          image:liveShowImage
                                                                  selectedImage:[liveShowImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JQKChannelViewController *channelVC = [[JQKChannelViewController alloc] init];
    channelVC.title                     = @"频道";

    UINavigationController *channelNav  = [[UINavigationController alloc] initWithRootViewController:channelVC];
    UIImage *channelImage               = [UIImage imageNamed:@"channel_tabbar"];
    channelNav.tabBarItem               = [[UITabBarItem alloc] initWithTitle:channelVC.title
                                                                           image:channelImage
                                                                   selectedImage:[channelImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
//    JQKMineViewController *mineVC        = [[JQKMineViewController alloc] init];
//    mineVC.title                         = @"我的";
//    
//    UINavigationController *mineNav      = [[UINavigationController alloc] initWithRootViewController:mineVC];
//    mineNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:mineVC.title
//                                                                          image:[[UIImage imageNamed:@"mine_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                                                 selectedImage:[[UIImage imageNamed:@"mine_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JQKMoreViewController *moreVC        = [[JQKMoreViewController alloc] init];
    moreVC.title                         = @"更多";
    
    UINavigationController *moreNav      = [[UINavigationController alloc] initWithRootViewController:moreVC];
    UIImage *moreImage                   = [UIImage imageNamed:@"more_tabbar"];
    moreNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:moreVC.title
                                                                         image:moreImage
                                                                 selectedImage:[moreImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JQKMineViewController *mineVC        = [[JQKMineViewController alloc] init];
    mineVC.title                         = @"会员";
    
    UINavigationController *mineNav      = [[UINavigationController alloc] initWithRootViewController:mineVC];
    UIImage *mineImage                   = [UIImage imageNamed:@"mine_tabbar"];
    mineNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                                         image:mineImage
                                                                 selectedImage:[mineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    UITabBarController *tabBarController    = [[UITabBarController alloc] init];
    tabBarController.viewControllers        = @[homeNav,liveShowNav,channelNav,moreNav,mineNav];
    _window.rootViewController              = tabBarController;
    return _window;
}

- (void)setupCommonStyles {
    //[[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.95 alpha:1]]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:@"#ff59a1"]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *thisVC = [aspectInfo instance];
                                   thisVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:nil];
                               } error:nil];
    
//    [UINavigationController aspect_hookSelector:@selector(preferredStatusBarStyle)
//                                    withOptions:AspectPositionInstead
//                                     usingBlock:^(id<AspectInfo> aspectInfo){
//                                         UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
//                                         [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
//                                     } error:nil];
//    
//    [UIViewController aspect_hookSelector:@selector(preferredStatusBarStyle)
//                              withOptions:AspectPositionInstead
//                               usingBlock:^(id<AspectInfo> aspectInfo){
//                                   UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
//                                   [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
//                               } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(shouldAutorotate)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     BOOL autoRotate = NO;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         autoRotate = [((UINavigationController *)selectedVC).topViewController shouldAutorotate];
                                     } else {
                                         autoRotate = [selectedVC shouldAutorotate];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&autoRotate];
                                 } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(supportedInterfaceOrientations)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     NSUInteger result = 0;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         result = [((UINavigationController *)selectedVC).topViewController supportedInterfaceOrientations];
                                     } else {
                                         result = [selectedVC supportedInterfaceOrientations];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&result];
                                 } error:nil];
    
}

- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (bundleVersion) {
        [MobClick setAppVersion:bundleVersion];
    }
    [MobClick startWithAppkey:JQK_UMENG_APP_ID reportPolicy:BATCH channelId:JQK_CHANNEL_NO];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[JQKPaymentManager sharedManager] setup];
    [[JQKErrorHandler sharedHandler] initialize];
    [self setupMobStatistics];
    [self setupCommonStyles];
    [self.window makeKeyWindow];
    self.window.hidden = NO;
    
    if (![JQKUtil isRegistered]) {
        [[JQKActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
            if (success) {
                [JQKUtil setRegisteredWithUserId:userId];
                [[JQKUserAccessModel sharedModel] requestUserAccess];
            }
        }];
    } else {
        [[JQKUserAccessModel sharedModel] requestUserAccess];
    }
    
    [[JQKPaymentModel sharedModel] startRetryingToCommitUnprocessedOrders];
    [[JQKSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        if (!success) {
            return ;
        }
        
        if ([JQKSystemConfigModel sharedModel].startupInstall.length == 0
            || [JQKSystemConfigModel sharedModel].startupPrompt.length == 0) {
            return ;
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[JQKSystemConfigModel sharedModel].startupInstall]];
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (![JQKUtil isPaid]) {
        [[JQKPaymentManager sharedManager] checkPayment];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[JQKPaymentManager sharedManager] handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[JQKPaymentManager sharedManager] handleOpenURL:url];
    return YES;
}
@end
