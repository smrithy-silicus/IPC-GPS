//
//  LockStateMonitor.m
//  IPC-GPS
//
//  Created by smrithy r varma on 28/07/17.
//  Copyright © 2017 Silicus Technologies. All rights reserved.
//

#import "LockStateMonitor.h"
#import <notify.h>
#import <notify_keys.h>
#import "EventTrackerLog.h"

@interface LockStateMonitor() {
    int notifyToken;
}


// Indicates if lock state monitor is active.
@property (assign,nonatomic) BOOL monitorActive;

@end


@implementation LockStateMonitor

static LockStateMonitor* sharedInstance = nil;

// Returns the shared instance.
+(LockStateMonitor*) sharedInstance
{
    @synchronized(self){
        if(sharedInstance == nil){
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}


// Initializer:
-(instancetype) init
{
    self = [super init];
    if(self){
        // Do required initialization.
        self.monitorActive = NO;
    }
    return self;
}



// Start the monitoring operation to observe the change in the Lock state.
-(void) start
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        uint32_t result =  notify_register_dispatch("com.apple.springboard.lockstate",
                                                    &notifyToken,
                                                    dispatch_get_main_queue(),
                                                    ^(int token){
                                                        uint64_t state = UINT64_MAX;
                                                        notify_get_state(token, &state);
                                                        if(state == 0) {
                                                            DDLogDebug(@"Phone Unlocked.");
                                                            //  NSLog(@"Phone Unlocked");
                                                        }
                                                        else {
                                                            DDLogDebug(@"Phone Locked");
                                                            // NSLog(@"Phone locked");
                                                        }
                                                    });
        
        // Set the monitor status.
        if (result == NOTIFY_STATUS_OK) {
            self.monitorActive = YES;
        }
    });
}


// Stop the monitoring operation.
-(void) stop
{
    // Unregister from notification.
    if(self.monitorActive) {
        uint32_t result = notify_cancel(notifyToken);
        if(result == NOTIFY_STATUS_OK) {
            self.monitorActive = NO;
        }
    }
}



@end
