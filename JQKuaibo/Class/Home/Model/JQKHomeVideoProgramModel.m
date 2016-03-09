//
//  JQKHomeVideoProgramModel.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKHomeVideoProgramModel.h"

@implementation JQKHomeProgramResponse

- (Class)columnListElementClass {
    return [JQKPrograms class];
}
@end

@implementation JQKHomeVideoProgramModel

+ (Class)responseClass {
    return [JQKHomeProgramResponse class];
}

+ (BOOL)shouldPersistURLResponse {
    return YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        JQKHomeProgramResponse *resp = (JQKHomeProgramResponse *)self.response;
        _fetchedPrograms = resp.columnList;
        
        [self filterProgramTypes];
    }
    return self;
}

- (void)filterProgramTypes {
    NSArray<JQKPrograms *> *videoProgramList = [self.fetchedPrograms bk_select:^BOOL(id obj)
                                     {
                                         JQKProgramType type = ((JQKPrograms *)obj).type.unsignedIntegerValue;
                                         return type == JQKProgramTypeVideo;
                                     }];
    
    NSMutableArray *videoPrograms = [NSMutableArray array];
    [videoProgramList enumerateObjectsUsingBlock:^(JQKPrograms * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.programList.count > 0) {
            [videoPrograms addObjectsFromArray:obj.programList];
        }
    }];
    _fetchedVideoPrograms = videoPrograms;
    
    NSArray<JQKPrograms *> *bannerProgramList = [self.fetchedPrograms bk_select:^BOOL(id obj)
                                                {
                                                    JQKProgramType type = ((JQKPrograms *)obj).type.unsignedIntegerValue;
                                                    return type == JQKProgramTypeBanner;
                                                }];
    
    NSMutableArray *bannerPrograms = [NSMutableArray array];
    [bannerProgramList enumerateObjectsUsingBlock:^(JQKPrograms * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.programList.count > 0) {
            [bannerPrograms addObjectsFromArray:obj.programList];
        }
    }];
    _fetchedBannerPrograms = bannerPrograms;
}

- (BOOL)fetchProgramsWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:JQK_HOME_VIDEO_URL
                             withParams:nil
                        responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        if (!self) {
                            return ;
                        }
                        
                        NSArray *programs;
                        if (respStatus == JQKURLResponseSuccess) {
                            JQKHomeProgramResponse *resp = (JQKHomeProgramResponse *)self.response;
                            programs = resp.columnList;
                            self->_fetchedPrograms = programs;
                            
                            [self filterProgramTypes];
                        }
                        
                        if (handler) {
                            handler(respStatus==JQKURLResponseSuccess, programs);
                        }
                    }];
    return success;
}
@end
