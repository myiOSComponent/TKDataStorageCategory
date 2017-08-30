//
//  TKBasicDataStorage.m
//  Pods
//
//  Created by 云峰李 on 2017/8/24.
//
//

#import "TKBasicDataStorage.h"
#import "SSKeychain.h"

static NSString* const kErrorDomain = @"com.thinkWind.error";

@implementation TKBasicDataStorage

#pragma mark - 文件写入

- (BOOL) writeData:(NSData *) data toFile:(NSString *)file atomically:(BOOL) atomically error:(NSError * _Nullable __autoreleasing *)error
{
    NSParameterAssert(data);
    NSParameterAssert(file);
    NSURL* fileURL = [self urlWithFilePath:file error:error];
    if (!fileURL) {
        return NO;
    }
    
    return [data writeToURL:fileURL atomically:atomically];
}

- (id) readContentsOfFile:(NSString *)filePath useClass:(Class)contentClass error:(NSError **)error
{
    NSParameterAssert(filePath);
    NSURL* fileURL = [self urlWithFilePath:filePath error:error];
    if (!fileURL) {
        return nil;
    }
    
    Class retClass = contentClass;
    if (!contentClass) {
        retClass = [NSData class];
    }

    return [[retClass alloc] initWithContentsOfURL:fileURL];
}

#pragma mark - NSUserDefaults 相关

- (void)saveData:(id)data forKey:(NSString *)key
{
    NSParameterAssert(data);
    NSParameterAssert(key);
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}

- (id)fetchData:(NSString *)key
{
    NSParameterAssert(key);
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - Security

- (BOOL)saveContentWithSecurity:(NSString *)content service:(NSString *)serviceName key:(NSString *)key error:(NSError * __autoreleasing*)error
{
    NSParameterAssert(content);
    NSParameterAssert(serviceName);
    NSParameterAssert(key);
    
    return [SSKeychain setPassword:content
                        forService:serviceName
                           account:key
                             error:error];
}

- (nonnull NSString *)fetchContentWithService:(NSString *)serviceName key:(NSString *)key error:(NSError * __autoreleasing*) error
{
    NSParameterAssert(serviceName);
    NSParameterAssert(key);
    
    return [SSKeychain passwordForService:serviceName account:key error:error];
}

- (BOOL)removeContentWithService:(NSString *)serviceName key:(NSString *)key error:(NSError * __autoreleasing*)error
{
    NSParameterAssert(serviceName);
    NSParameterAssert(key);
    return [SSKeychain deletePasswordForService:serviceName account:key error:error];
}

#pragma mark - 私有方法

- (NSURL *)urlWithFilePath:(NSString *)filePath error:(NSError **)error
{
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    if (!fileURL) {
        if (error != nil) {
            *error = [NSError errorWithDomain:kErrorDomain code:500 userInfo:@{@"msg":@"文件路径不错误!"}];
        }
    }
    return fileURL;
}

@end
