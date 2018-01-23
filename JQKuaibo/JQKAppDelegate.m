//
//  JQKAppDelegate.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKAppDelegate.h"
#import "JQKHomeViewController.h"
#import "JQKVideoListViewController.h"
#import "JQKMoreViewController.h"
#import "MobClick.h"
#import "JQKActivateModel.h"
#import "JQKUserAccessModel.h"
#import "JQKSystemConfigModel.h"
#import "JQKPaymentViewController.h"
#import "JQKChannelViewController.h"
#import "JQKMineViewController.h"
#import "JQKGetCommentsInfo.h"
#import "JQKLaunchView.h"
#import <QBNetworkingConfiguration.h>


@interface JQKAppDelegate ()<UITabBarControllerDelegate>

@end

@implementation JQKAppDelegate

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    _window                              = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor              = [UIColor whiteColor];
    
    JQKHomeViewController *homeVC        = [[JQKHomeViewController alloc] init];
    homeVC.title                         = @"快播";
    
    UINavigationController *homeNav      = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:homeVC.title
                                                                         image:[UIImage imageNamed:@"home_normal"]
                                                                 selectedImage:[UIImage imageNamed:@"home_selected"]];
    
    JQKVideoListViewController *hotVideoVC = [[JQKVideoListViewController alloc] initWithField:JQKVideoListFieldHot];
    hotVideoVC.title                       = @"无码";

    UINavigationController *liveShowNav   = [[UINavigationController alloc] initWithRootViewController:hotVideoVC];
    liveShowNav.tabBarItem                = [[UITabBarItem alloc] initWithTitle:hotVideoVC.title
                                                                          image:[UIImage imageNamed:@"show_normal"]
                                                                  selectedImage:[UIImage imageNamed:@"show_selected"]];
    
    JQKChannelViewController *channelVC = [[JQKChannelViewController alloc] init];
    channelVC.title                     = @"频道";

    UINavigationController *channelNav  = [[UINavigationController alloc] initWithRootViewController:channelVC];
    channelNav.tabBarItem               = [[UITabBarItem alloc] initWithTitle:channelVC.title
                                                                           image:[UIImage imageNamed:@"channel_normal"]
                                                                   selectedImage:[UIImage imageNamed:@"channel_selected"]];
    
    JQKMoreViewController *moreVC        = [[JQKMoreViewController alloc] init];
    moreVC.title                         = @"约吧";
    
    UINavigationController *moreNav      = [[UINavigationController alloc] initWithRootViewController:moreVC];
    moreNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:moreVC.title
                                                                         image:[UIImage imageNamed:@"more_normal"]
                                                                 selectedImage:[UIImage imageNamed:@"more_selected"]];
    
    JQKMineViewController *mineVC        = [[JQKMineViewController alloc] init];
    mineVC.title                         = @"会员";
    
    UINavigationController *mineNav      = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                                         image:[UIImage imageNamed:@"mine_normal"]
                                                                 selectedImage:[UIImage imageNamed:@"mine_selected"]];

    UITabBarController *tabBarController    = [[UITabBarController alloc] init];
    tabBarController.viewControllers        = @[homeNav,channelNav,liveShowNav,moreNav,mineNav];
    tabBarController.delegate = self;
    _window.rootViewController              = tabBarController;
    return _window;
}

- (void)setupCommonStyles {
    //[[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.95 alpha:1]]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
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

- (void)registerUserNotification {
    if (NSClassFromString(@"UIUserNotificationSettings")) {
        UIUserNotificationType notiType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:notiType categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notiSettings];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Override point for customization after application launch.
    [QBNetworkingConfiguration defaultConfiguration].baseURL = JQK_BASE_URL;
    [QBNetworkingConfiguration defaultConfiguration].channelNo = JQK_CHANNEL_NO;
    [QBNetworkingConfiguration defaultConfiguration].RESTpV = JQK_REST_PV;
    [QBNetworkingConfiguration defaultConfiguration].RESTAppId = JQK_REST_APP_ID;
#ifdef DEBUG
    [QBNetworkingConfiguration defaultConfiguration].logEnabled = YES;
    [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];
#endif
    [[QBPaymentManager sharedManager] registerPaymentWithAppId:JQK_REST_APP_ID
                                                     paymentPv:JQK_PAYMENT_PV
                                                     channelNo:JQK_CHANNEL_NO
                                                     urlScheme:@"comdaoguokbingyuan2016appalipayurlscheme"];
    
    [JQKUtil accumateLaunchSeq];
    [[JQKGetCommentsInfo sharedInstance] getComents];
    [[JQKErrorHandler sharedHandler] initialize];
    [self setupMobStatistics];
    [self setupCommonStyles];
//    [self registerUserNotification];
    [[JQKNetworkInfo sharedInfo] startMonitoring];
    [self.window makeKeyWindow];
    self.window.hidden = NO;
    
    JQKLaunchView *launchView = [[JQKLaunchView alloc] init];
    [launchView show];
    
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
    
    [[JQKSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        
        
        NSUInteger statsTimeInterval = 180;
        if ([JQKSystemConfigModel sharedModel].loaded && [JQKSystemConfigModel sharedModel].statsTimeInterval > 0) {
            statsTimeInterval = [JQKSystemConfigModel sharedModel].statsTimeInterval;
        }
//                statsTimeInterval = 20;
        [[JQKStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        
        if ([JQKSystemConfigModel sharedModel].notificationLaunchSeq >0) {
            [self registerUserNotification];
        }
        
        if (!success) {
            return ;
        }
        
        NSInteger halfPayLaunchSeq = [JQKSystemConfigModel sharedModel].halfPayLaunchSeq;
        if (halfPayLaunchSeq >= 0 && [JQKUtil launchSeq] == halfPayLaunchSeq) {
            NSString *halfPayLaunchNotification = [JQKSystemConfigModel sharedModel].halfPayLaunchNotification;
            NSString *repeatTimeString = [JQKSystemConfigModel sharedModel].halfPayNotiRepeatTimes;
            NSArray<NSString *> *repeatTimeStrings = [repeatTimeString componentsSeparatedByString:@";"];
            [[JQKLocalNotificationManager sharedManager] scheduleRepeatNotification:halfPayLaunchNotification withTimes:repeatTimeStrings];
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
    if ([JQKUtil isPaid]) {
        return ;
    }
    
    UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        DLog(@"Application expired background task!");
        [application endBackgroundTask:bgTask];
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger halfPayLaunchSeq = [JQKSystemConfigModel sharedModel].halfPayLaunchSeq;
        if (halfPayLaunchSeq >= 0 && [JQKUtil launchSeq] >= halfPayLaunchSeq) {
            NSString *halfPayLaunchNotification = [JQKSystemConfigModel sharedModel].halfPayLaunchNotification;
            NSInteger delay = [JQKSystemConfigModel sharedModel].halfPayLaunchDelay;
            if (halfPayLaunchNotification.length > 0 && delay >= 0) {
                [[JQKLocalNotificationManager sharedManager] scheduleLocalNotification:halfPayLaunchNotification withDelay:delay];
                DLog(@"Schedule local notification %@ with delay %ld", halfPayLaunchNotification, delay);
            }
        }
    });

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[QBPaymentManager sharedManager] applicationWillEnterForeground:application];
    //    if (![YYKUtil isAllVIPs]) {
    //        [[YYKPaymentManager sharedManager] checkPayment];
    //    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    DLog(@"receive local notification");
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [[JQKStatsManager sharedManager] statsTabIndex:tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex] forClickCount:1];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[JQKStatsManager sharedManager] statsStopDurationAtTabIndex:tabBarController.selectedIndex subTabIndex:[JQKUtil currentSubTabPageIndex]];
    return YES;
}
@end
