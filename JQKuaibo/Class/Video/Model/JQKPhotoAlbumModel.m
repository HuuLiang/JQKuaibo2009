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
    NSString *urlPath = [NSString stringWithFormat:JQK_PHOTO_ALBUM_URL, pageSize, page];
    BOOL ret = [self requestURLPath:urlPath
                         withParams:nil
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
