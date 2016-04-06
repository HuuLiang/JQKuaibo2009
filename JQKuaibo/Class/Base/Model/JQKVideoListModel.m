//
//  JQKVideoListModel.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKVideoListModel.h"

@implementation JQKVideoListModel

+ (Class)responseClass {
    return [JQKVideos class];
}

- (BOOL)fetchVideosWithField:(JQKVideoListField)field
                      pageNo:(NSUInteger)pageNo
                    pageSize:(NSUInteger)pageSize
                    columnId:(NSNumber *)columnId
           completionHandler:(JQKCompletionHandler)handler
{
    @weakify(self);
    NSDictionary *params = @{@"Page":@(pageNo), @"PageSize":@(pageSize)};
    if (field == JQKVideoListFieldChannel ) {
        if (columnId == nil) {
            if (handler) {
                handler(NO, nil);
            }
            return NO;
        }
        
        NSMutableDictionary *modifiedParams = params.mutableCopy;
        [modifiedParams setObject:columnId forKey:@"CategoryId"];
        params = modifiedParams;
    }
    
    NSDictionary *urlPathMapping = @{@(JQKVideoListFieldVIP):JQK_VIP_VIDEO_URL,
                                     @(JQKVideoListFieldRecommend):JQK_RECOMMEND_VIDEO_URL,
                                     @(JQKVideoListFieldHot):JQK_HOT_VIDEO_URL,
                                     @(JQKVideoListFieldChannel):JQK_CHANNEL_PROGRAM_URL};
    
    BOOL success = [self requestURLPath:urlPathMapping[@(field)]
                             withParams:params
                        responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        JQKVideos *videos;
                        if (respStatus == JQKURLResponseSuccess) {
                            videos = self.response;
                            self.fetchedVideos = videos;
                        }
                        
                        if (handler) {
                            handler(respStatus==JQKURLResponseSuccess, videos);
                        }
                    }];
    return success;
}
@end
