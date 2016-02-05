//
//  JQKSystemConfigModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKSystemConfigModel.h"
#import "JQKSystemConfigItem.h"
#import "JQKSystemConfig.h"

@implementation JQKSystemConfigResponse

- (Class)confisElementClass {
    return [JQKSystemConfigItem class];
}

@end

@implementation JQKSystemConfigModel

+ (instancetype)sharedModel {
    static JQKSystemConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JQKSystemConfigModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [JQKSystemConfigResponse class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)fetchRemoteSystemConfigWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:JQK_SYSTEM_CONFIG_URL
                             withParams:nil
                        responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        JQKSystemConfig *config;
        if (respStatus == JQKURLResponseSuccess) {
            JQKSystemConfigResponse *resp = self.response;
            config = [[JQKSystemConfig alloc] initFromSystemConfigItems:resp.confis];
            config.loadedFromRemote = YES;
            [config saveAsDefaultConfig];
        }
        
        if (handler) {
            handler(respStatus==JQKURLResponseSuccess, config);
        }
    }];
    return success;
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(JQKCompletionHandler)handler {
    JQKSystemConfig *systemConfig = [JQKSystemConfig sharedConfig];
    if (systemConfig.loadedFromRemote) {
        if (handler) {
            handler(YES, systemConfig);
        }
        return YES;
    }
    
    return [self fetchRemoteSystemConfigWithCompletionHandler:handler];
}
@end
