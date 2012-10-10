//
// Created by nathan on 10/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Utils.h"

Class getPluralClassFromKey(NSString *key)
{
    if (!key || [key length] < 1) return nil;
    NSString *upcasedKey = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                        withString:[[key substringToIndex:1] capitalizedString]];
    NSString *className = [NSString stringWithFormat:@"JR%@Element", upcasedKey];
    return NSClassFromString(className);
}

Class getClassFromKey(NSString *key)
{
    if (!key || [key length] < 1) return nil;
    NSString *upcasedKey = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                        withString:[[key substringToIndex:1] capitalizedString]];
    NSString *className = [NSString stringWithFormat:@"JR%@", upcasedKey];
    return NSClassFromString(className);
}
