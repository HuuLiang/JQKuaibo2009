//
//  JQKPayable.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JQKContentType) {
    JQKContentTypeUnknown,
    JQKContentTypeVideo,
    JQKContentTypePhoto
};

@protocol JQKPayable <NSObject>

@required
- (NSNumber *)contentId;
- (NSNumber *)contentType;
- (NSNumber *)payPointType;

@end
