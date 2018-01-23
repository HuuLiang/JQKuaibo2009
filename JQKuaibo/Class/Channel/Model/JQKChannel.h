//
//  JQKChannel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQKVideos.h"

@interface JQKChannel : NSObject

@property (nonatomic) NSString *columnDesc;
@property (nonatomic) NSString *columnId;
@property (nonatomic) NSString *columnImg;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString * showNumber;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSString *realColumnId;

//@property (nonatomic) JQKVideos *programList;
@property (nonatomic,retain) NSArray<JQKVideo *> *programList;

@end
