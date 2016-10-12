
#import "MainTabBarController.h"
#import "ViewController.h"

#define TABBAR_ICON_HEIGHT 24
#define TAG_ERROR 50
#define HEIGHT_SUBVIEW 30

#define CORDOVA_READY @"Ready"

#define USERAGENT_CONNECTED @"connected"
#define USERAGENT_DISCONNECTED @"disconnected"
#define USERAGENT_REGISTERFAIL @"registrationFailed"
#define USERAGENT_UNREGISTERING @"unregistering"
#define USERAGENT_UNREGISTER @"unregistered"
#define USERAGENT_REGISTERING @"registering"
#define USERAGENT_REGISTERED @"registered"
#define USERAGENT_INVITE @"invite"

#define SESSION_INVITING @"inviting"
#define SESSION_CONNECTING @"connecting"
#define SESSION_CHECKING @"checking"
#define SESSION_CHECKED @"checked"
#define SESSION_ACCEPTED @"accepted"
#define SESSION_CANCEL @"cancel"
#define SESSION_PROGRESS @"in progress"
#define SESSION_RINGING @"ringing"
#define SESSION_REFER @"refer"
#define SESSION_REPLACE @"replaced"
#define SESSION_DTMF @"dtmf"
#define SESSION_BYE @"bye"
#define SESSION_FAILED @"failed"
#define SESSION_REJECTED @"rejected"
#define SESSION_ACCEPTING @"waiting"
#define SESSION_HANGUP @"hangup"
#define SESSION_TERMINATED @"terminated"
#define SESSION_DISSMISS @"dissmiss"
#define SESSION_HANGUP @"hangup"
#define SESSION_BUSY @"Busy"
#define SESSION_RENEW @"renew"
#define SESSION_RENEWED @"renewed"
#define SESSION_CONNECT_TIMEOUT @"time_out"
#define SESSION_NO_ANSWER @"No Answer"

@interface MainTabBarController ()

@end

@implementation MainTabBarController {
    NSTimer *timer;
    ViewController *myViewController;
}

@synthesize lblAlertConnection, viewConnectStatus, notifi;
@dynamic delegate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupTabBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveError:) name:SEND_ERROR object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)viewWillDisappear:(BOOL)animated {
}

#pragma mark - Receive Notification Center

- (void)receiveError:(NSNotification *) notification {
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *message =[[NSString alloc] initWithData:[userInfo objectForKey:SEND_ERROR] encoding:NSUTF8StringEncoding];
    
    if ([message rangeOfString:@"candidate"].location != NSNotFound) {
        [self setSession_Status:SESSION_RENEW];
        [self setUser_Status:SESSION_RENEW];
    }
}

#pragma mark - TabBar Setup

- (void)setupTabBar {
    
    [[UINavigationBar appearance] setBarTintColor:colorWithRGB(251, 135, 42, 1.0)];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    myViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.viewControllers = @[myViewController];
    
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setTintColor:colorWithRGB(253, 114, 1, 1.0)];
    [self setSelectedIndex:2];

}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Call Sip Js Function

- (void)sip_Register:(NSString *)numberID password:(NSString *)password {
    NSLog(@"Sip Register");
    
    [self loadingShow];
    NSString *token = @"123";
    [self.commandDelegate runInBackground:^{
        [self.commandDelegate evalJs:StringFormat(@"setTimeout(function(){register('%@','%@','%@');})", numberID, password, token)];
    }];
}

- (void)sip_MakeCall:(NSString *)phoneNumber {
    
    if ([phoneNumber isEqualToString:@""]||[phoneNumber isEqualToString:[SiUtils getUserDefaults:USER_ID]]) {
        return;
    }
    if ([[self getUser_Status] isEqualToString:USERAGENT_DISCONNECTED]||[[self getUser_Status] isEqualToString:USERAGENT_REGISTERFAIL]) {
        [self performSelector:@selector(dissmissDisconnect)
                   withObject:nil
                   afterDelay:2.0];
        return;
    }

    [self callAction:phoneNumber];
}

- (void)callAction:(NSString *)number {
    
        [self loadingShow];
        [self.commandDelegate runInBackground:^{
            [self.commandDelegate evalJs:StringFormat(@"setTimeout(function(){makeCall('%@');})", number)];
        }];
}

- (void)sip_HangUp {
    
    [self loadingShow];
    [self.commandDelegate runInBackground:^{
        [self.commandDelegate evalJs:@"setTimeout(function(){hangUp();})"];
    }];
}

- (void)sip_Acept {
    
    [self loadingShow];
    [self.commandDelegate runInBackground:^{
        [self.commandDelegate evalJs:@"acept();"];
    }];
}


- (void)sip_ClearData {
    
    [self loadingShow];
    [self.commandDelegate runInBackground:^{
        [self.commandDelegate evalJs:@"setTimeout(function(){clearLocalData();})"];
    }];
}

#pragma mark - Plugin Callback

- (void)pluginChange_UserStatus:(NSString *)status param:(NSString *)param {

    [[myViewController lblStatus] setText:status];
    self.user_Status = status;
}

- (void)pluginChange_SessionStatus:(NSString *)status param:(NSString *)param {
    
    [[myViewController lblStatus] setText:status];
    self.session_Status = status;
}

- (void)pluginChange_CordovaStatus:(NSString *)status {
    if ([status isEqualToString:CORDOVA_READY]) {
    }
}


- (NSString *)getUser_Status {
    return  self.user_Status;
}

- (NSString *)getSession_Status {
    return  self.session_Status;
}

- (void)setTimeOutCallerView:(int)second {
    
    [self performSelector:@selector(dissmissConnecting)
               withObject:nil
               afterDelay:second];
}

- (void)dissmissConnecting {
    
}

- (void)dissmissDisconnect {
    
    if ([self.user_Status isEqualToString:USERAGENT_DISCONNECTED]||[self.user_Status isEqualToString:USERAGENT_REGISTERFAIL]) {
    }
}
- (void)loadingShow {
    
}

@end
