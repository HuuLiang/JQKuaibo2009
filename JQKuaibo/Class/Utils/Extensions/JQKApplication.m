//
//  JQKApplication.m
//  ShiWanSprite
//
//  Created by Sean Yue on 15/5/4.
//  Copyright (c) 2015年 Kuchuan. All rights reserved.
//

#import "JQKApplication.h"
#import "NSObject+PropertyAccessInspecting.h"

static NSString *const kRawClassName = @"LSApplicationProxy";

@interface JQKApplication ()
@property (nonatomic,retain,readonly) id applicationProxy;

@end

@implementation JQKApplication

+(instancetype)applicationFromApplicationProxy:(id)applicationProxy {
    if (![NSStringFromClass([applicationProxy class]) isEqualToString:@"LSApplicationProxy"]) {
        return nil;
    }
    
    JQKApplication *instance = [[JQKApplication alloc] initWithApplicationProxy:applicationProxy];
    return instance;
}

-(instancetype)initWithApplicationProxy:(id)applicationProxy {
    self = [super init];
    if (self) {
        _applicationProxy = applicationProxy;
        
        [self propAccessInspect_init];
    }
    return self;
}

-(BOOL)valid {
    return _applicationProxy != nil
    && [NSStringFromClass([_applicationProxy class]) isEqualToString:@"LSApplicationProxy"];
}

-(id)propAccessInspect_preAccessProperty:(NSString *)propertyName {
    NSArray *hookedProperties = @[@"applicationIdentifier", @"applicationDSID",
                                  @"applicationType", @"isPurchasedReDownload",
                                  @"isInstalled", @"itemID", @"itemName", @"shortVersionString",
                                  @"sourceAppIdentifier", @"teamID", @"vendorName"];
    if ([hookedProperties containsObject:propertyName]) {
        id value = [_applicationProxy valueForKey:propertyName];
        return value;
    }
    return nil;
}

@end
