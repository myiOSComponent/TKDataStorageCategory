//
//  TKMiddleware+TKDataStorage.h
//  Pods
//
//  Created by 云峰李 on 2017/8/30.
//
//

#import <Foundation/Foundation.h>
#import <TKMiddleWare/TKMiddleWare.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *TKDocumentsFolder();
FOUNDATION_EXTERN NSString *TKLibraryFolder();
FOUNDATION_EXTERN NSString *TKTmpFolder();
FOUNDATION_EXTERN NSString *TKBundleFolder();
FOUNDATION_EXTERN NSString *TKDCIMFolder();

@interface TKMiddleWare (TKDataStorage)

#pragma mark - 文件写入

- (BOOL) writeData:(NSData *) data
            toFile:(NSString *)file
        atomically:(BOOL) atomically;

- (id) readContentsOfFile:(NSString *)filePath
                 useClass:(Class)contentClass;

#pragma mark - NSUserDefaults 相关

- (void) saveData:(id)data forKey:(NSString *)key;
- (id) fetchData:(NSString *)key;

#pragma mark - Security

- (BOOL)saveContentWithSecurity:(NSString *)content service:(NSString *)serviceName key:(NSString *)key;

- (nonnull NSString *)fetchContentWithService:(NSString *)serviceName key:(NSString *)key;

- (BOOL)removeContentWithService:(NSString *)serviceName key:(NSString *)key;

#pragma mark - file

- (NSString *) pathForFileName:(NSString *)fileName inFolder:(NSString *) path;
- (NSString *) pathForDocumentFileNamed:(NSString *) fname;
- (NSString *) pathForBoundleFileNamed:(NSString *) fname;

- (NSString *) pathForItemNamed: (NSString *) fname inFolder: (NSString *) path;
- (NSString *) pathForDocumentNamed: (NSString *) fname;
- (NSString *) pathForBundleDocumentNamed: (NSString *) fname;

- (NSArray *) pathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path;
- (NSArray *) pathsForDocumentsMatchingExtension: (NSString *) ext;
- (NSArray *) pathsForBundleDocumentsMatchingExtension: (NSString *) ext;

- (NSArray *) filesInFolder: (NSString *) path;

- (BOOL) findOrCreateDirectoryPath:(NSString *)path;
- (BOOL) findOrCreateDirectoryPath:(NSString *)path backup:(BOOL)shouldBackup dataProtection:(NSString *)dataProtection;

#pragma mark - sqlite

- (void)openSqliteWithModelClass:(Class)modelClass;

- (void)addData:(id)model hander:(void (^)(BOOL status, NSError * error))hander;

- (void)updateData:(id)model hander:(void (^)(BOOL status, NSError * error))hander;

- (void)deleteData:(id)model hander:(void (^)(BOOL status, NSError * error))hander;

- (void)fetchDataWithParams:(NSDictionary *)params class:(Class)modelClass hander:(void (^)(id ret, NSError *error)) hander;

@end

NS_ASSUME_NONNULL_END
