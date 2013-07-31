#include "debug_log.h"

// UPS-2039
void JRLogExpressionSink(NSString *format, ...)
{
    va_list va;
    va_start(va, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:va];
#if !__has_feature(objc_arc)
    [string autorelease];
#endif
    va_end(va);
    [string description];
}

@implementation NSException (JR_raiseDebugException)
+ (void)raiseJRDebugException:(NSString *)name1 format:(NSString *)format, ...
{
#ifdef DEBUG
    int debug = 1;
#else
    int debug = 0;
#endif

    va_list va;
    va_start(va, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:va];
#if !__has_feature(objc_arc)
    [string autorelease];
#endif
    va_end(va);

    if (debug)
    {
        [NSException raise:name1 format:@"%@", string];
    }
    else
    {
        NSLog(@"%@", string);
    }
}

@end
