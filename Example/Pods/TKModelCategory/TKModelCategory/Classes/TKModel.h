//
//  TKModel.h
//  Pods
//
//  Created by 云峰李 on 2017/8/25.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (TKModel)

/**
 将json格式数据 转化成对象，

 @param json json数据格式，其为基本的Foundation类型，包括了NSString，NSArray，NSDictionary
 @return 对象
 */
+ (instancetype)tkModelWithJson:(id)json;

/**
 将json格式数据，转换成包含对应类型的数组

 @param json json数据
 @return 数组
 */
+ (NSArray *)tkModelListWithJson:(id)json;

+ (NSDictionary *)tkModelDictionaryWithJson:(id)json;

- (BOOL)tkModelSetWithJson:(id)json;

- (id)tkModelToJson;
- (NSData *)tkModelToJsonData;
- (NSString *)tkModelToJsonString;

- (id)tkModelCopy;

- (void)tkModelEncodeWithCoder:(NSCoder *)coder;
- (id)tkModelDeCodeWithCoder:(NSCoder *)coder;

- (BOOL)tkModelIsEqual:(id)model;

+ (NSDictionary *)tkClassInfo;

@end
