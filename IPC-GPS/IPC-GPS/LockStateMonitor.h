//
//  LockStateMonitor.h
//  IPC-GPS
//
//  Created by smrithy r varma on 28/07/17.
//  Copyright © 2017 Silicus Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LockStateMonitor : NSObject

// Disabling alloc init.
-(instancetype) __unavailable init;

/*!
 * @brief Returns the shared instance of the Lock State Monitor.
 * @return  LockStateMonitor*           Returns a shared instance of the LockStateMonitor.
 */
+(LockStateMonitor*) sharedInstance;

/*!
 * @brief Starts the monitoring operation.
 */
-(void) start;

/*!
 * @brief Starts the monitoring operation.
 */
-(void) stop;


@end
