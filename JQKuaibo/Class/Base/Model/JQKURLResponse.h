//
//  JQKURLResponse.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JQKURLResponsePageInfo : NSObject
@property (nonatomic) NSNumber *Page;
@property (nonatomic) NSNumber *PageCount;
@property (nonatomic) NSNumber *PageSize;
@end

@interface JQKURLResponse : NSObject

@property (nonatomic) NSNumber *Result;
@property (nonatomic) NSString *Msg;
@property (nonatomic,retain) JQKURLResponsePageInfo *Pinfo;

- (void)parseResponseWithDictionary:(NSDictionary *)dic;

@end
