//
// Created by nathan on 10/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Utils.h"

Class getPluralClassFromKey(NSString *key)
{
    if (!key || [key length] < 1) return nil;
    NSString *className = [NSString stringWithFormat:@"JR%@Element", upcaseFirst(key)];
    return NSClassFromString(className);
}

Class getClassFromKey(NSString *key)
{
    if (!key || [key length] < 1) return nil;
    NSString *className = [NSString stringWithFormat:@"JR%@", upcaseFirst(key)];
    return NSClassFromString(className);
}

NSString *upcaseFirst(NSString *string)
{
    if (!string) return nil;
    if (![string length]) return string;
    return [string stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                           withString:[[string substringToIndex:1] capitalizedString]];
}