//
//  JQKVideo.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQKPayable.h"



@interface JQKVideo : NSObject <JQKPayable>

@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSString *programId;
@property (nonatomic) NSString *specialDesc;
@property (nonatomic) NSInteger spec;
@property (nonatomic) NSString *title;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSString *videoUrl;
@property (nonatomic) NSString *columnImg;

@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *realColumnId;
@property (nonatomic) NSString *name;
//@property (nonatomic) NSString *VIP;

@end

