
#import <Foundation/Foundation.h>

@interface  NSObject(Extras)

-(void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait;

@end
