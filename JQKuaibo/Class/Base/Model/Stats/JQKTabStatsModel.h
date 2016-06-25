//
//  JQKTabStatsModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKStatsBaseModel.h"

@interface JQKTabStatsModel : JQKStatsBaseModel

- (BOOL)statsTabWithStatsInfos:(NSArray<JQKStatsInfo *> *)statsInfos completionHandler:(JQKCompletionHandler)completionHandler;

@end
