
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol GLocationDelegate<NSObject>
-(void) getLocation:(CLLocation*)newloc oldLoc:(CLLocation*)oldloc;
@end

@protocol GLocationFinderDelegate<NSObject>

@required
-(void) isUpdatingLocation:(CLLocation*)newloc oldLoc:(CLLocation*)oldloc;
-(void) updateLocationError:(NSError*)err;
@optional
-(void) willUpdateLocation;
-(void) didUpdateLocation;

@end

@interface GLocationFinder : NSObject<CLLocationManagerDelegate>
{
	CLLocationManager			*	theLocationManager;													
	CLLocation					*	currentPosition;
	CLLocation					*	lastPosition;
	id<GLocationFinderDelegate>	delegate;
	BOOL							gpsOn;
	BOOL							isGPSError;
}

@property (nonatomic, retain) CLLocationManager					*	theLocationManager;
@property (nonatomic, retain) CLLocation						*	currentPosition;
@property (nonatomic, retain) CLLocation						*	lastPosition;
@property (nonatomic, assign) id<GLocationFinderDelegate>			delegate;

+ (GLocationFinder*) sharedGLocationFinder;

-(void) startLocationManager:(id)callback;
-(void)  stopLocationManager;
-(BOOL) finderIsWorking;

@end
