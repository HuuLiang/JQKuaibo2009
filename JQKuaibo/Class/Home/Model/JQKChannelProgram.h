//
//  JQKChannelProgram.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQKProgram.h"

@protocol JQKChannelProgram <NSObject>

@end

@interface JQKChannelProgram : JQKProgram
@property (nonatomic) NSNumber *items;
@property (nonatomic) NSNumber *page;
@property (nonatomic) NSNumber *pageSize;
@end

@protocol JQKChannelPrograms <NSObject>

@end

@interface JQKChannelPrograms : JQKPrograms
@property (nonatomic) NSNumber *items;
@property (nonatomic) NSNumber *page;
@property (nonatomic) NSNumber *pageSize;
@end