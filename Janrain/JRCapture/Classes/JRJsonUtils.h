//
// Created by Nathan2 on 7/9/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface JRJsonUtils : NSObject
@end

@interface NSString (JRJsonUtils)
- (id)JR_objectFromJSONString;
@end

@interface NSDictionary (JRJsonUtils)
- (NSString *)JR_jsonString;
@end

@interface NSArray (JRJsonUtils)
- (NSString *)JR_jsonString;
@end