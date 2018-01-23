//
//  JQKNetworkInfo.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/5/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JQKNetworkStatus) {
    JQKNetworkStatusUnknown = -1,
    JQKNetworkStatusNotReachable = 0,
    JQKNetworkStatusWiFi = 1,
    JQKNetworkStatus2G = 2,
    JQKNetworkStatus3G = 3,
    JQKNetworkStatus4G = 4
};

@interface JQKNetworkInfo : NSObject

@property (nonatomic,readonly) JQKNetworkStatus networkStatus;
@property (nonatomic,readonly) NSString *carriarName;

+ (instancetype)sharedInfo;
- (void)startMonitoring;

@end
