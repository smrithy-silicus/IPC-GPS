//
//  LocationTracker.h
//  IPC-GPS
//
//  Created by smrithy r varma on 28/07/17.
//  Copyright © 2017 Silicus Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LocationTracker;
@protocol LocationTrackerDelegate <NSObject>

@required
-(void)retrievSpeedValue:(double)speed;
@end

@interface LocationTracker : NSObject

@property (nonatomic, weak) id <LocationTrackerDelegate> delegate;
@property(nonatomic) double speedForDevice;
-(void) startTracking;
-(void) stopTracking;


@end
