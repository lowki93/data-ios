//
//  AppDelegate.m
//  Data
//
//  Created by kevin Budain on 03/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"

@interface AppDelegate ()

@end

BaseViewController *baseView;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    baseView = [[BaseViewController alloc] init];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    // Override point for customization after application launch.
    if([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"] != nil) {

        NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"];
        [[ApiController sharedInstance] setUserLoad:dictionary];

        NSString *nextController;
        if ([ApiController sharedInstance].user.isActive == false ) {
            nextController = @"PairingViewController";
        } else {
            nextController = @"DataViewController";
        }
//        nextController = @"TutorialViewController";
        [baseView showModal:nextController RemoveWindow:false];

    }

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [application registerUserNotificationSettings:notificationSettings];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
//                                                                             settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound
//                                                                       categories:nil]];
    }

    //This code will work in iOS 8.0 xcode 6.0 or later
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//    else
//    {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    }

    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey];
    
    if (localNotification){
        [application cancelAllLocalNotifications];
    }
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
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:[deviceToken description] forKey:@"deviceToken"];
    NSLog(@"Device_Token -----> %@\n",[deviceToken description]);
}

- (void)           application:(UIApplication *)application
  didReceiveRemoteNotification:(NSDictionary *)userInfo
        fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    self.dataViewController = [[DataViewController alloc] init];
    [self.dataViewController uploadFile];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end