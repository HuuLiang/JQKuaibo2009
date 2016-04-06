//
//  JQKComment.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JQKComment : NSObject

@property (nonatomic) NSString *id;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *Icon;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *create_at;

@property (nonatomic) NSUInteger popularity;

@end
