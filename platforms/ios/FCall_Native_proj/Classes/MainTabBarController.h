

#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import <Cordova/CDVCommandQueue.h>
#import "SiUtils.h"

@protocol MainTabBarControllerDelegate <NSObject>
- (void)autoRegister;
@end

@interface MainTabBarController : CDVViewController

@property (nonatomic,retain) UIView *viewConnectStatus;
@property (nonatomic,retain) UILabel *lblAlertConnection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHeight;
@property (nonatomic, assign) BOOL lostNetwork;

@property(nonatomic, retain) UILocalNotification* notifi;

@property(nonatomic, retain) NSString *user_Status;
@property(nonatomic, retain) NSString *session_Status;

@property(nonatomic) long push_time;
@property(nonatomic, retain) NSString *push_UserID;
@property(nonatomic) int registerCount;

@property(nonatomic, assign) id <UITabBarControllerDelegate, MainTabBarControllerDelegate> delegate;

- (void)clearCallingLocalNotification;

/***  Call Sip Js function  ***/

- (void)sip_Register:(NSString *)numberID password:(NSString *)password;
- (void)sip_MakeCall:(NSString *)phoneNumber;
- (void)sip_HangUp;
- (void)sip_Acept;
/***  Plugin function  ***/

- (void)pluginChange_UserStatus:(NSString *)status param:(NSString *)param;
- (void)pluginChange_SessionStatus:(NSString *)status param:(NSString *)param;
- (void)pluginChange_CordovaStatus:(NSString *)status;
@end
