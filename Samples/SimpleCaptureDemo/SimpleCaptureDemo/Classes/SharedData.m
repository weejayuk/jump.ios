/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 Author: ${USER}
 Date:   ${DATE}
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "SharedData.h"

#define cJRCurrentProvider  @"simpleCaptureDemo.currentProvider"
#define cJRCaptureUser      @"simpleCaptureDemo.captureUser"

@interface JRCapture (private_methods)
+(void)clearSignInState;
@end

@interface SharedData ()
@property          BOOL                engageSignInWasCanceled;
@property (strong) JRCaptureUser      *captureUser;
@property          BOOL                isNew;
@property          BOOL                isNotYetCreated;
@property (strong) NSString           *currentProvider;
@property(nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation SharedData
static SharedData *singleton = nil;

// Testing
static NSString *engageAppId = @"appcfamhnpkagijaeinl";
static NSString *captureApidDomain  = @"mobile-testing.janraincapture.com";
static NSString *captureUIDomain    = @"mobile-testing.janraincapture.com";
static NSString *clientId           = @"atasaz59p8cyecmbzmcwkbthsyq3wrxh";

// old dev instance
//static NSString *engageAppId = @"appcfamhnpkagijaeinl";
//static NSString *captureApidDomain  = @"mobile.dev.janraincapture.com";
//static NSString *captureUIDomain    = @"mobile.dev.janraincapture.com";
//static NSString *clientId           = @"zc7tx83fqy68mper69mxbt5dfvd7c2jh"; // full access clientId
//static NSString *clientId           = @"233ke5wadxhdcrqwgtm4wjsqm299yj6g"; // two step clientId

@synthesize captureUser;
@synthesize currentProvider;
@synthesize demoSignInDelegate;
@synthesize isNew;
@synthesize isNotYetCreated;
@synthesize engageSignInWasCanceled;
@synthesize userDefaults;


- (id)init
{
    if ((self = [super init]))
    {
        [JRCapture setEngageAppId:engageAppId captureApidDomain:captureApidDomain
                  captureUIDomain:captureUIDomain clientId:clientId
                andEntityTypeName:nil];

        self.userDefaults = [NSUserDefaults standardUserDefaults];

        currentProvider  = [userDefaults objectForKey:cJRCurrentProvider];

        NSData *archivedCaptureUser = [userDefaults objectForKey:cJRCaptureUser];
        if (archivedCaptureUser)
        {
            captureUser = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCaptureUser];
        }
    }

    return self;
}

+ (SharedData *)sharedData
{
    if (singleton == nil) {
        singleton = (SharedData *) [[super allocWithZone:NULL] init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedData];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)signOutCurrentUser
{
    self.currentProvider  = nil;
    self.captureUser      = nil;

    self.isNew         = NO;
    self.isNotYetCreated = NO;

    [userDefaults setObject:nil forKey:cJRCurrentProvider];
    [userDefaults setObject:nil forKey:cJRCaptureUser];

    self.engageSignInWasCanceled = NO;

    [JRCapture clearSignInState];
}

+ (void)signOutCurrentUser
{
    [[SharedData sharedData] signOutCurrentUser];
}

+ (void)startAuthenticationWithCustomInterface:(NSDictionary *)customInterface
                                   forDelegate:(id<DemoSignInDelegate>)delegate
{
    [SharedData signOutCurrentUser];
    [[SharedData sharedData] setDemoSignInDelegate:delegate];

    [JRCapture startEngageSigninDialogWithConventionalSignin:JRConventionalSigninEmailPassword
                                 andCustomInterfaceOverrides:customInterface
                                                 forDelegate:[SharedData sharedData]];
}

- (void)saveCaptureUser
{
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:captureUser]
                     forKey:cJRCaptureUser];
}

+ (void)saveCaptureUser
{
    [[SharedData sharedData] saveCaptureUser];
}

- (void)postEngageErrorToDelegate:(NSError *)error
{
    DLog(@"error: %@", [error description]);
    if ([demoSignInDelegate respondsToSelector:@selector(engageSignInDidFailWithError:)])
        [demoSignInDelegate engageSignInDidFailWithError:error];
}

- (void)postCaptureErrorToDelegate:(NSError *)error
{
    DLog(@"error: %@", [error description]);
    if ([demoSignInDelegate respondsToSelector:@selector(captureSignInDidFailWithError:)])
        [demoSignInDelegate captureSignInDidFailWithError:error];
}

- (void)engageSigninDidNotComplete
{
    DLog(@"");
    self.engageSignInWasCanceled = YES;

    [self postEngageErrorToDelegate:nil];
}

- (void)engageSigninDialogDidFailToShowWithError:(NSError *)error
{
    DLog(@"error: %@", [error description]);
    [self postEngageErrorToDelegate:error];
}

- (void)engageAuthenticationDidFailWithError:(NSError *)error
                                 forProvider:(NSString *)provider
{
    DLog(@"error: %@", [error description]);
    [self postEngageErrorToDelegate:error];
}

- (void)captureAuthenticationDidFailWithError:(NSError *)error
{
    DLog(@"error: %@", [error description]);
    [self postCaptureErrorToDelegate:error];
}

- (void)engageSigninDidSucceedForUser:(NSDictionary *)engageAuthInfo
                          forProvider:(NSString *)provider
{
    self.currentProvider = provider;
    [userDefaults setObject:currentProvider forKey:cJRCurrentProvider];

    if ([demoSignInDelegate respondsToSelector:@selector(engageSignInDidSucceed)])
        [demoSignInDelegate engageSignInDidSucceed];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)captureAuthenticationDidSucceedForUser:(JRCaptureUser *)newCaptureUser
                                        status:(JRCaptureRecordStatus)captureRecordStatus
{
    DLog(@"");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if (captureRecordStatus == JRCaptureRecordNewlyCreated)
        self.isNew = YES;
    else
        self.isNew = NO;

    if (captureRecordStatus == JRCaptureRecordMissingRequiredFields)
        self.isNotYetCreated = YES;
    else
        self.isNotYetCreated = NO;

    self.captureUser = newCaptureUser;

    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:captureUser]
                     forKey:cJRCaptureUser];

    if ([demoSignInDelegate respondsToSelector:@selector(captureSignInDidSucceed)])
        [demoSignInDelegate captureSignInDidSucceed];

    engageSignInWasCanceled = NO;
}
@end
