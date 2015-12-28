//
//  JQKURLRequest.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQKURLResponse.h"

typedef NS_ENUM(NSUInteger, JQKURLResponseStatus) {
    JQKURLResponseSuccess,
    JQKURLResponseFailedByInterface,
    JQKURLResponseFailedByNetwork,
    JQKURLResponseFailedByParsing,
    JQKURLResponseFailedByParameter,
    JQKURLResponseNone
};

typedef NS_ENUM(NSUInteger, JQKURLRequestMethod) {
    JQKURLGetRequest,
    JQKURLPostRequest
};
typedef void (^JQKURLResponseHandler)(JQKURLResponseStatus respStatus, NSString *errorMessage);

@interface JQKURLRequest : NSObject

@property (nonatomic,retain) id response;

+ (Class)responseClass;  // override this method to provide a custom class to be used when instantiating instances of JQKURLResponse
+ (BOOL)shouldPersistURLResponse;
- (NSURL *)baseURL; // override this method to provide a custom base URL to be used
- (NSURL *)standbyBaseURL; // override this method to provide a custom standby base URL to be used

- (BOOL)shouldPostErrorNotification;
- (JQKURLRequestMethod)requestMethod;

- (BOOL)requestURLPath:(NSString *)urlPath withParams:(NSDictionary *)params responseHandler:(JQKURLResponseHandler)responseHandler;

- (BOOL)requestURLPath:(NSString *)urlPath standbyURLPath:(NSString *)standbyUrlPath withParams:(NSDictionary *)params responseHandler:(JQKURLResponseHandler)responseHandler;

// For subclass pre/post processing response object
- (void)processResponseObject:(id)responseObject withResponseHandler:(JQKURLResponseHandler)responseHandler;

@end
