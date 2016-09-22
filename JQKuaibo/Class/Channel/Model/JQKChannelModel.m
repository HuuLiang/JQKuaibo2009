//
//  JQKChannelModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKChannelModel.h"
#import "NSDictionary+QBSign.h"

@implementation JQKChannelResponse

- (Class)columnListElementClass {
    return [JQKVideos class];
}



@end

@implementation JQKChannelModel

+ (Class)responseClass {
    return [JQKChannelResponse class];
}

+ (BOOL)shouldPersistURLResponse {
    return YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        JQKChannelResponse *resp = self.response;
        _fetchedChannels = resp.columnList;
    }
    return self;
}

- (BOOL)fetchChannelsWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    NSDictionary *prarms = @{@"appId":JQK_REST_APP_ID,
                             kEncryptionKeyName:@"f7@j3%#5aiG$4",
                             @"imsi":@"999999999999999",
                             @"channelNo":JQK_CHANNEL_NO,
                             @"pV":JQK_REST_PV
                             };
    BOOL success = [self requestURLPath:JQK_CHANNEL_LIST_URL
                             withParams:prarms
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        if (respStatus == QBURLResponseSuccess) {
                            JQKChannelResponse *channelResp = (JQKChannelResponse *)self.response;
                            self->_fetchedChannels = channelResp.columnList;
                            
                            if (handler) {
                                handler(YES, self->_fetchedChannels);
                            }
                        } else {
                            if (handler) {
                                handler(NO, nil);
                            }
                        }
                    }];
    return success;
}


- (BOOL)fetchHomeChannelsWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"appId":JQK_REST_APP_ID,
                             kEncryptionKeyName:@"f7@j3%#5aiG$4",
                             @"imsi":@"999999999999999",
                             @"channelNo":JQK_CHANNEL_NO,
                             @"pV":JQK_REST_PV
                             };
    BOOL success = [self requestURLPath:JQK_HOME_URL
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        if (respStatus == QBURLResponseSuccess) {
                            JQKChannelResponse *channelResp = (JQKChannelResponse *)self.response;
                            self->_fetchedChannels = channelResp.columnList;
                            
                            if (handler) {
                                handler(YES, self->_fetchedChannels);
                            }
                        } else {
                            if (handler) {
                                handler(NO, nil);
                            }
                        }
                    }];
    return success;
}

- (BOOL)fetchPhotosWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:JQK_PHOTO_ALBUM_URL
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        if (respStatus == QBURLResponseSuccess) {
                            JQKChannelResponse *channelResp = (JQKChannelResponse *)self.response;
                            self->_fetchPhotos = channelResp.columnList;
                            
                            NSMutableArray *clumArr;
                            [channelResp.columnList enumerateObjectsUsingBlock:^(JQKVideos * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [clumArr addObject:obj.columnId];
                            } ];
                            _columIds = clumArr;
                            if (handler) {
                                handler(YES,self->_fetchPhotos);
                            }
                        } else {
                            if (handler) {
                                handler(NO,nil);
                            }
                        }
                    }];
    return success;
}


@end
