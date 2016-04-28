//
//  JQKPhoto.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQKPayable.h"

@interface JQKPhoto : NSObject <JQKPayable>

//@property (nonatomic) NSString *coverUrl;
//@property (nonatomic) NSString *Describe;
//@property (nonatomic) NSString *Id;
//@property (nonatomic) NSString *Name;
//@property (nonatomic) NSString *Time;
@property (nonatomic,retain) NSArray<NSString *> *Urls;

@property (nonnull) NSString *height;
@property (nonnull) NSString *title;

@property (nonnull) NSString *url;

@property (nonnull) NSString *width;


@end
