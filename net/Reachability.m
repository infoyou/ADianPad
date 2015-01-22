/*
 
 File: Reachability.m
 Abstract: Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 
 Version: 2.0.4ddg
 */

/*
 Significant additions made by Andrew W. Donoho, August 11, 2009.
 This is a derived work of Apple's Reachability v2.0 class.
 
 The below license is the new BSD license with the OSI recommended personalizations.
 <http://www.opensource.org/licenses/bsd-license.php>

 Extensions Copyright (C) 2009 Donoho Design Group, LLC. All Rights Reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Andrew W. Donoho nor Donoho Design Group, L.L.C.
 may be used to endorse or promote products derived from this software
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY DONOHO DESIGN GROUP, L.L.C. "AS IS" AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */


/*
 
 Apple's Original License on Reachability v2.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.

 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
*/

/*
 Each reachability object now has a copy of the key used to store it in a dictionary.
 This allows each observer to quickly determine if the event is important to them.
*/

#ifdef GYPSII



#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <netdb.h>

#import "Reachability.h"
#import <SystemConfiguration/SCNetworkReachability.h>

static NSString *kLinkLocalAddressKey = @"169.254.0.0";
static NSString *kDefaultRouteKey = @"0.0.0.0";

static Reachability *_sharedReachability;

// A class extension that declares internal methods for this class.
@interface Reachability()
- (BOOL)isAdHocWiFiNetworkAvailableFlags:(SCNetworkReachabilityFlags*)outFlags;
- (BOOL)isNetworkAvailableFlags:(SCNetworkReachabilityFlags*)outFlags;
- (BOOL)isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags)flags;
- (SCNetworkReachabilityRef)reachabilityRefForHostName:(NSString*)hostName;
- (SCNetworkReachabilityRef)reachabilityRefForAddress:(NSString*)address;
- (BOOL)addressFromString:(NSString*)IPAddress address:(struct sockaddr_in*)outAddress;
-(void) stopListeningForReachabilityChanges;
@end

@implementation Reachability

@synthesize networkStatusNotificationsEnabled = _networkStatusNotificationsEnabled;
@synthesize hostName = _hostName;
@synthesize address = _address;
@synthesize reachabilityQueries = _reachabilityQueries;

+ (Reachability*)sharedReachability
{
	if(!_sharedReachability) {
		_sharedReachability = [[Reachability alloc] init];
		// Clients of Reachability will typically call [[Reachability sharedReachability] setHostName:]
		// before calling one of the status methods.
        _sharedReachability.hostName = nil;
		_sharedReachability.address = nil;
		_sharedReachability.networkStatusNotificationsEnabled = NO;
		_sharedReachability.reachabilityQueries = [[NSMutableDictionary alloc] init];
	}
	return _sharedReachability;
}

-(void)  dealloc
{	
    [self stopListeningForReachabilityChanges];
	[_hostName release];
	[_address release];
	
	[_sharedReachability.reachabilityQueries release];
	[_sharedReachability release];
	[super dealloc];
}

- (BOOL)isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags)flags
{
    // kSCNetworkReachabilityFlagsReachable indicates that the specified nodename or address can
	// be reached using the current network configuration.
	BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;
	
	// This flag indicates that the specified nodename or address can
	// be reached using the current network configuration, but a
	// connection must first be established.
	//
	// If the flag is false, we don't have a connection. But because CFNetwork
    // automatically attempts to bring up a WWAN connection, if the WWAN reachability
    // flag is present, a connection is not required.
	BOOL noConnectionRequired = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
	if((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
		noConnectionRequired = YES;
	}
	
	return (isReachable && noConnectionRequired) ? YES : NO;
}

// Returns whether or not the current host name is reachable with the current network configuration.
- (BOOL)isHostReachable:(NSString*)host
{
    if(!host || ![host length]) {
        return NO;
    }
    
    SCNetworkReachabilityFlags		flags;
    SCNetworkReachabilityRef reachability =  SCNetworkReachabilityCreateWithName(NULL, [host UTF8String]);
	BOOL gotFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    
	CFRelease(reachability);
    
    if(!gotFlags) {
        return NO;
    }
    
	return [self isReachableWithoutRequiringConnection:flags];
}

// This returns YES if the address 169.254.0.0 is reachable without requiring a connection.
- (BOOL)isAdHocWiFiNetworkAvailableFlags:(SCNetworkReachabilityFlags*)outFlags
{		
    // Look in the cache of reachability queries for one that matches this query.
	ReachabilityQuery *query = [self.reachabilityQueries objectForKey:kLinkLocalAddressKey];
	SCNetworkReachabilityRef adHocWiFiNetworkReachability = query.reachabilityRef;
	
    // If a cached reachability query was not found, create one.
    if(!adHocWiFiNetworkReachability) {
        
        // Build a sockaddr_in that we can pass to the address reachability query.
        struct sockaddr_in sin;
        
        bzero(&sin, sizeof(sin));
        sin.sin_len = sizeof(sin);
        sin.sin_family = AF_INET;
        // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
        sin.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
        
        adHocWiFiNetworkReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&sin);
		
		query = [[[ReachabilityQuery alloc] init] autorelease];
		query.hostNameOrAddress = kLinkLocalAddressKey;
		query.reachabilityRef = adHocWiFiNetworkReachability;
		
        // Add the reachability query to the cache.
		[self.reachabilityQueries setObject:query forKey:kLinkLocalAddressKey];
    }
	
	// If necessary, register for notifcations for the SCNetworkReachabilityRef on the current run loop.
	// If an existing SCNetworkReachabilityRef was found in the cache, we can reuse it and register
	// to receive notifications from it in the current run loop, which may be different than the run loop
	// that was previously used when registering the SCNetworkReachabilityRef for notifications.
    // -scheduleOnRunLoop: will schedule only if network status notifications are enabled in the Reachability instance.
    // By default, they are not enabled. 
	[query scheduleOnRunLoop:[NSRunLoop currentRunLoop]];
    
    SCNetworkReachabilityFlags addressReachabilityFlags;
    BOOL gotFlags = SCNetworkReachabilityGetFlags(adHocWiFiNetworkReachability, &addressReachabilityFlags);
    if(!gotFlags) {
        // There was an error getting the reachability flags.
        return NO;
    }
    
    // Callers of this method might want to use the reachability flags, so if an 'out' parameter
    // was passed in, assign the reachability flags to it.
    if(outFlags) {
        *outFlags = addressReachabilityFlags;
    }
    
    return [self isReachableWithoutRequiringConnection:addressReachabilityFlags];
}

// ReachabilityCallback is registered as the callback for network state changes in startListeningForReachabilityChanges.
static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Post a notification to notify the client that the network reachability changed.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetworkReachabilityChangedNotification" object:nil];
	
	[pool release];
}

// Perform a reachability query for the address 0.0.0.0. If that address is reachable without
// requiring a connection, a network interface is available. We'll have to do more work to
// determine which network interface is available.
- (BOOL)isNetworkAvailableFlags:(SCNetworkReachabilityFlags*)outFlags
{
	ReachabilityQuery *query = [self.reachabilityQueries objectForKey:kDefaultRouteKey];
	SCNetworkReachabilityRef defaultRouteReachability = query.reachabilityRef;
	
    // If a cached reachability query was not found, create one.
    if(!defaultRouteReachability) {
        
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        
        defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
		
		ReachabilityQuery *query = [[[ReachabilityQuery alloc] init] autorelease];
		query.hostNameOrAddress = kDefaultRouteKey;
		query.reachabilityRef = defaultRouteReachability;
		
		[self.reachabilityQueries setObject:query forKey:kDefaultRouteKey];
    }
	
	// If necessary, register for notifcations for the SCNetworkReachabilityRef on the current run loop.
	// If an existing SCNetworkReachabilityRef was found in the cache, we can reuse it and register
	// to receive notifications from it in the current run loop, which may be different than the run loop
	// that was previously used when registering the SCNetworkReachabilityRef for notifications. 
    // -scheduleOnRunLoop: will schedule only if network status notifications are enabled in the Reachability instance.
    // By default, they are not enabled. 
	[query scheduleOnRunLoop:[NSRunLoop currentRunLoop]];
	
	SCNetworkReachabilityFlags flags;
	BOOL gotFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	if(!gotFlags) {
        return NO;
    }
    
	BOOL isReachable = [self isReachableWithoutRequiringConnection:flags];
	
	// Callers of this method might want to use the reachability flags, so if an 'out' parameter
	// was passed in, assign the reachability flags to it.
	if(outFlags) {
		*outFlags = flags;
	}
	
	return isReachable;
}

// Be a good citizen and unregister for network state changes when the application terminates.
-(void) stopListeningForReachabilityChanges
{
	// Walk through the cache that holds SCNetworkReachabilityRefs for reachability
	// queries to particular hosts or addresses.
	NSEnumerator *enumerator = [self.reachabilityQueries objectEnumerator];
	ReachabilityQuery *reachabilityQuery;
    
	while (reachabilityQuery = [enumerator nextObject]) {
		
		CFArrayRef runLoops = reachabilityQuery.runLoops;
		NSUInteger runLoopCounter, maxRunLoops = CFArrayGetCount(runLoops);
        
		for (runLoopCounter = 0; runLoopCounter < maxRunLoops; runLoopCounter++) {
			CFRunLoopRef nextRunLoop = (CFRunLoopRef)CFArrayGetValueAtIndex(runLoops, runLoopCounter);
			
			SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityQuery.reachabilityRef, nextRunLoop, kCFRunLoopDefaultMode);
		}
        
        CFArrayRemoveAllValues(reachabilityQuery.runLoops);
	}
}

/*
 Create a SCNetworkReachabilityRef for hostName, which lets us determine if hostName
 is currently reachable, and lets us register to receive notifications when the 
 reachability of hostName changes.
 */
- (SCNetworkReachabilityRef)reachabilityRefForHostName:(NSString*)hostName
{
	if(!hostName || ![hostName length]) {
		return NULL;
	}
	
	// Look in the cache for an existing SCNetworkReachabilityRef for hostName.
	ReachabilityQuery *cachedQuery = [self.reachabilityQueries objectForKey:hostName];
	SCNetworkReachabilityRef reachabilityRefForHostName = cachedQuery.reachabilityRef;
	
	if(reachabilityRefForHostName) {
		return reachabilityRefForHostName;
	}
	
	// Didn't find an existing SCNetworkReachabilityRef for hostName, so create one ...
	reachabilityRefForHostName = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [hostName UTF8String]);
    
    NSAssert1(reachabilityRefForHostName != NULL, @"Failed to create SCNetworkReachabilityRef for host: %@", hostName);
    
	ReachabilityQuery *query = [[[ReachabilityQuery alloc] init] autorelease];
	query.hostNameOrAddress = hostName;
	query.reachabilityRef = reachabilityRefForHostName;
	
    // If necessary, register for notifcations for the SCNetworkReachabilityRef on the current run loop.
    // If an existing SCNetworkReachabilityRef was found in the cache, we can reuse it and register
    // to receive notifications from it in the current run loop, which may be different than the run loop
    // that was previously used when registering the SCNetworkReachabilityRef for notifications.
    // -scheduleOnRunLoop: will schedule only if network status notifications are enabled in the Reachability instance.
    // By default, they are not enabled. 
    [query scheduleOnRunLoop:[NSRunLoop currentRunLoop]];
    
    // ... and add it to the cache.
    [self.reachabilityQueries setObject:query forKey:hostName];
    return reachabilityRefForHostName;
}

/*
 Create a SCNetworkReachabilityRef for the IP address in addressString, which lets us determine if 
 the address is currently reachable, and lets us register to receive notifications when the 
 reachability of the address changes.
 */
- (SCNetworkReachabilityRef)reachabilityRefForAddress:(NSString*)addressString
{
	if(!addressString || ![addressString length]) {
		return NULL;
	}
	
	struct sockaddr_in address;
	
	BOOL gotAddress = [self addressFromString:addressString address:&address];
	if(!gotAddress) {
        // The attempt to convert addressString to a sockaddr_in failed.
        NSAssert1(gotAddress != NO, @"Failed to convert an IP address string to a sockaddr_in: %@", addressString);
		return NULL;
	}
	
	// Look in the cache for an existing SCNetworkReachabilityRef for addressString.
	ReachabilityQuery *cachedQuery = [self.reachabilityQueries objectForKey:addressString];
	SCNetworkReachabilityRef reachabilityRefForAddress = cachedQuery.reachabilityRef;
	
	if(reachabilityRefForAddress) {
		return reachabilityRefForAddress;
	}
	
	// Didn't find an existing SCNetworkReachabilityRef for addressString, so create one.
	reachabilityRefForAddress = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr*)&address);
    
    NSAssert1(reachabilityRefForAddress != NULL, @"Failed to create SCNetworkReachabilityRef for address: %@", addressString);
    
	ReachabilityQuery *query = [[[ReachabilityQuery alloc] init] autorelease];
	query.hostNameOrAddress = addressString;
	query.reachabilityRef = reachabilityRefForAddress;
    
    // If necessary, register for notifcations for the SCNetworkReachabilityRef on the current run loop.
    // If an existing SCNetworkReachabilityRef was found in the cache, we can reuse it and register
    // to receive notifications from it in the current run loop, which may be different than the run loop
    // that was previously used when registering the SCNetworkReachabilityRef for notifications.
    // -scheduleOnRunLoop: will schedule only if network status notifications are enabled in the Reachability instance.
    // By default, they are not enabled. 
    [query scheduleOnRunLoop:[NSRunLoop currentRunLoop]];
    
    // ... and add it to the cache.
    [self.reachabilityQueries setObject:query forKey:addressString];
    return reachabilityRefForAddress;
}

- (NetworkStatus)remoteHostStatus
{
	/*
     If the current host name or address is reachable, determine which network interface it is reachable through.
     If the host is reachable and the reachability flags include kSCNetworkReachabilityFlagsIsWWAN, it
     is reachable through the carrier data network. If the host is reachable and the reachability
     flags do not include kSCNetworkReachabilityFlagsIsWWAN, it is reachable through the WiFi network.
     */
    
	SCNetworkReachabilityRef reachabilityRef = nil;
	if(self.hostName) {
		reachabilityRef = [self reachabilityRefForHostName:self.hostName];
		
	} else if(self.address) {
		reachabilityRef = [self reachabilityRefForAddress:self.address];
		
	} else {
		NSAssert(self.hostName != nil && self.address != nil, @"No hostName or address specified. Cannot determine reachability.");
		return NotReachable;
	}
	
	if(!reachabilityRef) {
		return NotReachable;
	}
	
	SCNetworkReachabilityFlags reachabilityFlags;
	BOOL gotFlags = SCNetworkReachabilityGetFlags(reachabilityRef, &reachabilityFlags);
    if(!gotFlags) {
        return NotReachable;
    }
    
	BOOL reachable = [self isReachableWithoutRequiringConnection:reachabilityFlags];
	
	if(!reachable) {
		return NotReachable;
	}
	if(reachabilityFlags & ReachableViaCarrierDataNetwork) {
		return ReachableViaCarrierDataNetwork;
	}
	
	return ReachableViaWiFiNetwork;
}

- (NetworkStatus)internetConnectionStatus
{
	/*
     To determine if the device has an Internet connection, query the address
     0.0.0.0. If it's reachable without requiring a connection, first check
     for the kSCNetworkReachabilityFlagsIsDirect flag, which tell us if the connection
     is to an ad-hoc WiFi network. If it is not, the device can access the Internet.
     The next thing to determine is how the device can access the Internet, which
     can either be through the carrier data network (EDGE or other service) or through
     a WiFi connection.
     
     Note: Knowing that the device has an Internet connection is not the same as
     knowing if the device can reach a particular host. To know that, use
     -[Reachability remoteHostStatus].
     */
	
	SCNetworkReachabilityFlags defaultRouteFlags;
	BOOL defaultRouteIsAvailable = [self isNetworkAvailableFlags:&defaultRouteFlags];
	if(defaultRouteIsAvailable) {
        
		if(defaultRouteFlags & kSCNetworkReachabilityFlagsIsDirect) {
            
			// The connection is to an ad-hoc WiFi network, so Internet access is not available.
			return NotReachable;
		}
		else if(defaultRouteFlags & ReachableViaCarrierDataNetwork) {
			return ReachableViaCarrierDataNetwork;
		}
		
		return ReachableViaWiFiNetwork;
	}
	
	return NotReachable;
}

- (NetworkStatus)localWiFiConnectionStatus
{
	SCNetworkReachabilityFlags selfAssignedAddressFlags;
	
	/*
     To determine if the WiFi connection is to a local ad-hoc network,
     check the availability of the address 169.254.x.x. That's an address
     in the self-assigned range, and the device will have a self-assigned IP
     when it's connected to a ad-hoc WiFi network. So to test if the device
     has a self-assigned IP, look for the kSCNetworkReachabilityFlagsIsDirect flag
     in the address query. If it's present, we know that the WiFi connection
     is to an ad-hoc network.
     */
	// This returns YES if the address 169.254.0.0 is reachable without requiring a connection.
	BOOL hasLinkLocalNetworkAccess = [self isAdHocWiFiNetworkAvailableFlags:&selfAssignedAddressFlags];
    
	if(hasLinkLocalNetworkAccess && (selfAssignedAddressFlags & kSCNetworkReachabilityFlagsIsDirect)) {
		return ReachableViaWiFiNetwork;
	}
	
	return NotReachable;
}

// Convert an IP address from an NSString to a sockaddr_in * that can be used to create
// the reachability request.
- (BOOL)addressFromString:(NSString*)IPAddress address:(struct sockaddr_in*)address
{
	if(!IPAddress || ![IPAddress length]) {
		return NO;
	}
	
	memset((char*) address, sizeof(struct sockaddr_in), 0);
	address->sin_family = AF_INET;
	address->sin_len = sizeof(struct sockaddr_in);
	
	int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
	if(conversionResult == 0) {
		NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
		return NO;
	}
	
	return YES;
}

@end

@interface ReachabilityQuery ()
- (CFRunLoopRef)startListeningForReachabilityChanges:(SCNetworkReachabilityRef)reachability onRunLoop:(CFRunLoopRef)runLoop;
@end

@implementation ReachabilityQuery

@synthesize reachabilityRef = _reachabilityRef;
@synthesize runLoops = _runLoops;
@synthesize hostNameOrAddress = _hostNameOrAddress;

- (id)init
{
	self = [super init];
	if(self != nil) {
		self.runLoops = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
	}
	return self;
}

-(void) dealloc
{
	CFRelease(self.runLoops);
	[_hostNameOrAddress release];
	[super dealloc];
}

- (BOOL)isScheduledOnRunLoop:(CFRunLoopRef)runLoop
{
	NSUInteger runLoopCounter, maxRunLoops = CFArrayGetCount(self.runLoops);
	
	for (runLoopCounter = 0; runLoopCounter < maxRunLoops; runLoopCounter++) {
		CFRunLoopRef nextRunLoop = (CFRunLoopRef)CFArrayGetValueAtIndex(self.runLoops, runLoopCounter);
		
		if(nextRunLoop == runLoop) {
			return YES;
		}
	}
	
	return NO;
}

-(void) scheduleOnRunLoop:(NSRunLoop*)inRunLoop
{
	// Only register for network state changes if the client has specifically enabled them.
	if([[Reachability sharedReachability] networkStatusNotificationsEnabled] == NO) {
		return;
	}
	
	if(!inRunLoop) {
		return;
	}
	
	CFRunLoopRef runLoop = [inRunLoop getCFRunLoop];
	
	// Notifications of status changes for each reachability query can be scheduled on multiple run loops.
	// To support that, register for notifications for each runLoop.
	// -isScheduledOnRunLoop: iterates over all of the run loops that have previously been used
	// to register for notifications. If one is found that matches the passed in runLoop argument, there's
	// no need to register for notifications again. If one is not found, register for notifications
	// using the current runLoop.
	if(![self isScheduledOnRunLoop:runLoop]) {
        
		CFRunLoopRef notificationRunLoop = [self startListeningForReachabilityChanges:self.reachabilityRef onRunLoop:runLoop];
		if(notificationRunLoop) {
			CFArrayAppendValue(self.runLoops, notificationRunLoop);
		}
	}
}

// Register to receive changes to the 'reachability' query so that we can update the
// user interface when the network state changes.
- (CFRunLoopRef)startListeningForReachabilityChanges:(SCNetworkReachabilityRef)reachability onRunLoop:(CFRunLoopRef)runLoop
{	
	if(!reachability) {
		return NULL;
	}
	
	if(!runLoop) {
		return NULL;
	}
    
	SCNetworkReachabilityContext	context = {0, self, NULL, NULL, NULL};
	SCNetworkReachabilitySetCallback(reachability, ReachabilityCallback, &context);
	SCNetworkReachabilityScheduleWithRunLoop(reachability, runLoop, kCFRunLoopDefaultMode);
	
	return runLoop;
}


@end


#else

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>

#import "Reachability.h"

NSString *const kInternetConnection  = @"InternetConnection";
NSString *const kLocalWiFiConnection = @"LocalWiFiConnection";
NSString *const kReachabilityChangedNotification = @"NetworkReachabilityChangedNotification";

#define CLASS_DEBUG 1 // Turn on logReachabilityFlags. Must also have a project wide defined DEBUG.

#if(defined DEBUG && defined CLASS_DEBUG)
#define logReachabilityFlags(flags) (logReachabilityFlags_(__PRETTY_FUNCTION__, __LINE__, flags))

static NSString *reachabilityFlags_(SCNetworkReachabilityFlags flags) {
	
#if(__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) // Apple advises you to use the magic number instead of a symbol.
    return [NSString stringWithFormat:@"Reachability Flags: %c%c %c%c%c%c%c%c%c",
			(flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
			(flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
			
			(flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
			(flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
			(flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
			(flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
			(flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
			(flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
			(flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
#else
	// Compile out the v3.0 features for v2.2.1 deployment.
    return [NSString stringWithFormat:@"Reachability Flags: %c%c %c%c%c%c%c%c",
			(flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
			(flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
			
			(flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
			(flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
			(flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
			// v3 kSCNetworkReachabilityFlagsConnectionOnTraffic == v2 kSCNetworkReachabilityFlagsConnectionAutomatic
			(flags & kSCNetworkReachabilityFlagsConnectionAutomatic)  ? 'C' : '-',
			// (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-', // No v2 equivalent.
			(flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
			(flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
#endif
	
} // reachabilityFlags_()

static void logReachabilityFlags_(const char *name, int line, SCNetworkReachabilityFlags flags) {
	
    NSLog(@"%s (%d) \n\t%@", name, line, reachabilityFlags_(flags));
	
} // logReachabilityFlags_()

#define logNetworkStatus(status) (logNetworkStatus_(__PRETTY_FUNCTION__, __LINE__, status))

static void logNetworkStatus_(const char *name, int line, NetworkStatus status) {
	
	NSString *statusString = nil;
	
	switch (status) {
		case kNotReachable:
			statusString = @"Not Reachable";
			break;
		case kReachableViaWWAN:
			statusString = @"Reachable via WWAN";
			break;
		case kReachableViaWiFi:
			statusString = @"Reachable via WiFi";
			break;
	}
	
	NSLog(@"%s (%d) \n\tNetwork Status: %@", name, line, statusString);
	
} // logNetworkStatus_()

#else
#define logReachabilityFlags(flags)
#define logNetworkStatus(status)
#endif

@interface Reachability (private)

- (NetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags;

@end

@implementation Reachability

@synthesize key = key_;

// Preclude direct access to ivars.
+ (BOOL) accessInstanceVariablesDirectly {
	
	return NO;
	
} // accessInstanceVariablesDirectly


-(void)  dealloc {
	
	[self stopNotifier];
	if(reachabilityRef) {
		
		CFRelease(reachabilityRef); reachabilityRef = NULL;
		
	}
	
	self.key = nil;
	
	[super dealloc];
	
} // dealloc


- (Reachability*) initWithReachabilityRef: (SCNetworkReachabilityRef) ref {
	
	if(self = [super init]) {
		
		reachabilityRef = ref;
		
	}
	
	return self;
	
} // initWithReachabilityRef:


#if(defined DEBUG && defined CLASS_DEBUG)
- (NSString*) description {
	
	NSAssert(reachabilityRef, @"-description called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	
	SCNetworkReachabilityGetFlags(reachabilityRef, &flags);
	
	return [NSString stringWithFormat: @"%@\n\t%@", self.key, reachabilityFlags_(flags)];
	
} // description
#endif


#pragma mark -
#pragma mark Notification Management Methods


//Start listening for reachability notifications on the current run loop
static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
	
#pragma unused (target, flags)
	NSCAssert(info, @"info was NULL in ReachabilityCallback");
	NSCAssert([(NSObject*) info isKindOfClass: [Reachability class]], @"info was the wrong class in ReachabilityCallback");
	
	//We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
	// in case someone uses the Reachablity object in a different thread.
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	
	// Post a notification to notify the client that the network reachability changed.
	[[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification 
														object: (Reachability*) info];
	
	[pool release];
	
} // ReachabilityCallback()


- (BOOL) startNotifier {
	
	SCNetworkReachabilityContext	context = {0, self, NULL, NULL, NULL};
	
	if(SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context)) {
		
		if(SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
			
			return YES;
			
		}
		
	}
	
	return NO;
	
} // startNotifier


-(void)  stopNotifier {
	
	if(reachabilityRef) {
		
		SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		
	}
	
} // stopNotifier


- (BOOL) isEqual: (Reachability*) r {
	
	return [r.key isEqualToString: self.key];
	
} // isEqual:


#pragma mark -
#pragma mark Reachability Allocation Methods


+ (Reachability*) reachabilityWithHostName: (NSString*) hostName {
	
	SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	
	if(ref) {
		
		Reachability *r = [[[self alloc] initWithReachabilityRef: ref] autorelease];
		
		r.key = hostName;
		
		return r;
		
	}
	
	return nil;
	
} // reachabilityWithHostName


+ (NSString*) makeAddressKey: (in_addr_t) addr {
	// addr is assumed to be in network byte order.
	
	static const int       highShift    = 24;
	static const int       highMidShift = 16;
	static const int       lowMidShift  =  8;
	static const in_addr_t mask         = 0x000000ff;
	
	addr = ntohl(addr);
	
	return [NSString stringWithFormat: @"%d.%d.%d.%d", 
			(addr >> highShift)    & mask, 
			(addr >> highMidShift) & mask, 
			(addr >> lowMidShift)  & mask, 
			addr                  & mask];
	
} // makeAddressKey:


+ (Reachability*) reachabilityWithAddress: (const struct sockaddr_in*) hostAddress {
	
	SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
	
	if(ref) {
		
		Reachability *r = [[[self alloc] initWithReachabilityRef: ref] autorelease];
		
		r.key = [self makeAddressKey: hostAddress->sin_addr.s_addr];
		
		return r;
		
	}
	
	return nil;
	
} // reachabilityWithAddress


+ (Reachability*) reachabilityForInternetConnection {
	
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	Reachability *r = [self reachabilityWithAddress: &zeroAddress];
	
	r.key = kInternetConnection;
	
	return r;
	
} // reachabilityForInternetConnection


+ (Reachability*) reachabilityForLocalWiFi {
	
	struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
	localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
	
	Reachability *r = [self reachabilityWithAddress: &localWifiAddress];
	
	r.key = kLocalWiFiConnection;
	
	return r;
	
} // reachabilityForLocalWiFi


#pragma mark -
#pragma mark Network Flag Handling Methods


#if USE_DDG_EXTENSIONS
//
// iPhone condition codes as reported by a 3GS running iPhone OS v3.0.
// Airplane Mode turned on:  Reachability Flag Status: -- -------
// WWAN Active:              Reachability Flag Status: WR -t-----
// WWAN Connection required: Reachability Flag Status: WR ct-----
//         WiFi turned on:   Reachability Flag Status: -R ------- Reachable.
// Local   WiFi turned on:   Reachability Flag Status: -R xxxxxxd Reachable.
//         WiFi turned on:   Reachability Flag Status: -R ct----- Connection down. (Non-intuitive, empirically determined answer.)
const SCNetworkReachabilityFlags kConnectionDown =  kSCNetworkReachabilityFlagsConnectionRequired | 
kSCNetworkReachabilityFlagsTransientConnection;
//         WiFi turned on:   Reachability Flag Status: -R ct-i--- Reachable but it will require user intervention (e.g. enter a WiFi password).
//         WiFi turned on:   Reachability Flag Status: -R -t----- Reachable via VPN.
//
// In the below method, an 'x' in the flag status means I don't care about its value.
//
// This method differs from Apple's by testing explicitly for empirically observed values.
// This gives me more confidence in it's correct behavior. Apple's code covers more cases 
// than mine. My code covers the cases that occur.
//
- (NetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags {
	
	if(flags & kSCNetworkReachabilityFlagsReachable) {
		
		// Local WiFi -- Test derived from Apple's code: -localWiFiStatusForFlags:.
		if(self.key == kLocalWiFiConnection) {
			
			// Reachability Flag Status: xR xxxxxxd Reachable.
			return (flags & kSCNetworkReachabilityFlagsIsDirect) ? kReachableViaWiFi : kNotReachable;
			
		}
		
		// Observed WWAN Values:
		// WWAN Active:              Reachability Flag Status: WR -t-----
		// WWAN Connection required: Reachability Flag Status: WR ct-----
		//
		// Test Value: Reachability Flag Status: WR xxxxxxx
		if(flags & kSCNetworkReachabilityFlagsIsWWAN) { return kReachableViaWWAN; }
		
		// Clear moot bits.
		flags &= ~kSCNetworkReachabilityFlagsReachable;
		flags &= ~kSCNetworkReachabilityFlagsIsDirect;
		flags &= ~kSCNetworkReachabilityFlagsIsLocalAddress; // kInternetConnection is local.
		
		// Reachability Flag Status: -R ct---xx Connection down.
		if(flags == kConnectionDown) { return kNotReachable; }
		
		// Reachability Flag Status: -R -t---xx Reachable. WiFi + VPN(is up) (Thank you Ling Wang)
		if(flags & kSCNetworkReachabilityFlagsTransientConnection)  { return kReachableViaWiFi; }
		
		// Reachability Flag Status: -R -----xx Reachable.
		if(flags == 0) { return kReachableViaWiFi; }
		
		// Apple's code tests for dynamic connection types here. I don't. 
		// If a connection is required, regardless of whether it is on demand or not, it is a WiFi connection.
		// If you care whether a connection needs to be brought up,   use -isConnectionRequired.
		// If you care about whether user intervention is necessary,  use -isInterventionRequired.
		// If you care about dynamically establishing the connection, use -isConnectionIsOnDemand.
		
		// Reachability Flag Status: -R cxxxxxx Reachable.
		if(flags & kSCNetworkReachabilityFlagsConnectionRequired) { return kReachableViaWiFi; }
		
		// Required by the compiler. Should never get here. Default to not connected.
#if(defined DEBUG && defined CLASS_DEBUG)
		NSAssert1(NO, @"Uncaught reachability test. Flags: %@", reachabilityFlags_(flags));
#endif
		return kNotReachable;
		
	}
	
	// Reachability Flag Status: x- xxxxxxx
	return kNotReachable;
	
} // networkStatusForFlags:


- (NetworkStatus) currentReachabilityStatus {
	
	NSAssert(reachabilityRef, @"currentReachabilityStatus called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	NetworkStatus status = kNotReachable;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
		
		//		logReachabilityFlags(flags);
		
		status = [self networkStatusForFlags: flags];
		
		return status;
		
	}
	
	return kNotReachable;
	
} // currentReachabilityStatus


- (BOOL) isReachable {
	
	NSAssert(reachabilityRef, @"isReachable called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	NetworkStatus status = kNotReachable;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
		
		//		logReachabilityFlags(flags);
		
		status = [self networkStatusForFlags: flags];
		
		//		logNetworkStatus(status);
		
		return (kNotReachable != status);
		
	}
	
	return NO;
	
} // isReachable


- (BOOL) isConnectionRequired {
	
	NSAssert(reachabilityRef, @"isConnectionRequired called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
		
		logReachabilityFlags(flags);
		
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
		
	}
	
	return NO;
	
} // isConnectionRequired


- (BOOL) connectionRequired {
	
	return [self isConnectionRequired];
	
} // connectionRequired
#endif


#if(__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000)
static const SCNetworkReachabilityFlags kOnDemandConnection = kSCNetworkReachabilityFlagsConnectionOnTraffic | 
kSCNetworkReachabilityFlagsConnectionOnDemand;
#else
static const SCNetworkReachabilityFlags kOnDemandConnection = kSCNetworkReachabilityFlagsConnectionAutomatic;
#endif

- (BOOL) isConnectionOnDemand {
	
	NSAssert(reachabilityRef, @"isConnectionIsOnDemand called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
		
		logReachabilityFlags(flags);
		
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & kOnDemandConnection));
		
	}
	
	return NO;
	
} // isConnectionOnDemand


- (BOOL) isInterventionRequired {
	
	NSAssert(reachabilityRef, @"isInterventionRequired called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
		
		logReachabilityFlags(flags);
		
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & kSCNetworkReachabilityFlagsInterventionRequired));
		
	}
	
	return NO;
	
} // isInterventionRequired


- (BOOL) isReachableViaWWAN {
	
	NSAssert(reachabilityRef, @"isReachableViaWWAN called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	NetworkStatus status = kNotReachable;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
		
		logReachabilityFlags(flags);
		
		status = [self networkStatusForFlags: flags];
		
		return  (kReachableViaWWAN == status);
		
	}
	
	return NO;
	
} // isReachableViaWWAN


- (BOOL) isReachableViaWiFi {
	
	NSAssert(reachabilityRef, @"isReachableViaWiFi called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	NetworkStatus status = kNotReachable;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
		
		logReachabilityFlags(flags);
		
		status = [self networkStatusForFlags: flags];
		
		return  (kReachableViaWiFi == status);
		
	}
	
	return NO;
	
} // isReachableViaWiFi


- (SCNetworkReachabilityFlags) reachabilityFlags {
	
	NSAssert(reachabilityRef, @"reachabilityFlags called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
		
		logReachabilityFlags(flags);
		
		return flags;
		
	}
	
	return 0;
	
} // reachabilityFlags


#pragma mark -
#pragma mark Apple's Network Flag Handling Methods


#if !USE_DDG_EXTENSIONS
/*
 *
 *  Apple's Network Status testing code.
 *  The only changes that have been made are to use the new logReachabilityFlags macro and
 *  test for local WiFi via the key instead of Apple's boolean. Also, Apple's code was for v3.0 only
 *  iPhone OS. v2.2.1 and earlier conditional compiling is turned on. Hence, to mirror Apple's behavior,
 *  set your Base SDK to v3.0 or higher.
 *
 */

- (NetworkStatus) localWiFiStatusForFlags: (SCNetworkReachabilityFlags) flags
{
	logReachabilityFlags(flags);
	
	BOOL retVal = NotReachable;
	if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
	{
		retVal = ReachableViaWiFi;	
	}
	return retVal;
}


- (NetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags
{
	logReachabilityFlags(flags);
	if(!(flags & kSCNetworkReachabilityFlagsReachable))
	{
		// if target host is not reachable
		return NotReachable;
	}
	
	BOOL retVal = NotReachable;
	
	if(!(flags & kSCNetworkReachabilityFlagsConnectionRequired))
	{
		// if target host is reachable and no connection is required
		//  then we'll assume (for now) that your on Wi-Fi
		retVal = ReachableViaWiFi;
	}
	
#if(__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) // Apple advises you to use the magic number instead of a symbol.	
	if((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ||
		(flags & kSCNetworkReachabilityFlagsConnectionOnTraffic))
#else
		if(flags & kSCNetworkReachabilityFlagsConnectionAutomatic)
#endif
		{
			// ... and the connection is on-demand (or on-traffic) if the
			//     calling application is using the CFSocketStream or higher APIs
			
			if(!(flags & kSCNetworkReachabilityFlagsInterventionRequired))
			{
				// ... and no [user] intervention is needed
				retVal = ReachableViaWiFi;
			}
		}
	
	if(flags & kSCNetworkReachabilityFlagsIsWWAN)
	{
		// ... but WWAN connections are OK if the calling application
		//     is using the CFNetwork (CFSocketStream?) APIs.
		retVal = ReachableViaWWAN;
	}
	return retVal;
}


- (NetworkStatus) currentReachabilityStatus
{
	NSAssert(reachabilityRef, @"currentReachabilityStatus called with NULL reachabilityRef");
	
	NetworkStatus retVal = NotReachable;
	SCNetworkReachabilityFlags flags;
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
	{
		if(self.key == kLocalWiFiConnection)
		{
			retVal = [self localWiFiStatusForFlags: flags];
		}
		else
		{
			retVal = [self networkStatusForFlags: flags];
		}
	}
	return retVal;
}


- (BOOL) isReachable {
	
	NSAssert(reachabilityRef, @"isReachable called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	NetworkStatus status = kNotReachable;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
		
		logReachabilityFlags(flags);
		
		if(self.key == kLocalWiFiConnection) {
			
			status = [self localWiFiStatusForFlags: flags];
			
		} else {
			
			status = [self networkStatusForFlags: flags];
			
		}
		
		return (kNotReachable != status);
		
	}
	
	return NO;
	
} // isReachable


- (BOOL) isConnectionRequired {
	
	return [self connectionRequired];
	
} // isConnectionRequired


- (BOOL) connectionRequired {
	
	NSAssert(reachabilityRef, @"connectionRequired called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
		
		logReachabilityFlags(flags);
		
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
		
	}
	
	return NO;
	
} // connectionRequired
#endif

@end

#endif
