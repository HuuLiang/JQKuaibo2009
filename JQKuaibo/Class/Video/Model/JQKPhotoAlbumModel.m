//
//  JQKPhotoAlbumModel.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPhotoAlbumModel.h"

@implementation JQKPhotoAlbumResponse

- (Class)AtlasElementClass {
    return [JQKChannel class];
}

@end

@implementation JQKPhotoAlbumModel

+ (Class)responseClass {
    return [JQKPhotoAlbumResponse class];
}

- (BOOL)fetchAlbumsWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize completionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:JQK_PHOTO_ALBUM_URL
                         withParams:@{@"Page":@(page), @"PageSize":@(pageSize)}
                    responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        NSArray *albums;
        if (respStatus == JQKURLResponseSuccess) {
            JQKPhotoAlbumResponse *resp = self.response;
            albums = resp.Atlas;
            self->_fetchedAlbums = albums;
        }
        
        if (handler) {
            handler(respStatus==JQKURLResponseSuccess, albums);
        }
    }];
    return ret;
}

@end
