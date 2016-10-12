//
//  CallNativePlugin.m
//  FCall_Native_proj
//
//  Created by Tan Tan on 4/22/16.
//
//

#import "CallNativePlugin.h"

#define EXEC_TYPE_USER @"user"
#define EXEC_TYPE_SESSION @"session"
#define EXEC_TYPE_OTHER @"other"

@implementation CallNativePlugin

- (void)echo:(CDVInvokedUrlCommand*)command {
    
    CDVPluginResult* pluginResult = nil;
    NSString* type = [command.arguments objectAtIndex:0];
    
    if (type != nil && [type length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:type];
        
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    NSLog(@"%@",[command.arguments objectAtIndex:1]);
    
    if ([type isEqualToString:EXEC_TYPE_USER]) {
        [(MainTabBarController *)self.viewController pluginChange_UserStatus:[command.arguments objectAtIndex:1] param:StringFormat(@"%@", [command.arguments objectAtIndex:2])];
        
    } else if ([type isEqualToString:EXEC_TYPE_SESSION]) {
        [(MainTabBarController *)self.viewController pluginChange_SessionStatus:[command.arguments objectAtIndex:1] param:StringFormat(@"%@", [command.arguments objectAtIndex:2])];
        
    } else {
        [(MainTabBarController *)self.viewController pluginChange_CordovaStatus:StringFormat(@"%@",[command.arguments objectAtIndex:1])];
    }
    
    [self.commandDelegate runInBackground:^{
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end
