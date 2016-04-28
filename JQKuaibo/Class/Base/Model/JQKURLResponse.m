//
//  JQKURLResponse.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKURLResponse.h"
#import <objc/runtime.h>

@implementation JQKURLResponsePageInfo

@end

@interface JQKURLResponse ()
@property (nonatomic) NSNumber *success;
@property (nonatomic) NSString *resultCode;
@end

@implementation JQKURLResponse

- (void)setSuccess:(NSNumber *)success {
    _success = success;
    _Result = success;
}

- (void)setResultCode:(NSString *)resultCode {
    _resultCode = resultCode;
    _Msg = resultCode;
}

- (Class)PinfoClass {
    return [JQKURLResponsePageInfo class];
}

- (void)parseResponseWithDictionary:(NSDictionary *)dic {
    [self parseDataWithDictionary:dic inInstance:self];
}

- (void)parseDataWithDictionary:(NSDictionary *)dic inInstance:(id)instance {
    if (!dic || !instance) {
        return ;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSArray *properties = [NSObject propertiesOfClass:[instance class]];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *propertyName = (NSString *)obj;
        
        id value = [dic objectForKey:propertyName];
        if ([value isKindOfClass:[NSString class]]
            || [value isKindOfClass:[NSNumber class]]) {
            [instance setValue:value forKey:propertyName];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            id property = [instance valueForKey:propertyName];
            Class subclass = [property class];
            if (!subclass) {
                NSString *classPropertyName = [propertyName stringByAppendingString:@"Class"];
                subclass = [instance valueForKey:classPropertyName];
            }
            id subinstance = [[subclass alloc] init];
            [instance setValue:subinstance forKey:propertyName];
            
            [self parseDataWithDictionary:(NSDictionary *)value inInstance:subinstance];
        } else if ([value isKindOfClass:[NSArray class]]) {
            Class subclass = [instance valueForKey:[propertyName stringByAppendingString:@"ElementClass"]];

            if (!subclass) {
                DLog(@"JSON Parsing Warning: cannot find element class of property: %@ in class: %@\n", propertyName, [[instance class] description])
                return;
            }
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [instance setValue:arr forKey:propertyName];
            
            for (id obj in (NSArray *)value) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    id subinstance = [[subclass alloc] init];
                    [arr addObject:subinstance];
                    [self parseDataWithDictionary:obj inInstance:subinstance];
                } else if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
                    [arr addObject:obj];
                }
            }
            //            Class subclass;
            //
            //            NSString *methordString = [propertyName stringByAppendingString:@"ElementClass"];
            //            NSLog(@"%@",methordString);
            //            unsigned int count = 0;
            //            Method *memberFuncs = class_copyMethodList([instance class], &count);//所有在.m文件所有实现的方法都会被找到
            //            for (int i = 0; i < count; i++) {
            //                SEL selname = method_getName(memberFuncs[i]);
            //
            //                NSString *methodName = [NSString stringWithCString:sel_getName(selname) encoding:NSUTF8StringEncoding];
            //                NSLog(@"member method:%@", methodName);
            //                if ([methodName isEqualToString:methordString]) {
            //                    subclass = (Class)[instance performSelector:selname];
            //                    break;
            //                }
            

        }
    }];
#pragma clang diagnostic pop
}

@end
