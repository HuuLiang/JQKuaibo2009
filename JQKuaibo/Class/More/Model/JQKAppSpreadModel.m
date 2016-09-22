//
//  JQKAppSpreadModel.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKAppSpreadModel.h"

@implementation JQKAppSpread

@end

@implementation JQKAppSpreadResponse

- (Class)programListElementClass {
    return [JQKAppSpread class];
}
@end

@implementation JQKAppSpreadModel

+ (Class)responseClass {
    return [JQKAppSpreadResponse class];
}

- (BOOL)fetchAppSpreadWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:JQK_APP_SPREAD_LIST_URL
                         withParams:nil
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    NSArray *fetchedSpreads;
                    if (respStatus == QBURLResponseSuccess) {
                        JQKAppSpreadResponse *resp = self.response;
                        _fetchChannels = resp;
                        _fetchedSpreads = resp.programList;
                        fetchedSpreads = _fetchedSpreads;
                        
                    }
                    
                    if (handler) {
                        handler(respStatus==QBURLResponseSuccess, fetchedSpreads);
                    }
                }];
    return ret;
}

@end
