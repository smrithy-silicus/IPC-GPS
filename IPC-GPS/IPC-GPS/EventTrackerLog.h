//
//  EventTrackerLog.h
//  TestLock
//
//  Created by Shashi Shaw on 06/07/17.
//  Copyright © 2017 Silicus Technologies India Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack.h>

/**
 * Facilitates file logging across the application using CocoaLumberJack.
 * Creates a file with filename like "com.sawinpro.sawin 2017-06-07 07-28.log"
 * inside the /documents directory of the application sandbox.
 *
 * Usage:
 * 1. Import the EventTrackerLog.h file in the source file.
 * 2. Add logs as DDLogDebug(@"%s",__PRETTY_FUNCTION__);
 *
 */


// The logging level to be set required by the library.
extern int ddLogLevel;
