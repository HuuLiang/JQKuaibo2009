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
@property (nonatomic,retain) NSMutableArray<JQKChannel *> *AtlasInfo;
@end

@interface JQKChannelModel : JQKURLRequest

@property (nonatomic,retain,readonly) NSArray *fetchedChannels;

- (BOOL)fetchChannelsWithCompletionHandler:(JQKCompletionHandler)handler;

@end
