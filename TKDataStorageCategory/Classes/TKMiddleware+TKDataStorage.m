//
//  TKMiddleware+TKDataStorage.m
//  Pods
//
//  Created by 云峰李 on 2017/8/30.
//
//

#import "TKMiddleware+TKDataStorage.h"

static NSString* const kDataStorageTarget = @"DataStorage";

static NSString* const kDataStorageContent = @"storageContent";
static NSString* const kDataStorageFilePath = @"filePath";
static NSString* const kDataStorageAtomically = @"atomically";
static NSString* const kDataStorageError = @"error";
static NSString* const kDataStorageContentClass = @"contentClass";
static NSString* const kDataStorageKey = @"storageKey";
static NSString* const kDataStorageServiceName = @"serviceName";

static NSString* const kDataStorageFileName = @"fileName";
static NSString* const kDataStorageFolder = @"folder";
static NSString* const kDataStorageExt = @"extension";
static NSString* const kDataStorageBackup = @"backup";
static NSString* const kDataStorageDataProtection = @"protection";

static NSString* const kDataStorageHander = @"storageHander";

@implementation TKMiddleWare (TKDataStorage)

#pragma mark - 文件写入

- (BOOL) writeData:(NSData *) data
            toFile:(NSString *)file
        atomically:(BOOL) atomically
{
    return [[self performTarget:kDataStorageTarget
                        action:@"writeDataToFile"
                        params:@{kDataStorageContent:data ?: [NSData new],
                                 kDataStorageFilePath:file,
                                 kDataStorageAtomically:@(atomically)}] boolValue];
}

- (id) readContentsOfFile:(NSString *)filePath
                 useClass:(Class)contentClass
{
    return [self performTarget:kDataStorageTarget
                        action:@"readContentInFile"
                        params:@{kDataStorageFilePath:filePath,
                                 kDataStorageContentClass:contentClass}];
}

#pragma mark - NSUserDefaults 相关

- (void) saveData:(id)data forKey:(NSString *)key
{
    NSParameterAssert(data);
    NSParameterAssert(key);
    [self performTarget:kDataStorageTarget
                        action:@"saveData"
                        params:@{kDataStorageContent:data,
                                 kDataStorageKey:key}];
}

- (id) fetchData:(NSString *)key
{
    NSParameterAssert(key);
    return [self performTarget:kDataStorageTarget
                        action:@"fetchData"
                        params:@{kDataStorageKey : key}];
}

#pragma mark - Security

- (BOOL)saveContentWithSecurity:(NSString *)content service:(NSString *)serviceName key:(NSString *)key
{
    NSParameterAssert(content);
    NSParameterAssert(serviceName);
    NSParameterAssert(key);
    id ret = [self performTarget:kDataStorageTarget
                          action:@"saveContentWithSecurity"
                          params:@{kDataStorageContent : content,
                                   kDataStorageServiceName : serviceName,
                                   kDataStorageKey : key}];
    return [ret boolValue];
}

- (nonnull NSString *)fetchContentWithService:(NSString *)serviceName key:(NSString *)key
{
    NSParameterAssert(serviceName);
    NSParameterAssert(key);
    return [self performTarget:kDataStorageTarget
                        action:@"fetchContentWithSecurity"
                        params:@{kDataStorageServiceName : serviceName,
                                 kDataStorageKey : key}];
}

- (BOOL)removeContentWithService:(NSString *)serviceName key:(NSString *)key
{
    NSParameterAssert(serviceName);
    NSParameterAssert(key);
    id ret = [self performTarget:kDataStorageTarget
                          action:@"removeContentWithService"
                          params:@{kDataStorageServiceName : serviceName,
                                   kDataStorageKey : key}];
    return [ret boolValue];
}


#pragma mark - file

NSString *TKDocumentsFolder()
{
    return [TKMiddleWareMgr performTarget:kDataStorageTarget
                                   action:@"documentsFolder"
                                   params:nil];
}

NSString *TKLibraryFolder()
{
    return [TKMiddleWareMgr performTarget:kDataStorageTarget
                                   action:@"libraryFolder"
                                   params:nil];
}

NSString *TKTmpFolder()
{
    return [TKMiddleWareMgr performTarget:kDataStorageTarget
                                   action:@"tmpFolder"
                                   params:nil];
}

NSString *TKBundleFolder()
{
    return [TKMiddleWareMgr performTarget:kDataStorageTarget
                                   action:@"bundleFolder"
                                   params:nil];
}

NSString *TKDCIMFolder()
{
    return [TKMiddleWareMgr performTarget:kDataStorageTarget
                                   action:@"dcimFolder"
                                   params:nil];
}

- (NSString *) pathForFileName:(NSString *)fileName inFolder:(NSString *) path
{
    NSParameterAssert(fileName);
    NSParameterAssert(path);
    return [self performTarget:kDataStorageTarget
                        action:@"pathForFileNameInFolder"
                        params:@{kDataStorageFileName : fileName,
                                 kDataStorageFolder : path}];
}

- (NSString *) pathForDocumentFileNamed:(NSString *) fname
{
    NSParameterAssert(fname);
    return [self performTarget:kDataStorageTarget
                        action:@"pathForDocumentFileNamed"
                        params:@{kDataStorageFileName:fname}];
}

- (NSString *) pathForBoundleFileNamed:(NSString *) fname
{
    NSParameterAssert(fname);
    return [self performTarget:kDataStorageTarget
                        action:@"pathForBoundleFileNamed"
                        params:@{kDataStorageFileName:fname}];
}

- (NSString *) pathForItemNamed: (NSString *) fname inFolder: (NSString *) path
{
    NSParameterAssert(fname);
    NSParameterAssert(path);
    return [self performTarget:kDataStorageTarget
                        action:@"pathForItemNamedInFolder"
                        params:@{kDataStorageFileName:fname,
                                 kDataStorageFolder:path}];
}

- (NSString *) pathForDocumentNamed: (NSString *) fname
{
    NSParameterAssert(fname);
    return [self performTarget:kDataStorageTarget
                        action:@"pathForDocumentNamed"
                        params:@{kDataStorageFileName:fname}];
}

- (NSString *) pathForBundleDocumentNamed: (NSString *) fname
{
    NSParameterAssert(fname);
    return [self performTarget:kDataStorageTarget
                        action:@"pathForBundleDocumentNamed"
                        params:@{kDataStorageFileName:fname}];
}

- (NSArray *) pathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path
{
    NSParameterAssert(ext);
    NSParameterAssert(path);
    return [self performTarget:kDataStorageTarget
                        action:@"pathsForItemsMatchingExtensionInFolder"
                        params:@{kDataStorageFolder:path,kDataStorageExt : ext}];
}

- (NSArray *) pathsForDocumentsMatchingExtension: (NSString *) ext
{
    NSParameterAssert(ext);
    return [self performTarget:kDataStorageTarget
                        action:@"pathsForDocumentsMatchingExtension"
                        params:@{kDataStorageExt:ext}];
}

- (NSArray *) pathsForBundleDocumentsMatchingExtension: (NSString *) ext
{
    NSParameterAssert(ext);
    return [self performTarget:kDataStorageTarget
                        action:@"pathsForBundleMatchingExtension"
                        params:@{kDataStorageExt:ext}];
}

- (NSArray *) filesInFolder: (NSString *) path
{
    NSParameterAssert(path);
    return [self performTarget:kDataStorageTarget
                        action:@"filesInFolder"
                        params:@{kDataStorageFolder:path}];
}

- (BOOL) findOrCreateDirectoryPath:(NSString *)path
{
    NSParameterAssert(path);
    id ret = [self performTarget:kDataStorageTarget
                          action:@"findOrCreateDirectoryPath"
                          params:@{kDataStorageFolder:path}];
    return [ret boolValue];
}

- (BOOL) findOrCreateDirectoryPath:(NSString *)path backup:(BOOL)shouldBackup dataProtection:(NSString *)dataProtection
{
    NSParameterAssert(path);
    id ret = [self performTarget:kDataStorageTarget
                          action:@"findOrCreateDirectoryPathBackupProtection"
                          params:@{kDataStorageFolder:path,
                                   kDataStorageBackup:@(shouldBackup),
                                   kDataStorageDataProtection:dataProtection ?: @""}];
    return [ret boolValue];
}

#pragma mark - sqlite

- (void)openSqliteWithModelClass:(Class)modelClass
{
    NSParameterAssert(modelClass);
    [self performTarget:kDataStorageTarget
                 action:@"openSqlite"
                 params:@{kDataStorageContentClass:modelClass}];
}

- (void)addData:(id)model hander:(void (^)(BOOL status, NSError * error))hander
{
    NSParameterAssert(model);
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setValue:model forKey:kDataStorageContent];
    if (hander) {
        [params setValue:[hander copy] forKey:kDataStorageHander];
    }
    [self performTarget:kDataStorageTarget
                 action:@"addData"
                 params:[params copy]];
}

- (void)updateData:(id)model hander:(void (^)(BOOL status, NSError * error))hander
{
    NSParameterAssert(model);
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setValue:model forKey:kDataStorageContent];
    if (hander) {
        [params setValue:[hander copy] forKey:kDataStorageHander];
    }
    [self performTarget:kDataStorageTarget
                 action:@"updateData"
                 params:[params copy]];
}

- (void)deleteData:(id)model hander:(void (^)(BOOL status, NSError * error))hander
{
    NSParameterAssert(model);
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setValue:model forKey:kDataStorageContent];
    if (hander) {
        [params setValue:[hander copy] forKey:kDataStorageHander];
    }
    [self performTarget:kDataStorageTarget
                 action:@"deleteData"
                 params:[params copy]];
}

- (void)fetchDataWithParams:(NSDictionary *)params class:(Class)modelClass hander:(void (^)(id ret, NSError *error)) hander
{
    NSParameterAssert(modelClass);
    NSMutableDictionary* invokeParams = [NSMutableDictionary new];
    [params setValue:modelClass forKey:kDataStorageContentClass];
    if (hander) {
        [params setValue:[hander copy] forKey:kDataStorageHander];
    }
    
    if (params) {
        [invokeParams setValue:params forKey:kDataStorageContent];
    }
    
    [self performTarget:kDataStorageTarget
                 action:@"deleteData"
                 params:[invokeParams copy]];
}

@end
