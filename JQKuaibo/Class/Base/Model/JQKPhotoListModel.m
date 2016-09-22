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

- (BOOL)fetchPhotoDetailsPageWithColumnId:(NSString *)columnId
                                programId:(NSString *)programId
                        CompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"columnId":columnId,
                             @"programId":programId
                             };
    BOOL success = [self requestURLPath:JQK_PHOTO_LIST_URL
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        if (!self) {
                            return ;
                        }
                        
                        JQKPhotos *photos;
                        if (respStatus == QBURLResponseSuccess) {
                            photos = self.response;
                            self->_fetchedPhotos = photos;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess, photos);
                        }
                        
                    }];
    return success;
}

//- (BOOL)fetchPhotosWithPageNo:(NSInteger)pageNo
//                     columnId:(NSString *)columnId
//            completionHandler:(JQKCompletionHandler)handler {
//    @weakify(self);
//    NSDictionary *params = @{@"columnId":columnId};
//    BOOL success = [self requestURLPath:JQK_CHANNEL_PROGRAM_URL
//                             withParams:params
//                        responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
//                    {
//                        @strongify(self);
//                        if (!self) {
//                            return ;
//                        }
//                        
//                        JQKPhotos *photos;
//                        if (respStatus == JQKURLResponseSuccess) {
//                            photos = self.response;
//                            self->_fetchedPhotos = photos;
//                        }
//                        
//                        if (handler) {
//                            handler(respStatus == JQKURLResponseSuccess, photos);
//                        }
//                    }];
//    return success;
//}
//
//- (BOOL)fetchPhotosWithAlbumId:(NSString *)albumId CompletionHandler:(JQKCompletionHandler)handler {
//    if (albumId == nil) {
//        if (handler) {
//            handler(NO, nil);
//        }
//        return NO;
//    }
//    
//    @weakify(self);
//    NSDictionary *params = @{@"appId":JQK_REST_APP_ID,
//                             kEncryptionKeyName:@"f7@j3%#5aiG$4",
//                             @"imsi":@"999999999999999",
//                             @"channelNo":JQK_CHANNEL_NO,
//                             @"pV":JQK_REST_PV,
//                             @"programId":albumId
//                             };
//    BOOL success = [self requestURLPath:JQK_PHOTO_LIST_URL
//                             withParams:params
//                        responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
//    {
//        @strongify(self);
//        if (!self) {
//            return ;
//        }
//        
//        JQKPhotos *photos;
//        if (respStatus == JQKURLResponseSuccess) {
//            photos = self.response;
//            self->_fetchedPhotos = photos;
//        }
//        
//        if (handler) {
//            handler(respStatus == JQKURLResponseSuccess, photos);
//        }
//    }];
//    return success;
//}
@end
