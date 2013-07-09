//
// Created by Nathan2 on 7/8/13.
// Copyright (c) 2013 Janrain. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "JRNativeAuth.h"


@implementation JRNativeAuth
{

}
+ (BOOL)canHandlerProvider:(NSString *)provider
{
    if ([provider isEqual:@"facebook"]) return YES;
    return NO;
}

+ (void)authOnProvider:(NSString *)provider completion:(void (^)())completion
{
    //if ([provider isEqual:@"facebook"])
    //{
    //    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
    //        // To-do, show logged in view
    //        NSLog(@"logged in");
    //        NSLog(@"token %@", FBSession.activeSession.accessTokenData.accessToken);
    //
    //    } else {
    //        NSLog(@"not logged in");
    //        [FBSession openActiveSessionWithReadPermissions:@[] allowLoginUI:YES
    //                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
    //                                          NSLog(@"session %@ status %i error %@", session, status, error);
    //                                          NSLog(@"token %@", session.accessTokenData.accessToken);
    //        }];
    //        // No, display the login page.
    //    }
    //
    //}
}
@end