//
//  TKClassMethodInfo.h
//  TKMiddleWare
//
//  Created by 云峰李 on 2017/8/23.
//  Copyright © 2017年 thinkWind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 *  OC 中各个类型的编码类型
 */
typedef NS_OPTIONS(NSUInteger, TK_ENCODING_TYPE) {
    
    TK_ENCODING_TYPE_MASK          = 0xFF, // 编码类型标志
    TK_ENCODING_TYPE_UNKNOWN       = 0,    // unknown
    TK_ENCODING_TYPE_VOID          = 1,    // Void
    TK_ENCODING_TYPE_BOOL          = 2,    // bool
    TK_ENCODING_TYPE_INT8          = 3,    // char/BOOL
    TK_ENCODING_TYPE_UINT8         = 4,    // unsigned char
    TK_ENCODING_TYPE_INT16         = 5,    // short
    TK_ENCODING_TYPE_UINT16        = 6,    // unsigned short
    TK_ENCODING_TYPE_INT32         = 7,    // int
    TK_ENCODING_TYPE_UINT32        = 8,    // unsigned int
    TK_ENCODING_TYPE_INT64         = 9,    // long long
    TK_ENCODING_TYPE_UINT64        = 10,   // unsigned long long
    TK_ENCODING_TYPE_FLOAT         = 11,   // float
    TK_ENCODING_TYPE_DOUBLE        = 12,   // double
    TK_ENCODING_TYPE_LONGDOUBLE    = 13,   // long double
    TK_ENCODING_TYPE_OBJECT        = 14,   // object -> id
    TK_ENCODING_TYPE_CLASS         = 15,   // Class
    TK_ENCODING_TYPE_SEL           = 16,   // SEL
    TK_ENCODING_TYPE_BLOCK         = 17,   // Block
    TK_ENCODING_TYPE_POINTER       = 18,   // Pointer -> void*
    TK_ENCODING_TYPE_STRUCT        = 19,   // struct
    TK_ENCODING_TYPE_UNION         = 20,   // Union
    TK_ENCODING_TYPE_CSTRING       = 21,   // CString
    TK_ENCODING_TYPE_CARRAY        = 22,   // char[10]
    
};

FOUNDATION_EXTERN TK_ENCODING_TYPE GetEncodingType(const char* typeEncoding);

@interface TKClassMethodInfo : NSObject

@property (nonatomic, assign, readonly) TK_ENCODING_TYPE returnType;
@property (nonatomic, assign, readonly) SEL sel;
@property (nonatomic, assign, readonly) IMP imp;
@property (nonatomic, assign, readonly) Method method;
@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, strong, readonly) NSString* typeEncoding;
@property (nonatomic, strong, readonly) NSString* returnTypeEncoding;

- (instancetype)initWithMethod:(Method) method;

@end
