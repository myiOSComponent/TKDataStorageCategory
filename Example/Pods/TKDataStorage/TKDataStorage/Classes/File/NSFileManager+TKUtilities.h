//
//  NSFileManager+TKUtilities.h
//  Pods
//
//  Created by 云峰李 on 2017/8/24.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *TKDocumentsFolder();
FOUNDATION_EXTERN NSString *TKLibraryFolder();
FOUNDATION_EXTERN NSString *TKTmpFolder();
FOUNDATION_EXTERN NSString *TKBundleFolder();
FOUNDATION_EXTERN NSString *TKDCIMFolder();

@interface NSFileManager(TKUtilities)

/**
 组装文件路径

 @param fileName 文件名字
 @param path 路径
 @return 绝对路径
 */
+ (NSString *) pathForFileName:(NSString *)fileName inFolder:(NSString *) path;
+ (NSString *) pathForDocumentFileNamed:(NSString *) fname;
+ (NSString *) pathForBoundleFileNamed:(NSString *) fname;

+ (NSString *) pathForItemNamed: (NSString *) fname inFolder: (NSString *) path;
+ (NSString *) pathForDocumentNamed: (NSString *) fname;
+ (NSString *) pathForBundleDocumentNamed: (NSString *) fname;

+ (NSArray *) pathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path;
+ (NSArray *) pathsForDocumentsMatchingExtension: (NSString *) ext;
+ (NSArray *) pathsForBundleDocumentsMatchingExtension: (NSString *) ext;

+ (NSArray *) filesInFolder: (NSString *) path;

+ (BOOL) findOrCreateDirectoryPath:(NSString *)path;
+ (BOOL) findOrCreateDirectoryPath:(NSString *)path backup:(BOOL)shouldBackup dataProtection:(NSString *)dataProtection;

@end
