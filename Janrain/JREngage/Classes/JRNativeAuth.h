//
// Created by Nathan2 on 7/8/13.
// Copyright (c) 2013 Janrain. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface JRNativeAuth : NSObject
+ (BOOL)canHandleProvider:(NSString *)provider;

+ (void)startAuthOnProvider:(NSString *)provider completion:(void (^)(NSError *))completion;

@end