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
                      pageNo:(NSInteger)pageNo
                    pageSize:(NSInteger)pageSize
                    columnId:(NSString *)columnId
           completionHandler:(JQKCompletionHandler)handler
{
    @weakify(self);

    NSDictionary * params = nil;
    NSString * url = nil;
    if (field == JQKVideoListFieldChannel) {
        params = @{@"columnId":columnId,
                   @"page":[NSString stringWithFormat:@"%ld",pageNo]
                   };
        url = JQK_CHANNEL_PROGRAM_URL;
    } else if (field == JQKVideoListFieldHot) {
        params = @{@"page":[NSString stringWithFormat:@"%ld",pageNo]};
        url = JQK_HOT_VIDEO_URL;
    } 
    
    BOOL success = [self requestURLPath:url
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        JQKVideos *videos;
                        if (respStatus == QBURLResponseSuccess) {
                            videos = self.response;
                            self.fetchedVideos = videos;
                        }
                        
                        if (handler) {
                            handler(respStatus==QBURLResponseSuccess, videos);
                        }
                    }];
    return success;
}

- (BOOL)fetchVideosDetailsPageWithColumnId:(NSString *)columnId
                                 programId:(NSString *)programId
                         CompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"columnId":columnId,
                             @"programId":programId
                             };
    BOOL success = [self requestURLPath:JQK_RECOMMEND_VIDEO_URL
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        JQKVideos *videos;
        if (respStatus == QBURLResponseSuccess) {
            videos = self.response;
            self.fetchedVideos = videos;
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess, videos);
        }
        
    }];
    return success;
}

- (BOOL)fetchPhotosWithPageNo:(NSInteger)pageNo
                     columnId:(NSString *)columnId
            completionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"columnId":columnId};
    BOOL success = [self requestURLPath:JQK_CHANNEL_PROGRAM_URL
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        if (!self) {
                            return ;
                        }
                        
                        JQKVideos *videos;
                        if (respStatus == QBURLResponseSuccess) {
                            videos = self.response;
                            self.fetchedVideos = videos;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess, videos);
                        }
                    }];
    return success;
}

@end
