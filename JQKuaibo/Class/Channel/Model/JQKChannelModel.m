//
//  JQKChannelModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKChannelModel.h"

@implementation JQKChannelResponse

- (Class)AtlasInfoElementClass {
    return [JQKChannel class];
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
        _fetchedChannels = resp.AtlasInfo;
    }
    return self;
}

- (BOOL)fetchChannelsWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:JQK_CHANNEL_LIST_URL
                             withParams:nil
                        responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        if (respStatus == JQKURLResponseSuccess) {
            JQKChannelResponse *channelResp = (JQKChannelResponse *)self.response;
            self->_fetchedChannels = channelResp.AtlasInfo;
            
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

@end
