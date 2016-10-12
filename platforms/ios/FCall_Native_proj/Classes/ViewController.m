

#import "ViewController.h"
#import "MainTabBarController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)btnRegister:(id)sender {
    [(MainTabBarController *)self.tabBarController sip_Register:@"9002" password:@"2133"];
}

- (IBAction)btnCall:(id)sender {
    [(MainTabBarController *)self.tabBarController sip_MakeCall:@"9001"];
}

- (IBAction)btnHangUp:(id)sender {
    [(MainTabBarController *)self.tabBarController sip_HangUp];
}

- (IBAction)btnAccept:(id)sender {
    [(MainTabBarController *)self.tabBarController sip_Acept];
}

@end
