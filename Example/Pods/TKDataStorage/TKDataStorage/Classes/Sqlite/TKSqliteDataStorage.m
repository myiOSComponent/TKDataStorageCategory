//
//  TKSqliteDataStorage.m
//  Pods
//
//  Created by 云峰李 on 2017/8/24.
//
//

#import "TKSqliteDataStorage.h"
#import "NSFileManager+TKUtilities.h"
#import "FMDB.h"

#import <TKModelCategory/TKModel.h>

static NSString* const kSqliteErrorDomain = @"com.thinkWindDomain.error";
static NSString* const kPropertyInfo = @"propertyInfo";
/**
 数据操作会用到的协议，所有需要存储的对象不必须遵循此协议，只需要在实现需要的方法即可.
 */
@protocol TKSqlite <NSObject>

@optional

+ (NSString *)databasePath;
+ (NSString *)tableName;
+ (NSString *)primaryKey;

@end

@interface TKSqliteDataStorage()

@property (nonatomic, strong) FMDatabaseQueue* executeQueue;

@end

@implementation TKSqliteDataStorage

static NSMutableDictionary* g_sqliteQueueDic = nil;

+ (void)load
{
    g_sqliteQueueDic = [NSMutableDictionary new];
}

+ (instancetype)sqliteDataStorage:(Class)modelClass
{
    NSString* className = NSStringFromClass(modelClass);
    TKSqliteDataStorage* instance = g_sqliteQueueDic[className];
    if (!instance) {
        instance = [[TKSqliteDataStorage alloc] initWithClass:modelClass];
        if (instance) {
            g_sqliteQueueDic[NSStringFromClass(modelClass)] = instance;
        }
    }
    return instance;
}

- (instancetype)initWithClass:(Class)modelClass
{
    if (!modelClass) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        NSString* dataBasePath = nil;
        if ([modelClass resolveClassMethod:@selector(databasePath)]) {
            dataBasePath = [modelClass databasePath];
        } else {
            NSString* dataPath = [NSFileManager pathForDocumentFileNamed:@"data"];
            if (![NSFileManager findOrCreateDirectoryPath:dataPath]) {
                return nil;
            }
            
            dataBasePath = [NSFileManager pathForDocumentFileNamed:[NSString stringWithFormat:@"data/%@",
                                                                NSStringFromClass(modelClass)]];
        }
        
        _executeQueue = [FMDatabaseQueue databaseQueueWithPath:dataBasePath];
        [self createTableIFNotExits:modelClass hander:nil];
    }
    return self;
}

- (void)createTableIFNotExits:(Class)modelClass hander:(void (^)(BOOL, NSError *))hander
{
    [self.executeQueue inDatabase:^(FMDatabase *db) {
        NSDictionary* classInfo = [modelClass tkClassInfo];
        NSString* keyProperty = [self primaryKey:modelClass];
        NSMutableString* sqlString = [NSMutableString new];
        NSString* dataBaseName = [self tableName:modelClass];
        [sqlString appendString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",dataBaseName]];
        NSArray* propertys = classInfo[kPropertyInfo];
        for (int idx = 0 ; idx < propertys.count; ++idx) {
            NSString* propertyName = propertys[idx];
            if ([propertyName isEqualToString:keyProperty]) {
                [sqlString appendFormat:@"'%@' INTEGER ", propertyName];
                [sqlString appendFormat:@"PRIMARY KEY autoincrement"];
            } else {
                [sqlString appendFormat:@"'%@' text not null ", propertyName];
            }
            if (idx == propertys.count - 1) {
                [sqlString appendString:@" )"];
            } else {
                [sqlString appendString:@" ,"];
            }
        }
        
        BOOL ret = [db executeUpdate:sqlString];
        if (hander) {
            NSError* error = nil;
            if (!ret) {
                error = db.lastError;
            }
            hander(ret,error);
        }
    }];
}

- (void)addData:(id)model hander:(void (^)(BOOL, NSError *))hander
{
    NSParameterAssert(model);
    [self.executeQueue inDatabase:^(FMDatabase *db) {
        NSDictionary* modelInfo = [model tkModelToJson];
        if (!modelInfo && ![modelInfo isKindOfClass:[NSDictionary class]]) {
            NSError* error = [NSError errorWithDomain:kSqliteErrorDomain
                                                 code:500
                                             userInfo:@{@"msg":@"模型转化后的类型不对，请检查添加的数据类型"}];
            if (hander) {
                hander(NO,error);
            }
            return ;
        }
        NSString* keyProperty = [self primaryKey:[model class]];
        NSString* dataBaseName = [self tableName: [model class]];
        NSString* method = @"INSERT INTO ";
        NSString* sqlString = [self generateSqlString:modelInfo
                                            tableName:dataBaseName
                                               mathod:method
                                              keyName:keyProperty];
        
        BOOL ret = [db executeUpdate:sqlString];
        if (hander) {
            NSError* error = nil;
            if (!ret) {
                error = db.lastError;
            }
            hander(ret,error);
        }
    }];
}

- (void)updateData:(id)model hander:(void (^)(BOOL, NSError *))hander
{
    NSParameterAssert(model);
    [self.executeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSDictionary* modelInfo = [model tkModelToJson];
        if (![self verifyModelInfo:model handler:hander]) {
            *rollback = YES;
            return;
        }
        NSString* dataBaseName = [self tableName: [model class]];
        NSString* keyProperty = [self primaryKey:[model class]];
        NSString* method = @"Replace into ";
        NSString* sqlString = [self generateSqlString:modelInfo
                                            tableName:dataBaseName
                                               mathod:method
                                              keyName:keyProperty];
        BOOL ret = [db executeUpdate:sqlString];
        if (hander) {
            NSError* error = nil;
            if (!ret) {
                error = db.lastError;
                *rollback = YES;
            }
            hander(ret,error);
        }
    }];
}

- (void)deleteData:(id)model hander:(void (^)(BOOL, NSError *))hander
{
    NSParameterAssert(model);
    [self.executeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSDictionary* classInfo = [[model class] tkClassInfo];
        NSArray* propertys = classInfo[kPropertyInfo];
        NSString* keyProperty = [self primaryKey:[model class]];
        BOOL hasKeyProperty = NO;
        for (NSString* propertyName in propertys) {
            if ([propertyName isEqualToString:keyProperty]) {
                hasKeyProperty = YES;
                break;
            }
        }
    
        NSDictionary* modelInfo = [model tkModelToJson];
        if (![self verifyModelInfo:model handler:hander]) {
            *rollback = YES;
            return;
        }
        
        NSString* deleteSql = nil;
        NSString* tableName = [self tableName:[model class]];
        if (hasKeyProperty) {
            deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = %@", tableName, keyProperty, modelInfo[keyProperty]];
        } else {
            NSMutableString* sqlString = [NSMutableString new];
            [sqlString appendFormat:@"delete from %@ where ", tableName];
            for (NSInteger idx = 0; idx < modelInfo.allKeys.count; ++idx) {
                NSString* propertyName = modelInfo.allKeys[idx];
                [sqlString appendFormat:@"%@ = %@", propertyName, modelInfo[propertyName]];
                if (idx < modelInfo.allKeys.count - 1) {
                    [sqlString appendString:@" and "];
                }
            }
            deleteSql = [sqlString copy];
        }
        
        BOOL ret = [db executeUpdate:deleteSql];
        if (hander) {
            NSError* error = nil;
            if (!ret) {
                error = db.lastError;
                *rollback = YES;
            }
            hander(ret,error);
        }
    }];
}

- (void)fetchDataWithParams:(NSDictionary *)params
                      class:(Class)modelClass
                     hander:(void (^)(id ret, NSError *)) hander
{
    NSParameterAssert(modelClass);
    [self.executeQueue inDatabase:^(FMDatabase *db) {
        NSString* tableName = [self tableName:modelClass];
        NSString* sqlString = nil;
        if (!params) {
            sqlString = [NSString stringWithFormat:@"select * from %@",tableName];
        } else {
            NSMutableString* muSql = [NSMutableString new];
            [muSql appendFormat:@"select * from %@ where ", tableName];
            for (NSInteger idx = 0; idx < params.allKeys.count; ++idx) {
                NSString* propertyName = params.allKeys[idx];
                NSString* value = params[value];
                [muSql appendFormat:@"%@ = %@", propertyName, value];
                if (idx < params.allKeys.count - 1) {
                    [muSql appendFormat:@" and "];
                }
            }
            sqlString = [muSql copy];
        }
        
        FMResultSet* resultSet = [db executeQuery:sqlString];
        NSDictionary* classInfo = [modelClass tkClassInfo];
        NSArray* propertys = classInfo[kPropertyInfo];
        NSMutableArray* retArray = [NSMutableArray new];
        while ([resultSet next]) {
            NSMutableDictionary* retItem = [NSMutableDictionary new];
            for (int idx = 0; idx < propertys.count; ++idx) {
                NSString* propertyName = propertys[idx];
                retItem[propertyName] = [resultSet stringForColumn:propertyName];
            }
            id obj = [modelClass tkModelWithJson:retItem];
            if (obj != nil) {
                [retArray addObject:obj];
            }
        }
        
        if (hander) {
            if (params == nil) {
                hander(retArray.firstObject, db.lastError);
            } else {
                hander(retArray, db.lastError);
            }
        }
    }];
}

#pragma mark - 私有方法

- (NSString *)generateSqlString:(NSDictionary *)historyItem
                      tableName:(NSString *)tableName
                         mathod:(NSString *)method
                        keyName:(NSString *)keyName
{
    NSMutableString* sqlString = [[NSMutableString alloc] init];
    NSMutableString* params = [[NSMutableString alloc] init];
    NSMutableDictionary* modelInfo = [historyItem mutableCopy];
    [modelInfo removeObjectForKey:keyName];
    for (NSInteger idx = 0; idx < modelInfo.allKeys.count; ++idx) {
        NSString* key = modelInfo.allKeys[idx];
        if (idx == 0) {
            [sqlString appendString:[NSString stringWithFormat:@"%@ %@ (",method, tableName]];
        }

        [sqlString appendFormat:@"'%@'",key];
        id values = modelInfo[key];
        [params appendFormat:@"'%@'", values];
        if (idx == modelInfo.allKeys.count - 1) {
            [sqlString appendFormat:@") values(%@)", params];
        } else {
            [sqlString appendString:@","];
            [params appendString:@","];
        }
    }
    return [sqlString copy];
}

- (NSString *)tableName:(Class)modelClass
{
    NSString* dataBaseName = nil;
    if ([modelClass resolveClassMethod:@selector(tableName)]) {
        dataBaseName = [modelClass tableName];
    } else {
        dataBaseName = NSStringFromClass(modelClass);
    }
    return dataBaseName;
}

- (NSString *)primaryKey:(Class) modelClass
{
    NSString* keyProperty = nil;
    if ([modelClass resolveClassMethod:@selector(primaryKey)]) {
        keyProperty = [modelClass primaryKey];
    } else {
        keyProperty = @"kId";
    }
    return keyProperty;
}

- (BOOL)verifyModelInfo:(NSDictionary *)modelInfo handler:(void (^)(BOOL, NSError *))hander
{
    if (!modelInfo && ![modelInfo isKindOfClass:[NSDictionary class]]) {
        NSError* error = [NSError errorWithDomain:kSqliteErrorDomain
                                             code:500
                                         userInfo:@{@"msg":@"模型转化后的类型不对，请检查添加的数据类型"}];
        if (hander) {
            hander(NO,error);
        }
        return NO;
    }
    return YES;
}
@end
