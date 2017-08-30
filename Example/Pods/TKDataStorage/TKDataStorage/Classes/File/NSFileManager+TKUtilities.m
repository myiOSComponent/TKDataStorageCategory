//
//  NSFileManager+TKUtilities.m
//  Pods
//
//  Created by 云峰李 on 2017/8/24.
//
//

#import "NSFileManager+TKUtilities.h"

NSString *TKDocumentsFolder() {
    static NSString* documentsFolder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsFolder = [paths objectAtIndex:0];
    });
    return documentsFolder;
}

NSString *TKLibraryFolder() {
    static NSString* libraryFolder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        libraryFolder = [paths objectAtIndex:0];
    });
    
    return libraryFolder;
}

NSString *TKTmpFolder()
{
    static NSString* tmpFolder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tmpFolder = NSTemporaryDirectory();
    });
    return tmpFolder;
}

NSString *TKBundleFolder() {
    
    return [[NSBundle mainBundle] bundlePath];
}

NSString *TKDCIMFolder() {
    
    return @"/var/mobile/Media/DCIM";
}

@implementation NSFileManager(TKUtilities)

+ (NSString *) pathForFileName:(NSString *)fileName inFolder:(NSString *) path;
{
    if (!fileName || !path) {
        return nil;
    }
    return [path stringByAppendingPathComponent:fileName];
}

+ (NSString *) pathForDocumentFileNamed:(NSString *) fname
{
    return [NSFileManager pathForFileName:fname inFolder:TKDocumentsFolder()];
}

+ (NSString *) pathForBoundleFileNamed:(NSString *) fname
{
    return [NSFileManager pathForFileName:fname inFolder:TKBundleFolder()];
}

+ (NSString *) pathForItemNamed: (NSString *) fname inFolder: (NSString *) path {
    NSString *file;
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while (file = [dirEnum nextObject])
        if ([[file lastPathComponent] isEqualToString:fname])
            return [path stringByAppendingPathComponent:file];
    return nil;
}

+ (NSString *) pathForDocumentNamed: (NSString *) fname {
    
    return [NSFileManager pathForItemNamed:fname inFolder:TKDocumentsFolder()];
}

+ (NSString *) pathForBundleDocumentNamed: (NSString *) fname {
    
    return [NSFileManager pathForItemNamed:fname inFolder:TKBundleFolder()];
}

+ (NSArray *) filesInFolder: (NSString *) path {
    
    NSString *file;
    NSMutableArray *results = [NSMutableArray array];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while (file = [dirEnum nextObject])
    {
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory: &isDir];
        if (!isDir) [results addObject:file];
    }
    return results;
}

// Case insensitive compare, with deep enumeration
+ (NSArray *) pathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path {
    
    NSString *file;
    NSMutableArray *results = [NSMutableArray array];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while (file = [dirEnum nextObject])
        if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
            [results addObject:[path stringByAppendingPathComponent:file]];
    return results;
}

+ (NSArray *) pathsForDocumentsMatchingExtension: (NSString *) ext {
    
    return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:TKDocumentsFolder()];
}

// Case insensitive compare
+ (NSArray *) pathsForBundleDocumentsMatchingExtension: (NSString *) ext {
    
    return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:TKBundleFolder()];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    return success;
}

+ (BOOL)findOrCreateDirectoryPath:(NSString *)path {
    
    return [NSFileManager findOrCreateDirectoryPath:path backup:YES dataProtection:nil];
}

+ (BOOL)findOrCreateDirectoryPath:(NSString *)path backup:(BOOL)shouldBackup dataProtection:(NSString *)dataProtection {
    
    BOOL isDirectory;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (exists) {
        if (isDirectory) return YES;
        return NO;
    }
    
    //
    // Create the path if it doesn't exist
    //
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    //
    if (success && !shouldBackup) {
        //	try to set no-iCloud-backup folder, but do not fail everything if this particular bit fails
        [[NSFileManager defaultManager] addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
    }
    
    if (success && dataProtection != nil) {
        //	also, set protection level as requested
        [[NSFileManager defaultManager] setAttributes:@{NSFileProtectionKey:dataProtection} ofItemAtPath:path error:&error];
    }
    
    return success;
}

@end
