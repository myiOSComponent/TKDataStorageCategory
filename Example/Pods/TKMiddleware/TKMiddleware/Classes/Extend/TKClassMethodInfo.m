//
//  TKClassMethodInfo.m
//  TKMiddleWare
//
//  Created by 云峰李 on 2017/8/23.
//  Copyright © 2017年 thinkWind. All rights reserved.
//

#import "TKClassMethodInfo.h"

TK_ENCODING_TYPE GetEncodingType(const char* typeEncoding)
{
    char* type = (char*) typeEncoding;
    //判空
    if (!type) return TK_ENCODING_TYPE_UNKNOWN;
    //获取字符串长度
    size_t length = strlen(type);
    //判空
    if (length == 0) return TK_ENCODING_TYPE_UNKNOWN;
    
    switch (*type) {
        case 'v':return TK_ENCODING_TYPE_VOID ;
        case 'B':return TK_ENCODING_TYPE_BOOL ;
        case 'c':return TK_ENCODING_TYPE_INT8 ;
        case 'C':return TK_ENCODING_TYPE_UINT8;
        case 's':return TK_ENCODING_TYPE_INT16;
        case 'S':return TK_ENCODING_TYPE_UINT16;
        case 'i':return TK_ENCODING_TYPE_INT32;
        case 'I':return TK_ENCODING_TYPE_UINT32;
        case 'l':return TK_ENCODING_TYPE_INT64;
        case 'L':return TK_ENCODING_TYPE_UINT64;
        case 'q':return TK_ENCODING_TYPE_INT64;
        case 'Q':return TK_ENCODING_TYPE_UINT64;
        case 'f':return TK_ENCODING_TYPE_FLOAT;
        case 'd':return TK_ENCODING_TYPE_DOUBLE;
        case 'D':return TK_ENCODING_TYPE_LONGDOUBLE;
        case '#':return TK_ENCODING_TYPE_CLASS;
        case ':':return TK_ENCODING_TYPE_SEL;
        case '*':return TK_ENCODING_TYPE_CSTRING;
        case '^':return TK_ENCODING_TYPE_POINTER;
        case '[':return TK_ENCODING_TYPE_CARRAY;
        case '(':return TK_ENCODING_TYPE_UNION;
        case '{':return TK_ENCODING_TYPE_STRUCT;
        case '@':{
            if (length == 2 && *(type + 1) == '?') {
                return TK_ENCODING_TYPE_BLOCK;
            }else
            {
                return TK_ENCODING_TYPE_OBJECT;
            }
        }
    }
    return TK_ENCODING_TYPE_UNKNOWN;
}

@implementation TKClassMethodInfo

- (instancetype)initWithMethod:(Method)method
{
    if (!method) return nil;
    self = [super init];
    if (self) {
        _method = method;
        _sel = method_getName(method);
        _imp = method_getImplementation(method);
        
        const char* name = sel_getName(_sel);
        if (name) {
            _name = [NSString stringWithUTF8String:name];
        }
        
        const char* typeEncoding = method_getTypeEncoding(method);
        if (typeEncoding) {
            _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        }
        
        char* returnType = method_copyReturnType(method);
        if (returnType) {
            _returnTypeEncoding = [NSString stringWithUTF8String:returnType];
            _returnType = GetEncodingType(returnType);
            free(returnType);
        }
    }
    return self;
}

@end
