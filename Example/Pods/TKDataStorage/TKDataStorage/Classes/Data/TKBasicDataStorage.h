//
//  TKBasicDataStorage.h
//  Pods
//
//  Created by 云峰李 on 2017/8/24.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKBasicDataStorage : NSObject

#pragma mark - 文件写入
/**
 写入数据，支持基本的Foundation 对象，自定义对象需要转化成NSData.

 @param data 数据
 @param file 文件路径，绝对路径
 @param atomically 是否先写零时文件
 @param error 错误信息
 @return 写入是否成功
 */
- (BOOL) writeData:(NSData *) data toFile:(NSString *)file atomically:(BOOL) atomically error:(NSError * _Nullable __autoreleasing *)error;

/**
 读取数据

 @param filePath 文件路径
 @param contentClass 读取出来的数据类型，仅支持Foundation对象
 @param error 如果发生错误，则错误信息会包含再次
 @return 返回结果.
 */
- (id) readContentsOfFile:(NSString *)filePath useClass:(Class)contentClass error:(NSError **)error;

#pragma mark - NSUserDefaults 相关

- (void) saveData:(id)data forKey:(NSString *)key;
- (id) fetchData:(NSString *)key;

#pragma mark - Security

/**
 将数据保存到Security中，有相对来说的安全性，此方法会对数据进行des加密

 @param content 需要保存的内容
 @param serviceName 服务名字
 @param key 键
 @param error 错误信息
 @return 保存是否成功
 */
- (BOOL)saveContentWithSecurity:(NSString *)content service:(NSString *)serviceName key:(NSString *)key error:(NSError * __autoreleasing*)error;

/**
 根据服务名字，键值获取保存的内容，如果没有查到则返回nil

 @param serviceName 服务名字
 @param key 键
 @param error 错误信息
 @return 返回获取结果
 */
- (nonnull NSString *)fetchContentWithService:(NSString *)serviceName key:(NSString *)key error:(NSError * __autoreleasing*) error;

/**
 根据服务名字，键值删除保存的内容.

 @param serviceName 服务名字
 @param key 键
 @param error 错误信息
 @return 返回结果.
 */
- (BOOL)removeContentWithService:(NSString *)serviceName key:(NSString *)key error:(NSError * __autoreleasing*)error;

@end

NS_ASSUME_NONNULL_END
