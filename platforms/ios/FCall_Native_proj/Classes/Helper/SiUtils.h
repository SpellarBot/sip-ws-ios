//
//  SiUtils.h
//  TimPhim
//
//  Created by sinhngn on 5/18/14.
//  Copyright (c) 2014 rad.ftel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"

@interface SiUtils : NSObject

#pragma mark - frame
+ (CGSize)getScreenFrameSize;
+ (NSString *)getcurrentTime;
+ (NSDate *)getHCMTime;

#pragma mark - Crypto
+ (NSString *)getSHA1:(NSString*)input;
+ (NSString *)getSHA1WithData:(NSData*)data;
+ (NSData *)encryptAESString:(NSString*)plaintext withKey:(NSString*)key;
+ (NSString *)decryptAESData:(NSData*)ciphertext withKey:(NSString*)key;

#pragma mark - Image
+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size point:(CGPoint)xy;
+ (UIImage *)imageWithImageHeight:(UIImage *)image height:(float)height;
+ (UIImage *)imageByOverwriteColor:(UIColor *)color alpha:(float)alpha image:(UIImage*)image;

#pragma mark - Color
+ (UIColor *)colorFromHexString:(NSString *)hexString;

#pragma mark - UserDefaults
+ (void)saveUserDefaults:(NSDictionary *)dictionary;
+ (id)getUserDefaults:(NSString *)key;
+ (void)removeUserDefaults:(NSString *)key;

#pragma mark - Handle string
+ (NSString *)CheckNULLString:(NSString*)input;
@end