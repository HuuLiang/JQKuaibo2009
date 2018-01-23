//
//  JQKComment.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKComment.h"

@implementation JQKComment

- (Class)commentListElementClass {
    return [JQKComment class];
}

- (NSUInteger)popularity {
    if (_popularity > 0) {
        return _popularity;
    }
    _popularity = arc4random_uniform(1000);
    return _popularity;
}
@end
