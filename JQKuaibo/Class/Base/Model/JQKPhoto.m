//
//  JQKPhoto.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPhoto.h"

@implementation JQKPhoto

- (Class)UrlsElementClass {
    return [NSString class];
}

//- (NSNumber *)contentId {
//    return @(self.Id.integerValue);
//}

- (NSNumber *)contentId {
    return @0;
}

- (NSNumber *)contentType {
    return @(JQKContentTypePhoto);
}

- (NSNumber *)payPointType {
    return @1;
}
@end
