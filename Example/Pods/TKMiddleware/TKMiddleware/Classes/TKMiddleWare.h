//
//  TKMiddleWare.h
//  Pods
//
//  Created by 云峰李 on 2017/8/23.
//
//

#import <Foundation/Foundation.h>

#define TKMiddleWareMgr [TKMiddleWare instance]

NS_ASSUME_NONNULL_BEGIN

/**
 组件开发的中间件，所有组件都必须依赖的一个组件，起到中转作用.
 */
@interface TKMiddleWare : NSObject

+ (instancetype)instance;


/**
 远程app调用入口，将本地调用和远程调用区分开来

 @param url 调用的url
 @param options 配置选项
 @param completion 完成回调
 @return 返回的结果,这里做通用的返回，方便以后扩展
 */
- (id)performActionWithURL:(NSURL *)url
                   options:(nullable NSDictionary<NSString*, id> *)options
                completion:(void(^)(NSDictionary *))completion;

/**
 本地组件调用入口

 @param targetName 目标组件名字
 @param actionName 目标action名字
 @param params 参数
 @param shouldCacheTarget 是否缓存当前target
 @return 返回调用结果
 */
- (id)performTarget:(NSString *)targetName
             action:(NSString *)actionName
             params:(nullable NSDictionary *)params
  shouldCacheTarget:(BOOL)shouldCacheTarget;

/**
 本地组件调用入口，默认为不缓存target

 @param targetName 目标组件名字
 @param actionName 目标action名字
 @param params 参数
 @return 返回调用结果
 */
- (id)performTarget:(NSString *)targetName
             action:(NSString *)actionName
             params:(nullable NSDictionary *)params;

/**
 根据目标名字删除缓存中的目标

 @param targetName 目标名字
 */
- (void)removeCachedTargetWithName:(NSString *)targetName;

@end

NS_ASSUME_NONNULL_END
