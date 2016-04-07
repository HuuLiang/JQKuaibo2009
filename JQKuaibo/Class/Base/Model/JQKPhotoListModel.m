//
//  JQKPhotoListModel.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPhotoListModel.h"

@implementation JQKPhotoListModel

+ (Class)responseClass {
    return [JQKPhotos class];
}

- (BOOL)fetchPhotosWithAlbumId:(NSString *)albumId page:(NSUInteger)page pageSize:(NSUInteger)pageSize completionHandler:(JQKCompletionHandler)handler {
    if (albumId == nil) {
        if (handler) {
            handler(NO, nil);
        }
        return NO;
    }
    
    @weakify(self);
    NSString *urlPath = [NSString stringWithFormat:JQK_PHOTO_LIST_URL, albumId.integerValue, pageSize, page];
    BOOL success = [self requestURLPath:urlPath
                             withParams:nil
                        responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        JQKPhotos *photos;
        if (respStatus == JQKURLResponseSuccess) {
            photos = self.response;
            self->_fetchedPhotos = photos;
        }
        
        if (handler) {
            handler(respStatus == JQKURLResponseSuccess, photos);
        }
    }];
    return success;
}
@end
