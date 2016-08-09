//
//  AppDelegate.m
//  CallCenter
//
//  Created by aiquantong on 22/6/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "AppDelegate.h"
#import "CCMainViewController.h"
#import "KandyAdpter.h"
#import "LoginViewController.h"

#import "KandySDK/ProvisionModule.h"
#import "Utils/Utils.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[KandyAdpter shareInstance] initKandySDK];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    CCMainViewController *mvc = [[CCMainViewController alloc] initWithNibName:@"CCMainViewController" bundle:nil];
    self.rootNv = [[UINavigationController alloc] initWithRootViewController:mvc];
    self.window.rootViewController = self.rootNv;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *userid = [KandyAdpter getValFormKey:Us_Kandy_userId];
        NSString *password = [KandyAdpter getValFormKey:Us_Kandy_password];
        if (userid && password && [userid length] > 0 && password.length > 0 ) {
            [Utils showHUDOnWindowWithText:@"正在登录.."];
            [[ProvisionModule shareInstance]directLogin:userid password:password callback:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils hideHUDForWindow];
                    if (error) {
                        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                        [self.rootNv  pushViewController:login animated:NO];
                        [self.rootNv setNavigationBarHidden:YES];
                    }
                });
            }];
        }else{
            LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self.rootNv  pushViewController:login animated:NO];
            [self.rootNv setNavigationBarHidden:YES];
        }
    });
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
