
#import "NSDictionary_Extras.h"

@implementation NSDictionary(Extras)

-(NSMutableDictionary*) mutableDeepCopy
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc] initWithCapacity:[self count]];
    NSArray* keys=[self allKeys];
    
    for(id key in keys)
    {
        id value=[self objectForKey:key];
        id copyValue=nil;
        
        if([value respondsToSelector:@selector(mutableDeepCopy)])
        {
            copyValue=[value mutableDeepCopy];
        }
        else if([value respondsToSelector:@selector(mutableCopy)])
        {
            copyValue=[[value mutableCopy] autorelease];
        }
        
        if(!copyValue)
            copyValue=[[value copy] autorelease];
        
        [dict setObject:copyValue forKey:key];
    }
    
    return [dict autorelease];
}

-(NSMutableDictionary*) mutableDeepCopy2
{
    NSDictionary* dict=[self copy];
    NSMutableDictionary* mdict=[dict mutableCopy];
    [dict release];
    
    return [mdict autorelease];
}

@end