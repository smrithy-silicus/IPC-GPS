//
//  LocationTracker.m
//  IPC-GPS
//
//  Created by smrithy r varma on 28/07/17.
//  Copyright © 2017 Silicus Technologies. All rights reserved.
//

#import "LocationTracker.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <UIKit/UIKit.h>
#import "EventTrackerLog.h"

@interface LocationTracker() <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationTracker

// Overridden init
-(instancetype) init
{
    self = [super init];
    if(self) {
        self.locationManager = [[CLLocationManager alloc] init];
        
        // Setup location tracker accuracy
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        
        
        // Distance filter
        self.locationManager.distanceFilter = 0.1f;
        
        // Assign location tracker delegate
        self.locationManager.delegate = self;
        
        [self.locationManager startMonitoringSignificantLocationChanges];
        
        // This setup pauses location manager if location wasn't changed
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        
        // For iOS9 we have to call this method if we want to receive location updates in background mode
        if([self.locationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]){
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        
    }
    return self;
}


#pragma mark - Public Methods.

- (void)startTracking
{
    
    // Get current authorization status and check it
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        NSLog(@"Authorization restricted/denied.");
        
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        // Request authorization to receive user's location
        [self.locationManager requestAlwaysAuthorization];
        
    }
    
    else if (status == kCLAuthorizationStatusAuthorizedAlways) {
        // Start updating location
        [_locationManager startUpdatingLocation];
    }
    
    
}

// Stop Tracking.
-(void) stopTracking
{
    [self.locationManager stopUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate


#pragma mark - Location Manager Delegate methods -

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // For real cases we should filter location array by accuracy
    // And check timestamp if you need real time tracking
    // By we don't do it here
    CLLocation *location = [locations lastObject];
    if (location == nil)
        return;
    
    _speedForDevice = location.speed;
    DDLogDebug(@"location details %@",location);
    DDLogDebug(@"speed value %.f",_speedForDevice);
    
    [self.delegate retrievSpeedValue:_speedForDevice];
    
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);
}


-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
    else if (status == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"Always authorized.");
        [_locationManager startUpdatingLocation];
    }
    
}
@end
