//
//  JQKChannel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JQKChannelType) {
    JQKChannelTypeNone = 0,
    JQKChannelTypeVideo = 1,
    JQKChannelTypePicture = 2,
    JQKChannelTypeSpread = 3
};

@protocol JQKChannel <NSObject>

@end

@interface JQKChannel : NSObject

//@property (nonatomic) NSNumber *columnId;
//@property (nonatomic) NSString *name;
//@property (nonatomic) NSString *columnImg;
//@property (nonatomic) NSString *columnDesc;
//@property (nonatomic) NSString *spreadUrl;
//@property (nonatomic) NSNumber *type;
//@property (nonatomic) NSNumber *showNumber;

@property (nonatomic) NSString *CoverURL;
@property (nonatomic) NSNumber *Id;
@property (nonatomic) NSString *Name;

@end
