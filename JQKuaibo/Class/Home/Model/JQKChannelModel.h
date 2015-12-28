//
//  JQKChannelModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKChannel.h"

@interface JQKChannelResponse : JQKURLResponse
@property (nonatomic,retain) NSMutableArray<JQKChannel> *columnList;

@end

typedef void (^JQKFetchChannelsCompletionHandler)(BOOL success, NSArray<JQKChannel *> *channels);

@interface JQKChannelModel : JQKEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray *fetchedChannels;

- (BOOL)fetchChannelsWithCompletionHandler:(JQKFetchChannelsCompletionHandler)handler;

@end
