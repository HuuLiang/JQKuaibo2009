//
//  JQKSystemConfigModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKSystemConfigModel.h"

@implementation JQKSystemConfigResponse

- (Class)confisElementClass {
    return [JQKSystemConfig class];
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

- (BOOL)fetchSystemConfigWithCompletionHandler:(JQKFetchSystemConfigCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:JQK_SYSTEM_CONFIG_URL
                             withParams:nil
                        responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        if (respStatus == JQKURLResponseSuccess) {
            JQKSystemConfigResponse *resp = self.response;
            
            [resp.confis enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                JQKSystemConfig *config = obj;
                
                if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_PAY_AMOUNT]) {
                    self.payAmount = config.value.doubleValue / 100.;
                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_PAYMENT_TOP_IMAGE]) {
                    self.channelTopImage = config.value;
                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_STARTUP_INSTALL]) {
                    self.startupInstall = config.value;
                    self.startupPrompt = config.memo;
                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_TOP_IMAGE]) {
                    self.spreadTopImage = config.value;
                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_URL]) {
                    self.spreadURL = config.value;
                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_LEFT_IMAGE]) {
                    self.spreadLeftImage = config.value;
                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_LEFT_URL]) {
                    self.spreadLeftUrl = config.value;
                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_RIGHT_IMAGE]) {
                    self.spreadRightImage = config.value;
                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_RIGHT_URL]) {
                    self.spreadRightUrl = config.value;
                }
            }];
            
            _loaded = YES;
        }
        
        if (handler) {
            handler(respStatus==JQKURLResponseSuccess);
        }
    }];
    return success;
}

@end
