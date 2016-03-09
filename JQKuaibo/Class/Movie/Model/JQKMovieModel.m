//
//  JQKMovieModel.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKMovieModel.h"

@implementation JQKMovieModel

+ (Class)responseClass {
    return [JQKVideos class];
}

- (BOOL)fetchMoviesInPage:(NSUInteger)page withCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:JQK_MOVIE_URL
                         withParams:@{@"page":@(page)}
                    responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        JQKVideos *videos;
        if (respStatus == JQKURLResponseSuccess) {
            videos = self.response;
            self->_fetchedVideos = videos;
        }
        
        if (handler) {
            handler(respStatus==JQKURLResponseSuccess, videos);
        }
    }];
    return ret;
}
@end
