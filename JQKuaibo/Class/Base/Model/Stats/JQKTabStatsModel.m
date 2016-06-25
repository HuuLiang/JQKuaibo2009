//
//  JQKTabStatsModel.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKTabStatsModel.h"

@implementation JQKTabStatsModel

- (BOOL)statsTabWithStatsInfos:(NSArray<JQKStatsInfo *> *)statsInfos
             completionHandler:(JQKCompletionHandler)completionHandler
{
    NSArray<NSDictionary *> *params = [self validateParamsWithStatsInfos:statsInfos];
    if (params.count == 0) {
        SafelyCallBlock(completionHandler,NO,@"No validated statsInfos to Commit!");
        return NO;
    }
    
    BOOL ret = [self requestURLPath:JQK_STATS_TAB_URL
                         withParams:params
                    responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock(completionHandler, respStatus == JQKURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
