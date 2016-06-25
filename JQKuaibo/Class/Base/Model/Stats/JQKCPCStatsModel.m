//
//  JQKCPCStatsModel.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKCPCStatsModel.h"

@implementation JQKCPCStatsModel

- (BOOL)statsCPCWithStatsInfos:(NSArray<JQKStatsInfo *> *)statsInfos
             completionHandler:(JQKCompletionHandler)completionHandler
{
    NSArray<NSDictionary *> *params = [self validateParamsWithStatsInfos:statsInfos];
    if (params.count == 0) {
        SafelyCallBlock(completionHandler, NO, @"No validated statsInfos to Commit!");
        return NO;
    }

    BOOL ret = [self requestURLPath:JQK_STATS_CPC_URL
                         withParams:params
                    responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
                {
                    SafelyCallBlock(completionHandler, respStatus==JQKURLResponseSuccess, errorMessage);
                }];
    return ret;
}

@end
