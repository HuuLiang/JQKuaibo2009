//
//  JQKVideos.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKURLResponse.h"
#import "JQKVideo.h"

@interface JQKVideos : JQKURLResponse

@property (nonatomic,retain) NSArray<JQKVideo *> *programList;

@property (nonatomic,retain) NSArray<JQKVideo *> *hotProgramList;

@end
