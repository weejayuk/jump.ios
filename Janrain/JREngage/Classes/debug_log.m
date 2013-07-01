#include "debug_log.h"

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

    if (debug)
    {
        [NSException raise:name1 format:format, va];
    }
    else
    {
        NSLog((@"%s [Line %d] ", format), __PRETTY_FUNCTION__, __LINE__, va);
    }

    va_end(va);
}

@end
