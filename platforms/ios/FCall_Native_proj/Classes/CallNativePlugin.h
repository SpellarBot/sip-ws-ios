//
//  CallNativePlugin.h
//  FCall_Native_proj
//
//  Created by Tan Tan on 4/22/16.
//
//

#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import <Cordova/CDVCommandQueue.h>
#import "MainTabBarController.h"

@interface CallNativePlugin : CDVPlugin
- (void)echo:(CDVInvokedUrlCommand*)command;
@end
