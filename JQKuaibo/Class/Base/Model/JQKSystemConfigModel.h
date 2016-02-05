//
//  JQKSystemConfigModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"

@class JQKSystemConfigItem;

@interface JQKSystemConfigResponse : JQKURLResponse
@property (nonatomic,retain) NSArray<JQKSystemConfigItem *> *confis;
@end

@interface JQKSystemConfigModel : JQKEncryptedURLRequest

+ (instancetype)sharedModel;

//- (BOOL)fetchRemoteSystemConfigWithCompletionHandler:(JQKCompletionHandler)handler;
- (BOOL)fetchSystemConfigWithCompletionHandler:(JQKCompletionHandler)handler;

@end
