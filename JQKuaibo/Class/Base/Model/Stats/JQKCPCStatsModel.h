//
//  JQKCPCStatsModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKStatsBaseModel.h"

@interface JQKCPCStatsModel : JQKStatsBaseModel

- (BOOL)statsCPCWithStatsInfos:(NSArray<JQKStatsInfo *> *)statsInfos
             completionHandler:(JQKCompletionHandler)completionHandler;

@end
