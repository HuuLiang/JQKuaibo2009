//
//  JQKChannelProgramModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKChannelProgram.h"

@interface JQKChannelProgramResponse : JQKChannelPrograms

@end

typedef void (^JQKFetchChannelProgramCompletionHandler)(BOOL success, JQKChannelPrograms *programs);

@interface JQKChannelProgramModel : JQKEncryptedURLRequest

@property (nonatomic,retain) JQKChannelPrograms *fetchedPrograms;

- (BOOL)fetchProgramsWithColumnId:(NSNumber *)columnId
                           pageNo:(NSUInteger)pageNo
                         pageSize:(NSUInteger)pageSize
                completionHandler:(JQKFetchChannelProgramCompletionHandler)handler;

@end
