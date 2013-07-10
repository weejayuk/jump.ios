#import "JRJsonUtils.h"

@implementation JRJsonUtils
+ (NSString *)jsonStringForJsonObject:(id)jsonObject
{
    NSError *jsonErr = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&jsonErr];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
#if !__has_feature(objc_arc)
    [jsonString autorelease];
#endif
    return jsonString;
}

+ (id)jsonObjectWithString:(NSString *)jsonString
{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [self jsonObjectWithData:jsonData];
}

+ (id)jsonObjectWithData:(NSData *)jsonData
{
    return [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingOptions) 0 error:nil];
}
@end

@implementation NSString (JRJsonUtils)
- (id)JR_objectFromJSONString
{
    return [JRJsonUtils jsonObjectWithString:self];
}
@end

@implementation NSDictionary (JRJsonUtils)
- (NSString *)JR_jsonString
{
    return [JRJsonUtils jsonStringForJsonObject:self];
}
@end

@implementation NSArray (JRJsonUtils)
- (NSString *)JR_jsonString
{
    return [JRJsonUtils jsonStringForJsonObject:self];
}
@end