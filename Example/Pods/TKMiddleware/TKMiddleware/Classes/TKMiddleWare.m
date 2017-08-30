//
//  TKMiddleWare.m
//  Pods
//
//  Created by 云峰李 on 2017/8/23.
//
//

#import "TKMiddleWare.h"
#import "TKClassMethodInfo.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define InvokeAction(__TYPE__,__MODEL__,__SEL__, __PARAMS__) ((__TYPE__(*)(id,SEL,id))(void *)objc_msgSend)(__MODEL__,__SEL__,__PARAMS__)

static NSString* const kTargetNamePrefix = @"TKTarget";
static NSString* const kActionNamePrefix = @"tkAction";

@interface TKMiddleWare ()

@property (nonatomic, strong) NSCache* cachedTarget;

@end

@implementation TKMiddleWare

#pragma mark - 共有方法

+ (instancetype)instance
{
    static TKMiddleWare* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TKMiddleWare alloc] init];
    });
    return instance;
}

/**
 URL : scheme://[target]/[action]?[params] 
 sample:
 health://targetA/actionB?id=test&base=aaaa
*/
- (id)performActionWithURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options completion:(void (^)(NSDictionary *))completion
{
    //做了很简单的调用规则判断
    NSString* actionName = [url.path stringByReplacingOccurrencesOfString:@"/"
                                                               withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    NSString* urlString = [url query];
    NSArray* tmpParams = [urlString componentsSeparatedByString:@"&"];
    for (NSString* param in tmpParams) {
        NSArray* elts = [param componentsSeparatedByString:@"="];
        if (elts.count < 2) continue;
        [params setObject:elts.lastObject forKey:elts.firstObject];
    }
    
    id result = [self performTarget:url.host
                             action:actionName
                             params:params];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params
{
    return [self performTarget:targetName action:actionName params:params shouldCacheTarget:NO];
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget
{
    NSParameterAssert(targetName);
    NSParameterAssert(actionName);
    
    NSString* targetClassString = fetchTargetClassString(targetName);
    id target = [self.cachedTarget objectForKey:targetClassString];
    if (!target) {
        target = [fetchTargetClass(targetName) new];
    }
    
    SEL action = fetchAction(actionName);
    if (target == nil) {
        //如果处理无响应，则应该做一个默认的响应.
        return nil;
    }
    
    if (shouldCacheTarget) {
        [self.cachedTarget setObject:target forKey:targetClassString];
    }
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    } else {
        //处理为Swift
        action = fetchAction([NSString stringWithFormat:@"%@WithParams:",actionName]);
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:params];
        } else {
            //处理无响应时的方法
            action = NSSelectorFromString(@"notFound:");
            if ([target respondsToSelector:action]) {
                return [self safePerformAction:action target:target params:params];
            } else {
                [self.cachedTarget removeObjectForKey:targetClassString];
                return nil;
            }
        }
    }
}

- (void)removeCachedTargetWithName:(NSString *)targetName
{
    NSString* targetClassString = fetchTargetClassString(targetName);
    [self.cachedTarget removeObjectForKey:targetClassString];
}

#pragma mark - 私有方法

static inline Class fetchTargetClass(NSString * targetName)
{
    NSString* targetClassString = [NSString stringWithFormat:@"%@%@",kTargetNamePrefix,targetName];
    return NSClassFromString(targetClassString);
}

static inline NSString* fetchTargetClassString(NSString * targetName)
{
    NSString* targetClassString = [NSString stringWithFormat:@"%@%@",kTargetNamePrefix,targetName];
    return targetClassString;
}

static inline SEL fetchAction(NSString * actionName)
{
    NSString* targetActionString = [NSString stringWithFormat:@"%@_%@:",kActionNamePrefix,actionName];
    return NSSelectorFromString(targetActionString);
}

- (id)safePerformAction:(SEL)action target:(id)target params:(NSDictionary *)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if (!methodSig) return nil;
    const char* retType = methodSig.methodReturnType;
    TK_ENCODING_TYPE returnType = GetEncodingType(retType);
    id ret = nil;
    switch (returnType) {
        case TK_ENCODING_TYPE_MASK:
        case TK_ENCODING_TYPE_UNKNOWN:
            ret = nil;
            break;
        case TK_ENCODING_TYPE_INT8:{
            int8_t value = InvokeAction(int8_t, target, action, params);
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_UINT8:{
            uint8_t value = InvokeAction(uint8_t, target, action, params);
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_INT16:{
            int16_t value = InvokeAction(int16_t, target, action, params);
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_UINT16:{
            uint16_t value = InvokeAction(uint16_t, target, action, params);
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_INT32:{
            int32_t value = InvokeAction(int32_t, target, action, params);
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_UINT32:{
            uint32_t value = InvokeAction(uint32_t, target, action, params);
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_INT64:{
            int64_t value = InvokeAction(int64_t, target, action, params);
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_UINT64:{
            uint64_t value = InvokeAction(uint64_t, target, action, params);
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_VOID:{
            ret = nil;
            InvokeAction(void, target, action, params);
        }
            break;
        case TK_ENCODING_TYPE_BOOL:{
            BOOL value = InvokeAction(BOOL, target, action, params);
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_FLOAT:{
            float value = InvokeAction(float, target, action, params);
            if (isnan(value) || isinf(value)) {
                value = 0;
            }
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_DOUBLE:{
            double value = InvokeAction(double, target, action, params);
            if (isnan(value) || isinf(value)) {
                value = 0;
            }
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_LONGDOUBLE:{
            long double value = InvokeAction(long double, target, action, params);
            if (isnan(value) || isinf(value)) {
                value = 0;
            }
            ret = [NSString stringWithFormat:@"%Lf",value];
        }
            break;
        case TK_ENCODING_TYPE_OBJECT:
        case TK_ENCODING_TYPE_CLASS:
        case TK_ENCODING_TYPE_BLOCK:{
            ret = InvokeAction(id, target, action, params);
        }
            break;
        case TK_ENCODING_TYPE_SEL:
        case TK_ENCODING_TYPE_POINTER:
        case TK_ENCODING_TYPE_CARRAY:
        case TK_ENCODING_TYPE_CSTRING:{
            size_t value = InvokeAction(size_t, target, action, params);
            ret = @(value);
        }
            break;
        case TK_ENCODING_TYPE_UNION:
        case TK_ENCODING_TYPE_STRUCT:{
            ret = nil;
            //TODO: 暂时不支持内联，数组，结构体
        }
        default:
            break;
    }
    return ret;
}



#pragma mark - getters

- (NSCache *)cachedTarget
{
    if (!_cachedTarget) {
        _cachedTarget = [[NSCache alloc] init];
        _cachedTarget.totalCostLimit = 5 * 1024;
    }
    
    return _cachedTarget;
}

@end
