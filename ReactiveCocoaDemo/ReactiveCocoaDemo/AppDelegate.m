//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//
//   使用ReactiveCocoa框架第一步，使用导入框架
//
//   $ platform:ios,'8.0'
//   $ use_frameworks!
//   $ target ‘ReactiveCocoaDemo’ do
//   $ pod 'ReactiveCocoa', '~> 4.1.0'
//   $ end
//
//////////////////////////////////////////////
//////////////////////////////////////////////

#import "AppDelegate.h"
#import "RACMainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    RACMainViewController *mainVc = [[RACMainViewController alloc]init];
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:mainVc];
    self.window.rootViewController = mainNav;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
