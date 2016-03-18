//
//  JQKChannelModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKChannel.h"

typedef NS_ENUM(NSUInteger, JQKChannelNamespace) {
    JQKChannelNamespaceHome,
    JQKChannelNamespaceList
};

@interface JQKChannelResponse : JQKURLResponse
@property (nonatomic,retain) NSMutableArray<JQKChannel> *columnList;

@end

typedef void (^JQKFetchChannelsCompletionHandler)(BOOL success, NSArray<JQKChannel *> *channels);

@interface JQKChannelModel : JQKEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray *fetchedChannels;

- (BOOL)fetchChannelsInNamespace:(JQKChannelNamespace)channelNS withCompletionHandler:(JQKFetchChannelsCompletionHandler)handler;

@end
