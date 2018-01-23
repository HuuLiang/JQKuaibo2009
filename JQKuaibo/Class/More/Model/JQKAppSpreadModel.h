//
//  JQKAppSpreadModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"

@interface JQKAppSpread : JQKVideo
//@property (nonatomic) NSString *title;
//@property (nonatomic) NSString *specialDesc;
//@property (nonatomic) NSString *videoUrl;
//@property (nonatomic) NSString *coverImg;
@end

@interface JQKAppSpreadResponse : JQKVideos
@property (nonatomic,retain) NSArray<JQKAppSpread *> *programList;
@end

@interface JQKAppSpreadModel : QBEncryptedURLRequest
@property (nonatomic,retain,readonly)JQKVideos *fetchChannels;
@property (nonatomic,retain,readonly) NSArray<JQKAppSpread *> *fetchedSpreads;

- (BOOL)fetchAppSpreadWithCompletionHandler:(JQKCompletionHandler)handler;

@end
