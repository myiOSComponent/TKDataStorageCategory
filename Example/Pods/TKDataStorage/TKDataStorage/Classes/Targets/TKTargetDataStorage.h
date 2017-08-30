//
//  TKTargetDataStorage.h
//  Pods
//
//  Created by 云峰李 on 2017/8/29.
//
//

#import <Foundation/Foundation.h>

@interface TKTargetDataStorage : NSObject

#pragma mark - 文件写入

- (BOOL)tkAction_writeDataToFile:(NSDictionary *)fileInfo;
- (id) tkAction_readContentInFile:(NSDictionary *)fileInfo;

#pragma mark - 数据存储

- (void)tkAction_saveData:(NSDictionary *)valueInfo;
- (id)tkAction_fetchData:(NSDictionary *)keyInfo;

#pragma mark - Security

- (BOOL)tkAction_saveContentWithSecurity:(NSDictionary *)ssInfo;
- (NSString *)tkAction_fetchContentWithSecurity:(NSDictionary *)ssInfo;
- (BOOL)tkAction_removeContentWithService:(NSDictionary *)ssInfo;

#pragma mark - fileManager
- (NSString *)tkAction_documentsFolder:(NSDictionary *)params;
- (NSString *)tkAction_libraryFolder:(NSDictionary *)params;
- (NSString *)tkAction_tmpFolder:(NSDictionary *)params;
- (NSString *)tkAction_bundleFolder:(NSDictionary *)params;
- (NSString *)tkAction_dcimFolder:(NSDictionary *)params;

- (NSString *)tkAction_pathForFileNameInFolder:(NSDictionary *)params;
- (NSString *)tkAction_pathForDocumentFileNamed:(NSDictionary *)params;
- (NSString *)tkAction_pathForBoundleFileNamed:(NSDictionary *)params;

- (NSString *)tkAction_pathForItemNamedInFolder:(NSDictionary *)params;
- (NSString *)tkAction_pathForDocumentNamed:(NSDictionary *)params;
- (NSString *)tkAction_pathForBundleDocumentNamed:(NSDictionary *)params;

- (NSArray *)tkAction_pathsForItemsMatchingExtensionInFolder:(NSDictionary *) params;
- (NSArray *)tkAction_pathsForDocumentsMatchingExtension:(NSDictionary *)params;
- (NSArray *)tkAction_pathsForBundleMatchingExtension:(NSDictionary *)params;

- (NSArray *)tkAction_filesInFolder:(NSDictionary *)params;

- (BOOL)tkAction_findOrCreateDirectoryPath:(NSDictionary *)params;
- (BOOL)tkAction_findOrCreateDirectoryPathBackupProtection:(NSDictionary *)params;

#pragma mark - sqlite 操作
- (void)tkAction_openSqlite:(NSDictionary *)params;
- (void)tkAction_addData:(NSDictionary *)params;
- (void)tkAction_updateData:(NSDictionary *)params;
- (void)tkAction_deleteData:(NSDictionary *)params;
- (void)tkAction_selectData:(NSDictionary *)params;

@end
