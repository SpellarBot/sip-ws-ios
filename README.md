# sip-ws-ios
sip over websocket demo on ios


**Register to server**: - (void)sip_Register:(NSString *)numberID password:(NSString *)password;
    
    example: register to server with user:9002, password:2133
        [(MainTabBarController *)self.tabBarController sip_Register:@"9002" password:@"2133"];


**Make a call**: - (void)sip_MakeCall:(NSString *)phoneNumber;
    
    example: make a call to user "9001"
        [(MainTabBarController *)self.tabBarController sip_MakeCall:@"9001"];
        
        
**Hangup a call**: - (void)sip_HangUp;
  
    example:
        [(MainTabBarController *)self.tabBarController sip_HangUp];
  
**Accept a call from another user**: - (void)sip_Acept;
  
    example:
        [(MainTabBarController *)self.tabBarController sip_Acept];
