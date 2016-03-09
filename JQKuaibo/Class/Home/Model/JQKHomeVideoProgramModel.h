//
//  JQKHomeVideoProgramModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKProgram.h"

@interface JQKHomeProgramResponse : JQKURLResponse
@property (nonatomic,retain) NSArray<JQKPrograms> *columnList;
@end

@interface JQKHomeVideoProgramModel : JQKEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray<JQKPrograms *> *fetchedPrograms;
@property (nonatomic,retain,readonly) NSArray<JQKProgram *> *fetchedBannerPrograms;
@property (nonatomic,retain,readonly) NSArray<JQKProgram *> *fetchedVideoPrograms;

- (BOOL)fetchProgramsWithCompletionHandler:(JQKCompletionHandler)handler;

@end
