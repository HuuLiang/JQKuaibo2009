//
//  NSObject+Properties.m
//  kuaibov
//
//  Created by Sean Yue on 15/12/8.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "NSObject+Properties.h"
#import <objc/runtime.h>

@implementation NSObject (Properties)

+ (NSArray *)propertiesOfClass:(Class)cls {
    NSMutableArray *propertyArr = [[NSMutableArray alloc] init];
    while (cls != [NSObject class]) {
        uint propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
        for (uint i = 0; i < propertyCount; ++i) {
            objc_property_t property = properties[i];
            const char* propertyName = property_getName(property);
            if (propertyName) {
                NSString *propName = [NSString stringWithUTF8String:propertyName];
                [propertyArr addObject:propName];
            }
        }
        free(properties);
        cls = [cls superclass];
    }
    return propertyArr;
}

- (NSDictionary *)dictionaryRepresentation {
    return nil;
}

- (void)mappingWithDictionary:(NSDictionary *)dic {
    [[self class] mappingWithDictionary:dic inInstance:self];
}

+ (void)mappingWithDictionary:(NSDictionary *)dic inInstance:(id)instance {
    if (!dic || !instance) {
        return ;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSArray *properties = [self propertiesOfClass:[instance class]];
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
            
            [self mappingWithDictionary:(NSDictionary *)value inInstance:subinstance];
        } else if ([value isKindOfClass:[NSArray class]]) {
            Class subclass = [instance valueForKey:[propertyName stringByAppendingString:@"ElementClass"]];
            if (!subclass) {
                DLog(@"JSON Parsing Warning: cannot find element class of property: %@ in class: %@\n", propertyName, [[instance class] description])
                return;
            }
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [instance setValue:arr forKey:propertyName];
            
            for (NSDictionary *subDic in (NSArray *)value) {
                id subinstance = [[subclass alloc] init];
                [arr addObject:subinstance];
                [self mappingWithDictionary:subDic inInstance:subinstance];
            }
        }
    }];
#pragma clang diagnostic pop
}
@end
