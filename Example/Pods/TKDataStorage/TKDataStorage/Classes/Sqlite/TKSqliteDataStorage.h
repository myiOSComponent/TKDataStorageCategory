//
//  TKSqliteDataStorage.h
//  Pods
//
//  Created by 云峰李 on 2017/8/24.
//
//

#import <Foundation/Foundation.h>


/**
 sqlite 数据库操作
 */
@interface TKSqliteDataStorage : NSObject

+ (instancetype)sqliteDataStorage:(Class)modelClass;

/**
 只能是自定义类型，且你需要存储的数据为 readwrite 属性。
 不必要都有值，底层会进行处理

 @param modelClass 目标class
 */
- (void)createTableIFNotExits:(Class)modelClass hander:(void (^)(BOOL status, NSError * error))hander;

/**
 添加数据

 @param model 需要添加的数据
 */
- (void)addData:(id)model hander:(void (^)(BOOL status, NSError * error))hander;

/**
 更新数据，如果当前数据项不存在，则会自动添加数据，数据更新为全覆盖

 @param model 需要更新的数据
 */
- (void)updateData:(id)model hander:(void (^)(BOOL status, NSError * error))hander;

- (void)deleteData:(id)model hander:(void (^)(BOOL status, NSError * error))hander;

/**
 根据指定查询参数获取数据

 @param params 查询参数 如果为空，则获取所有数据
 @param modelClass 返回的类型
 @param hander 查询后的会调
 */
- (void)fetchDataWithParams:(NSDictionary *)params class:(Class)modelClass hander:(void (^)(id ret, NSError *error)) hander;

@end
