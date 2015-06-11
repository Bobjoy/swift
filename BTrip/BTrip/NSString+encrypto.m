//
//  NSString+encrypto.m
//  Vetrip
//
//  Created by Vetech on 15/6/1.
//  Copyright (c) 2015年 Vetech. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+encrypto.h"

@implementation NSString (encrypto)

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
