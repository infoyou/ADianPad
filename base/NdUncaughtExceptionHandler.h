
#import <Foundation/Foundation.h>

@interface NdUncaughtExceptionHandler : NSObject
{
}

+(void) setDefaultHandler;
+(NSUncaughtExceptionHandler*) getHandler;

@end
