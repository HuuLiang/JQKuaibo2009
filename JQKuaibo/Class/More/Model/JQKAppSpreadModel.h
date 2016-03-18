//
//  JQKAppSpreadModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKProgram.h"

@interface JQKAppSpreadResponse : JQKURLResponse
@property (nonatomic,retain) NSArray<JQKProgram *> *programList;
@end

@interface JQKAppSpreadModel : JQKEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray<JQKProgram *> *fetchedSpreads;

- (BOOL)fetchAppSpreadWithCompletionHandler:(JQKCompletionHandler)handler;

@end
