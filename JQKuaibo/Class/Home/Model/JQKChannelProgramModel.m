//
//  JQKChannelProgramModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKChannelProgramModel.h"

@implementation JQKChannelProgramResponse

@end

@implementation JQKChannelProgramModel

+ (Class)responseClass {
    return [JQKChannelProgramResponse class];
}

- (BOOL)fetchProgramsWithColumnId:(NSNumber *)columnId
                           pageNo:(NSUInteger)pageNo
                         pageSize:(NSUInteger)pageSize
                completionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"columnId":columnId, @"page":@(pageNo), @"pageSize":@(pageSize),@"scale":[JQKUtil isPaid]?@1:@2};
    BOOL success = [self requestURLPath:JQK_HOME_CHANNEL_PROGRAM_URL
                             withParams:params
                        responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        JQKChannelPrograms *programs;
        if (respStatus == JQKURLResponseSuccess) {
            programs = (JQKChannelProgramResponse *)self.response;
            self.fetchedPrograms = programs;
        }
        
        if (handler) {
            handler(respStatus==JQKURLResponseSuccess, programs);
        }
    }];
    return success;
}

@end
