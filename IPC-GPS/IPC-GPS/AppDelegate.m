//
//  AppDelegate.m
//  IPC-GPS
//
//  Created by smrithy r varma on 28/07/17.
//  Copyright © 2017 Silicus Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationTracker.h"
#import "LockStateMonitor.h"

@interface AppDelegate ()
@property(strong,nonatomic) CXCallObserver *callObserver;
@property(strong,nonatomic)LocationTracker *tracker;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Start file logger.
    [self initializeFileLogger];
    
    self.tracker = [[LocationTracker alloc]init];
    [self.tracker startTracking];
    
    LockStateMonitor *monitor = [LockStateMonitor sharedInstance];
    [monitor start];
    
    CXCallObserver *callObserver = [[CXCallObserver alloc]init];
    [callObserver setDelegate:self queue:nil];
    self.callObserver = callObserver;
    
    //for local notification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:( UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(!error){
            NSLog(@"request authorization for local notification");
            
        }
    }];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    
}

#pragma mark CXCallObserver class delegate method
- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call{
    
    if (call == nil || call.hasEnded == YES) {
        DDLogDebug(@"call disconnected");
    }
    
    if (call.isOutgoing == YES && call.hasConnected == NO) {
        DDLogDebug(@"call Dialing");
    }
    
    if (call.isOutgoing == NO  && call.hasConnected == NO && call.hasEnded == NO && call != nil) {
        DDLogDebug(@"call Incoming");
        dispatch_async(dispatch_get_main_queue(), ^{
            //Your main thread code goes in here
            [self callNotification];
        });
        
    }
    
    if (call.hasConnected == YES ) {
        DDLogDebug(@"call connected");
        
    }
    
}

#pragma mark - Private Methods.

-(void) initializeFileLogger
{
    // File logger.
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    DDLogFileManagerDefault* logFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:documentsDirectory];
    self.fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    [DDLog addLogger:self.fileLogger];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    
}

-(void)callNotification
{
    UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
    objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"Notification!" arguments:nil];
    
    objNotificationContent.body = [NSString localizedUserNotificationStringForKey:@"Received a call!"
                                                                        arguments:nil];
    objNotificationContent.sound = [UNNotificationSound defaultSound];
    
    
    // Deliver the notification in five seconds.
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:10.f repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"ten" content:objNotificationContent trigger:trigger];
    
    /// 3. schedule localNotification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Local Notification succeeded");
        }
        else {
            NSLog(@"Local Notification failed");
        }
    }];
    
    
    
}


@end
