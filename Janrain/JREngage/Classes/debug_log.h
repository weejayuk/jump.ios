#import <Foundation/Foundation.h>

#ifndef DLog
  #ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
  #else
    #define DLog(fmt, ...) JRLogExpressionSink((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
  #endif
#endif

#ifndef ALog
  #ifdef DEBUG
    #define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
  #else
    #ifdef JR_NO_RELEASE_LOGGING
      #define ALog(fmt, ...) JRLogExpressionSink((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #else
      #define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #endif
  #endif
#endif

void JRLogExpressionSink(NSString *format, ...);

@interface NSException (JR_raiseDebugException)
+ (void)raiseJRDebugException:(NSString *)name format:(NSString *)format, ...;
@end
