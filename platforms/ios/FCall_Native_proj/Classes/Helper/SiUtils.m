//
//  SiUtils.m
//  TimPhim
//
//  Created by sinhngn on 5/18/14.
//  Copyright (c) 2014 rad.ftel. All rights reserved.
//

#import "SiUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AES)
- (NSData *)AES256DecryptWithKey:(NSString *)key;
- (NSData *)AES256EncryptWithKey:(NSString *)key;
@end

@implementation SiUtils

+ (CGSize)getScreenFrameSize {
    float screenHeight = [[UIScreen mainScreen] applicationFrame].size.height+20;
	float screenWidth = [[UIScreen mainScreen] applicationFrame].size.width;
	if (( [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight)
		||( [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft))
	{
		screenWidth = screenHeight;
        screenHeight = [[UIScreen mainScreen] applicationFrame].size.width;
	}
    return CGSizeMake(screenWidth, screenHeight);
}

#pragma mark - Crypto

+ (NSString*)getSHA1:(NSString*)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}

+ (NSString*)getSHA1WithData:(NSData*)data {

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}

+ (NSData *)encryptAESString:(NSString*)plaintext withKey:(NSString*)key {
	return [[plaintext dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
}

+ (NSString *)decryptAESData:(NSData*)ciphertext withKey:(NSString*)key {
	return [[NSString alloc] initWithData:[ciphertext AES256DecryptWithKey:key]
                                 encoding:NSUTF8StringEncoding];
}

#pragma mark - Image

+ (UIImage *)imageByOverwriteColor:(UIColor *)color alpha:(float)alpha image:(UIImage*)image {
	CGFloat screenScale = [[UIScreen mainScreen] scale];
	CGSize newSize = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, screenScale);
	CGContextRef context = UIGraphicsGetCurrentContext();

	[image drawInRect:CGRectMake(0,0,newSize.width, newSize.height) blendMode:(kCGBlendModeSourceOut) alpha:1];

	CGContextSetFillColorWithColor(context, color.CGColor);
	CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
	CGContextSetAlpha(context, alpha);
	CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(CGPointZero.x, CGPointZero.y, newSize.width, newSize.height));

	UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resultImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size point:(CGPoint)xy
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(xy.x, xy.y, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+ (UIImage *)imageWithImageHeight:(UIImage *)image height:(float)height
{
    CGSize itemSize = CGSizeMake( image.size.width*height/image.size.height, height);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, image.size.width*height/image.size.height, height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

#pragma mark - Color

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }

    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }

    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (void)saveUserDefaults:(NSDictionary *)dictionary {
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSArray *array = dictionary.allKeys ;
    for(NSString *key in array){
        NSString *value = [dictionary objectForKey:key];
        [defaults setObject:value forKey:key];
    }

    [defaults synchronize];
}

+ (id)getUserDefaults:(NSString *)key {
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   id value = [defaults objectForKey:key];
    return value;
}

+ (void)removeUserDefaults:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}
#pragma mark - Handle string
+ (NSString*)CheckNULLString:(NSString*)input {
    if(![input isEqualToString:@"<null>" ])
        return input;
    else
        return @"";
}

+ (NSString *)getcurrentTime {
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    return dateString;
}

+ (NSDate *)getHCMTime {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Ho_Chi_Minh"]];
    NSDate *estDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:now]];
    
    return estDate;
}

@end

@implementation NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key {
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)

	// fetch key data
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

	NSUInteger dataLength = [self length];

	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);

	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
	}

	free(buffer); //free the buffer;
	return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key {
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)

	// fetch key data
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

	NSUInteger dataLength = [self length];

	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);

	size_t numBytesDecrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);

	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
	}

	free(buffer); //free the buffer;
	return nil;
}

@end