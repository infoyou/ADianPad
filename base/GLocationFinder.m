
#import "GLocationFinder.h"
#import "GUtil.h"

static GLocationFinder* _sharedGLocationFinder = nil;

@implementation GLocationFinder

@synthesize theLocationManager;
@synthesize currentPosition, lastPosition;
@synthesize delegate;

+(GLocationFinder*) sharedGLocationFinder
{
	if(_sharedGLocationFinder == nil)
    {
		_sharedGLocationFinder = [[GLocationFinder alloc] init];
	}
	return _sharedGLocationFinder;
}

-(id) init
{
    if((self=[super init]))
    {
    }
    return self;
}

#pragma mark Location Manager Delegate Methods
-(void) startLocationManager:(id)callback
{
	self.delegate = callback;
    self.theLocationManager = [[[CLLocationManager alloc] init] autorelease]; //  strange here! need retain+1, if not, can block in itouch device
    theLocationManager.delegate = self;
    theLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
	[theLocationManager performSelectorInBackground:@selector(startUpdatingLocation) withObject:nil];
    if([CLLocationManager locationServicesEnabled]==FALSE) // add for check location close (can't check setting: vlingdi close)
    {
        [self locationManager:nil didFailWithError:nil];
        return;
    }
    
	if([delegate respondsToSelector:@selector(willUpdateLocation)])
		[delegate willUpdateLocation];
    
	gpsOn = YES;
}	

-(void) stopLocationManager 
{
	delegate = nil;
	[theLocationManager stopUpdatingLocation];
	theLocationManager.delegate = nil;
	[theLocationManager release];
	theLocationManager = nil;
    
	if([delegate respondsToSelector:@selector(didUpdateLocation)])
		[delegate didUpdateLocation];

    gpsOn = NO;
}

-(BOOL) finderIsWorking
{
	return gpsOn;
}

-(CLLocation*) getCurrentLocation
{
	return currentPosition;
}

-(void) locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
	self.currentPosition = newLocation;
	if([[newLocation timestamp] timeIntervalSinceNow] < -15.0f)
    {
		self.lastPosition = newLocation;
		return;
	}
    
    float olat=newLocation.coordinate.latitude - oldLocation.coordinate.latitude;
    float olon=newLocation.coordinate.longitude - oldLocation.coordinate.longitude;
	if(olat > 0.000001 || olon > 0.000001 || olat < -0.000001 || olon < -0.000001)
	{
		if([delegate respondsToSelector:@selector(isUpdatingLocation:oldLoc:)])
			[delegate isUpdatingLocation:newLocation oldLoc:oldLocation];
	}
    else
    {
		if(self.lastPosition != nil)
        {
			self.lastPosition = nil;
			if([delegate respondsToSelector:@selector(isUpdatingLocation:oldLoc:)])
				[delegate isUpdatingLocation:newLocation oldLoc:oldLocation];
		}
	}
	isGPSError = NO;
}

-(void) locationManager:(CLLocationManager*)manager didFailWithError:(NSError*) error
{
	if(isGPSError == NO)
    {
		isGPSError = YES;
	}
    
	if([delegate respondsToSelector:@selector(updateLocationError:)])
		[delegate updateLocationError:error];
}

-(void) dealloc
{
	self.theLocationManager = nil;
	self.currentPosition = nil;
	self.lastPosition = nil;
	delegate = nil;
    
	[super dealloc];
}

@end
