//
//  AppDelegate.h
//  IPC-GPS
//
//  Created by smrithy r varma on 28/07/17.
//  Copyright © 2017 Silicus Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CallKit/CXCallObserver.h>
#import <CallKit/CXCall.h>
#import "EventTrackerLog.h"
@import UserNotifications;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CXCallObserverDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) DDFileLogger *fileLogger;

-(void)callNotification;

@end

