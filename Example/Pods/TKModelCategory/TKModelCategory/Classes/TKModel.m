//
//  TKModel.m
//  Pods
//
//  Created by 云峰李 on 2017/8/25.
//
//

#import "TKModel.h"
#import <TKMiddleWare/TKMiddleWare.h>

static NSString* const kModelObjTarget = @"ORM";

static NSString* const kModelORMClass = @"ORMClass";
static NSString* const kModelJsonContent = @"ORMContent";
static NSString* const kModelORMObject = @"ORMObject";
static NSString* const kModelORMObject1 = @"ORMObject1";
static NSString* const kModelORMCoder = @"ORMCoder";

static NSString* const kClassMethodInfo = @"methodInfo";
static NSString* const kClassPropertyInfo = @"propertyInfo";

@implementation NSObject (TKModel)

+ (instancetype)tkModelWithJson:(id)json
{
    NSParameterAssert(json);
    return [TKMiddleWareMgr performTarget:kModelObjTarget
                            action:@"modelWithJSON"
                            params:@{kModelORMClass : [self class],
                                     kModelJsonContent : json}
                 shouldCacheTarget:YES];
}

+ (NSArray *)tkModelListWithJson:(id)json
{
    NSParameterAssert(json);
    return [TKMiddleWareMgr performTarget:kModelObjTarget
                                   action:@"modelListWithJSON"
                                   params:@{kModelORMClass : [self class],
                                            kModelJsonContent : json}
                        shouldCacheTarget:YES];
}

+ (NSDictionary *)tkModelDictionaryWithJson:(id)json
{
    NSParameterAssert(json);
    return [TKMiddleWareMgr performTarget:kModelObjTarget
                                   action:@"modelDictionaryWithJson"
                                   params:@{kModelORMClass : [self class],
                                            kModelJsonContent : json}
                        shouldCacheTarget:YES];
}

- (BOOL)tkModelSetWithJson:(id)json
{
    NSParameterAssert(json);
    return [[TKMiddleWareMgr performTarget:kModelObjTarget
                                   action:@"modelSetWithJSON"
                                   params:@{kModelORMObject : self,
                                            kModelJsonContent : json}
                        shouldCacheTarget:YES] boolValue];
}

- (id)tkModelToJson
{
    return [TKMiddleWareMgr performTarget:kModelObjTarget
                                   action:@"modelToJSONObject"
                                   params:@{kModelORMObject : self}
                        shouldCacheTarget:YES];
}

- (NSData *)tkModelToJsonData
{
    return [TKMiddleWareMgr performTarget:kModelObjTarget
                                   action:@"modelToJSONData"
                                   params:@{kModelORMObject : self}
                        shouldCacheTarget:YES];
}

- (NSString *)tkModelToJsonString
{
    return [TKMiddleWareMgr performTarget:kModelObjTarget
                                   action:@"modelToJSONString"
                                   params:@{kModelORMObject : self}
                        shouldCacheTarget:YES];
}

- (id)tkModelCopy
{
    return [TKMiddleWareMgr performTarget:kModelObjTarget
                                   action:@"modelCopy"
                                   params:@{kModelORMObject : self}
                        shouldCacheTarget:YES];
}

- (void)tkModelEncodeWithCoder:(NSCoder *)coder
{
    NSParameterAssert(coder);
    [TKMiddleWareMgr performTarget:kModelObjTarget
                                   action:@"modelEncodeWithCoder"
                                   params:@{kModelORMCoder : coder}
                        shouldCacheTarget:YES];
}

- (id)tkModelDeCodeWithCoder:(NSCoder *)coder
{
    NSParameterAssert(coder);
    return [TKMiddleWareMgr performTarget:kModelObjTarget
                            action:@"modelInitWithCoder"
                            params:@{kModelORMCoder : coder}
                 shouldCacheTarget:YES];
}

- (BOOL)tkModelIsEqual:(id)model
{
    if (!model) {
        return NO;
    }
    
    id ret =  [TKMiddleWareMgr performTarget:kModelObjTarget
                                      action:@"modelIsEqual"
                                      params:@{kModelORMObject : self,
                                              kModelORMObject1 : model}
                           shouldCacheTarget:YES];
    return [ret boolValue];
}

+ (NSDictionary *)tkClassInfo
{
    return [TKMiddleWareMgr performTarget:kModelObjTarget
                                   action:@"classInfo"
                                   params:@{kModelORMClass : self}
                        shouldCacheTarget:YES];
}

@end
