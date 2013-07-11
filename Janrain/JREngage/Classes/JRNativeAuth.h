//
// Created by Nathan2 on 7/8/13.
// Copyright (c) 2013 Janrain. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface JRNativeAuth : NSObject
+ (BOOL)canHandlerProvider:(NSString *)provider;

+ (void)authOnProvider:(NSString *)provider completion:(void (^)(id, NSError *))completion;
@end