//
//  TKFileTests.m
//  TKDataStorage
//
//  Created by 云峰李 on 2017/8/29.
//  Copyright © 2017年 512869343@qq.com. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <TKDataStorageCategory/TKMiddleware+TKDataStorage.h>

SPEC_BEGIN(TKFileUtiltisTets)

context(@"正常情况", ^{
    it(@"test for NSDocumentsFolder", ^{
        NSString* documentsFolder = TKDocumentsFolder();
        NSLog(@"document 目录为%@",documentsFolder);
        [[documentsFolder should] beNonNil];
    });
    
    it(@"test NSLibraryFolder", ^{
        NSString* libraryFolder = TKLibraryFolder();
        NSLog(@"library 目录为%@", libraryFolder);
        [[libraryFolder should] beNonNil];
    });
    
    it(@"test TKTmpFolder", ^{
        NSString* tmpFolder = TKTmpFolder();
        NSLog(@"tmp 目录为%@", tmpFolder);
        [[tmpFolder should] beNonNil];
    });
    
    it(@"test TKDCIMFolder", ^{
        NSString *dicimFolder = TKDCIMFolder();
        NSLog(@"dcim 目录为%@", dicimFolder);
        [[dicimFolder should] beNonNil];
    });
    
    it(@"test for pathForItemNamed:inFolder:", ^{
        NSString* filePath = [TKMiddleWareMgr pathForItemNamed:@"test" inFolder:TKDocumentsFolder()];
        NSLog(@"获取的目录为:%@",filePath);
        [[filePath should] beNil];
    });
    
    it(@"test for pathForBundleDocumentNamed", ^{
        NSString* filePath = [TKMiddleWareMgr pathForDocumentNamed:@"hjhahah"];
        NSLog(@"获取的目录为:%@",filePath);
        [[filePath should] beNil];
    });
    
    it(@"test for pathForBundleDocumentNamed", ^{
        NSString* filePath = [TKMiddleWareMgr pathForBundleDocumentNamed:@"testaa"];
        NSLog(@"获取的目录为:%@",filePath);
        [[filePath should] beNil];
    });
    
    it(@"test for pathForFileName:inFolder:", ^{
        NSString* filePath = [TKMiddleWareMgr pathForFileName:@"test" inFolder:TKDocumentsFolder()];
        NSLog(@"获取的目录为:%@",filePath);
        [[filePath should] beNonNil];
    });
    
    it(@"test for pathForDocumentFileNamed", ^{
        NSString* filePath = [TKMiddleWareMgr pathForDocumentFileNamed:@"hjhahah"];
        NSLog(@"获取的目录为:%@",filePath);
        [[filePath should] beNonNil];
    });
    
    it(@"test for pathForBoundleFileNamed", ^{
        NSString* filePath = [TKMiddleWareMgr pathForBoundleFileNamed:@"testaa"];
        NSLog(@"获取的目录为:%@",filePath);
        [[filePath should] beNonNil];
    });
    
    it(@"test for findOrCreateDirectoryPath", ^{
        NSString* filePath = [TKMiddleWareMgr pathForDocumentFileNamed:@"create"];
        BOOL ret = [TKMiddleWareMgr findOrCreateDirectoryPath:filePath];
        id obj = @(ret);
        [[obj should] equal:@(YES)];
    });
    
    it(@"test for has files filesInFolder", ^{
        NSString* filePath = [TKMiddleWareMgr pathForDocumentNamed:@"create"];
        NSArray* files = [TKMiddleWareMgr filesInFolder:filePath];
        [[files shouldNot] beNil];
    });
    
    it(@"test for no files filesInFolder", ^{
        NSString* tmpPath = TKTmpFolder();
        NSArray* files = [TKMiddleWareMgr filesInFolder:tmpPath];
//        XCTAssertTrue(files.count == 0);
    });
    
    it(@"test for pathsForBundleDocumentsMatchingExtension", ^{
        NSString* filePath = [TKMiddleWareMgr pathForDocumentNamed:@"create"];
        NSArray* files = [TKMiddleWareMgr pathsForItemsMatchingExtension:@"xml" inFolder:filePath];
        XCTAssertTrue(files.count == 0);
    });
});

SPEC_END

