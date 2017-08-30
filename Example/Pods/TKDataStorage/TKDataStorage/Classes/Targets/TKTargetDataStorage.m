//
//  TKTargetDataStorage.m
//  Pods
//
//  Created by 云峰李 on 2017/8/29.
//
//

#import "TKTargetDataStorage.h"
#import "NSFileManager+TKUtilities.h"
#import "TKBasicDataStorage.h"
#import "TKSqliteDataStorage.h"

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

@interface TKTargetDataStorage ()

@property (nonatomic, strong) TKBasicDataStorage* basicData;

@end

@implementation TKTargetDataStorage

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.basicData = [TKBasicDataStorage new];
    }
    return self;
}

#pragma mark - 文件写入

- (BOOL)tkAction_writeDataToFile:(NSDictionary *)fileInfo
{
    NSData* data = fileInfo[kDataStorageContent];
    NSString* filePath = fileInfo[kDataStorageFilePath];
    BOOL atomically = [fileInfo[kDataStorageAtomically] boolValue];
    id error = fileInfo[kDataStorageError];
    
    return [self.basicData writeData:data
                              toFile:filePath
                          atomically:atomically
                               error:&error];
}

- (id) tkAction_readContentInFile:(NSDictionary *)fileInfo
{
    NSString* filePath = fileInfo[kDataStorageFilePath];
    Class contentClass = fileInfo[kDataStorageContentClass];
    id error = fileInfo[kDataStorageError];
    return [self.basicData readContentsOfFile:filePath
                                     useClass:contentClass
                                        error:&error];
}

#pragma mark - 数据存储
- (void)tkAction_saveData:(NSDictionary *)valueInfo
{
    id data = valueInfo[kDataStorageContent];
    NSString* key = valueInfo[kDataStorageKey];
    [self.basicData saveData:data forKey:key];
}

- (id)tkAction_fetchData:(NSDictionary *)keyInfo
{
    NSString* key = keyInfo[kDataStorageKey];
    return [self.basicData fetchData:key];
}

#pragma mark - Security

- (BOOL)tkAction_saveContentWithSecurity:(NSDictionary *)ssInfo
{
    NSString* serviceName = ssInfo[kDataStorageServiceName];
    NSString* key = ssInfo[kDataStorageKey];
    id error = ssInfo[kDataStorageError];
    NSString* content = ssInfo[kDataStorageContent];
    
    return [self.basicData saveContentWithSecurity:content
                                    service:serviceName
                                        key:key
                                      error:&error];
}

- (NSString *)tkAction_fetchContentWithSecurity:(NSDictionary *)ssInfo
{
    NSString* serviceName = ssInfo[kDataStorageServiceName];
    NSString* key = ssInfo[kDataStorageKey];
    id error = ssInfo[kDataStorageError];
    return [self.basicData fetchContentWithService:serviceName
                                               key:key
                                             error:&error];
}

- (BOOL)tkAction_removeContentWithService:(NSDictionary *)ssInfo
{
    NSString* serviceName = ssInfo[kDataStorageServiceName];
    NSString* key = ssInfo[kDataStorageKey];
    id error = ssInfo[kDataStorageError];
    return [self.basicData removeContentWithService:serviceName
                                                key:key
                                              error:&error];
}

#pragma mark - fileManager
- (NSString *)tkAction_documentsFolder:(NSDictionary *)params
{
    return TKDocumentsFolder();
}

- (NSString *)tkAction_libraryFolder:(NSDictionary *)params
{
    return TKLibraryFolder();
}

- (NSString *)tkAction_tmpFolder:(NSDictionary *)params
{
    return TKTmpFolder();
}

- (NSString *)tkAction_bundleFolder:(NSDictionary *)params
{
    return TKBundleFolder();
}

- (NSString *)tkAction_dcimFolder:(NSDictionary *)params
{
    return TKDCIMFolder();
}

- (NSString *)tkAction_pathForFileNameInFolder:(NSDictionary *)params
{
    NSString* fileName = params[kDataStorageFileName];
    NSString* folder = params[kDataStorageFolder];
    return [NSFileManager pathForFileName:fileName
                                 inFolder:folder];
}

- (NSString *)tkAction_pathForDocumentFileNamed:(NSDictionary *)params
{
    NSString* fileName = params[kDataStorageFileName];
    return [NSFileManager pathForDocumentFileNamed:fileName];
}

- (NSString *)tkAction_pathForBoundleFileNamed:(NSDictionary *)params
{
    NSString* fileName = params[kDataStorageFileName];
    return [NSFileManager pathForBoundleFileNamed:fileName];
}

- (NSString *)tkAction_pathForItemNamedInFolder:(NSDictionary *)params
{
    NSString* fileName = params[kDataStorageFileName];
    NSString* folder = params[kDataStorageFolder];
    return [NSFileManager pathForItemNamed:fileName
                                  inFolder:folder];
}

- (NSString *)tkAction_pathForDocumentNamed:(NSDictionary *)params
{
    NSString* fileName = params[kDataStorageFileName];
    return [NSFileManager pathForDocumentNamed:fileName];
}

- (NSString *)tkAction_pathForBundleDocumentNamed:(NSDictionary *)params
{
    NSString* fileName = params[kDataStorageFileName];
    return [NSFileManager pathForBundleDocumentNamed:fileName];
}

- (NSArray *)tkAction_pathsForItemsMatchingExtensionInFolder:(NSDictionary *) params
{
    NSString* folder = params[kDataStorageFolder];
    NSString* ext = params[kDataStorageExt];
    return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:folder];
}

- (NSArray *)tkAction_pathsForDocumentsMatchingExtension:(NSDictionary *)params
{
    NSString* ext = params[kDataStorageExt];
    return [NSFileManager pathsForBundleDocumentsMatchingExtension:ext];
}

- (NSArray *)tkAction_pathsForBundleMatchingExtension:(NSDictionary *)params
{
    NSString* ext = params[kDataStorageExt];
    return [NSFileManager pathsForBundleDocumentsMatchingExtension:ext];
}

- (NSArray *)tkAction_filesInFolder:(NSDictionary *)params
{
    NSString* path = params[kDataStorageFolder];
    return [NSFileManager filesInFolder:path];
}

- (BOOL)tkAction_findOrCreateDirectoryPath:(NSDictionary *)params
{
    NSString* path = params[kDataStorageFolder];
    return [NSFileManager findOrCreateDirectoryPath:path];
}

- (BOOL)tkAction_findOrCreateDirectoryPathBackupProtection:(NSDictionary *)params
{
    NSString* path = params[kDataStorageFolder];
    BOOL backup = [params[kDataStorageBackup] boolValue];
    NSString* dataProtection = params[kDataStorageDataProtection];
    return [NSFileManager findOrCreateDirectoryPath:path
                                             backup:backup
                                     dataProtection:dataProtection];
}

#pragma mark - sqlite 操作
- (void)tkAction_openSqlite:(NSDictionary *)params
{
    Class modelClass = params[kDataStorageContentClass];
    [TKSqliteDataStorage sqliteDataStorage:modelClass];
}

- (void)tkAction_addData:(NSDictionary *)params
{
    id model = params[kDataStorageContent];
    id hander = params[kDataStorageHander];
    TKSqliteDataStorage* sqliteStorage = [TKSqliteDataStorage sqliteDataStorage:[model class]];
    [sqliteStorage addData:model hander:hander];
}

- (void)tkAction_updateData:(NSDictionary *)params
{
    id model = params[kDataStorageContent];
    id hander = params[kDataStorageHander];
    TKSqliteDataStorage* sqliteStorage = [TKSqliteDataStorage sqliteDataStorage:[model class]];
    [sqliteStorage updateData:model hander:hander];
}

- (void)tkAction_deleteData:(NSDictionary *)params
{
    id model = params[kDataStorageContent];
    id hander = params[kDataStorageHander];
    TKSqliteDataStorage* sqliteStorage = [TKSqliteDataStorage sqliteDataStorage:[model class]];
    [sqliteStorage deleteData:model hander:hander];
}

- (void)tkAction_selectData:(NSDictionary *)params
{
    NSDictionary* sqliteParams = params[kDataStorageContent];
    Class modelClass = params[kDataStorageContentClass];
    id hander = params[kDataStorageHander];
    TKSqliteDataStorage* sqliteStorage = [TKSqliteDataStorage sqliteDataStorage:modelClass];
    [sqliteStorage fetchDataWithParams:sqliteParams
                                 class:modelClass
                                hander:hander];
}

@end
