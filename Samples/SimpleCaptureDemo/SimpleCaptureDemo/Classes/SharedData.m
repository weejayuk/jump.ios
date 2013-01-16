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
#import "JSONKit.h"
#import "JRConnectionManager.h"

#define cJRCurrentProvider  @"simpleCaptureDemo.currentProvider"
#define cJRCaptureUser      @"simpleCaptureDemo.captureUser"

@interface JRCapture (private_methods)
+(void)clearSignInState;
@end

@interface SharedData ()
@property(strong) NSUserDefaults *prefs;
@property(strong) JRCaptureUser *captureUser;
@property BOOL isNew;
@property BOOL isNotYetCreated;
@property(strong) NSString *currentProvider;
@property(weak) id <DemoSignInDelegate> demoSigninDelegate;
@property(nonatomic) BOOL engageSignInWasCanceled;
@property(nonatomic) NSString *lfToken;
@property(nonatomic, retain) NSString *captureClientId;
@property(nonatomic, retain) NSString *captureUIDomain;
@property(nonatomic, retain) NSString *captureApidDomain;
@property(nonatomic, retain) NSString *engageAppId;
@property(nonatomic, retain) NSString *bpBusUrlString;
@property(nonatomic, retain) NSString *bpChannelUrl;
@property(nonatomic, retain) NSString *liveFyreNetwork;
@property(nonatomic, retain) NSString *liveFyreSiteId;
@property(nonatomic, retain) NSString *liveFyreArticleId;
@end

@implementation SharedData
static SharedData *singleton = nil;

@synthesize captureUser;
@synthesize prefs;
@synthesize currentProvider;
@synthesize demoSigninDelegate;
@synthesize isNew;
@synthesize isNotYetCreated;
@synthesize engageSignInWasCanceled;
@synthesize bpChannelUrl;
@synthesize lfToken;
@synthesize captureClientId;
@synthesize captureUIDomain;
@synthesize captureApidDomain;
@synthesize engageAppId;
@synthesize bpBusUrlString;
@synthesize liveFyreNetwork;
@synthesize liveFyreSiteId;
@synthesize liveFyreArticleId;

- (id)init
{
    if ((self = [super init]))
    {
        [self loadConfigFromPlist];
        [JRCapture setEngageAppId:engageAppId captureApidDomain:captureApidDomain
                  captureUIDomain:captureUIDomain clientId:captureClientId andEntityTypeName:nil];
        [self asyncFetchNewBackplaneChannel];

        prefs = [NSUserDefaults standardUserDefaults];

        currentProvider  = [prefs objectForKey:cJRCurrentProvider];

        NSData *archivedCaptureUser = [prefs objectForKey:cJRCaptureUser];
        if (archivedCaptureUser)
        {
            captureUser = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCaptureUser];
        }
    }

    return self;
}

- (void)loadConfigFromPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"janrain-config" ofType:@"plist"];
    NSDictionary *cfgPlist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *configKeyName = [cfgPlist objectForKey:@"default-config"];
    NSDictionary *cfg = [cfgPlist objectForKey:configKeyName];

    captureClientId = [cfg objectForKey:@"captureClientId"];
    captureUIDomain = [cfg objectForKey:@"captureUIDomain"];
    captureApidDomain = [cfg objectForKey:@"captureApidDomain"];
    engageAppId = [cfg objectForKey:@"engageAppId"];
    bpBusUrlString = [cfg objectForKey:@"bpBusUrlString"];
    bpChannelUrl = [cfg objectForKey:@"bpChannelUrl"];
    liveFyreNetwork = [cfg objectForKey:@"liveFyreNetwork"];
    liveFyreSiteId = [cfg objectForKey:@"liveFyreSiteId"];
    liveFyreArticleId = [cfg objectForKey:@"liveFyreArticleId"];
}

- (void)asyncFetchNewBackplaneChannel
{
    NSURL *bpNewChanUrl = [NSURL URLWithString:[bpBusUrlString stringByAppendingString:@"/channel/new"]];
    NSURLRequest *req = [NSURLRequest requestWithURL:bpNewChanUrl
                                         cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                     timeoutInterval:5];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *r, NSData *d, NSError *e)
                           {
                               NSInteger code = [((NSHTTPURLResponse *) r) statusCode];
                               if (e || code != 200)
                               {
                                   ALog(@"Err fetching new BP channel: %@, code: %i", e, code);
                               }
                               else
                               {
                                   NSString *body = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
                                   NSCharacterSet *quoteSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
                                   NSString *bpChannel = [body stringByTrimmingCharactersInSet:quoteSet];
                                   NSString *bpChannelUrl = [bpBusUrlString stringByAppendingFormat:@"/channel/%@",
                                                                            bpChannel];
                                   DLog(@"New BP channel: %@", bpChannelUrl);
                                   self.bpChannelUrl = bpChannelUrl;
                                   [JRCapture setBackplaneChannelUrl:bpChannelUrl];
                               }
                           }];
}

- (void)asyncFetchNewLiveFyreUserToken
{
    NSString *lfAuthUrl = [NSString stringWithFormat:@"http://admin.%@/api/v3.0/auth?bp_channel=%@&siteId=%@"
                                                             "&articleId=%@",
                                                     liveFyreNetwork,
                                                     [self.bpChannelUrl stringByAddingUrlPercentEscapes],
                                                     liveFyreSiteId,
                                                     [liveFyreArticleId stringByAddingUrlPercentEscapes]];
    DLog(@"Fetching LF token from %@", lfAuthUrl);
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:lfAuthUrl]
                                         cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                     timeoutInterval:5];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *r, NSData *d, NSError *e)
                           {
                               NSString *body = d ? [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]
                                       : nil;
                               NSInteger code = [((NSHTTPURLResponse *) r) statusCode];
                               if (e || code != 200)
                               {
                                   ALog(@"Err fetching LF token: %@, code: %i, body: %@", e, code, body);
                               }
                               else
                               {
                                   NSDictionary *lfResponse = [body objectFromJSONString];
                                   if (!lfResponse)
                                   {
                                       ALog(@"Error parsing LF response: %@", body);
                                       return;
                                   }
                                   NSString *lfToken = [[lfResponse objectForKey:@"data"] objectForKey:@"token"];
                                   if (!lfToken) {
                                       ALog(@"Error retrieving token from LF response: %@", body);
                                       return;
                                   }
                                   DLog(@"New LF token: %@", lfToken);
                                   self.lfToken = lfToken;
                               }
                           }];

}

/* Return the singleton instance of this class. */
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

+ (JRCaptureUser *)captureUser
{
    return [[SharedData sharedData] captureUser];
}

+ (BOOL)isNew
{
    return [[SharedData sharedData] isNew];
}

+ (BOOL)isNotYetCreated
{
    return [[SharedData sharedData] isNotYetCreated];
}

+ (NSString *)currentEmail
{
    return [SharedData sharedData].captureUser.email;
}

+ (NSString *)currentProvider
{
    return [[SharedData sharedData] currentProvider];
}

- (void)signOutCurrentUser
{
    self.currentProvider  = nil;
    self.captureUser      = nil;

    self.isNew         = NO;
    self.isNotYetCreated = NO;

    [prefs setObject:nil forKey:cJRCurrentProvider];
    [prefs setObject:nil forKey:cJRCaptureUser];

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
    [[SharedData sharedData] setDemoSigninDelegate:delegate];

    [JRCapture startEngageSigninDialogWithConventionalSignin:JRConventionalSigninEmailPassword
                                 andCustomInterfaceOverrides:customInterface
                                                 forDelegate:[SharedData sharedData]];
}

//+ (NSString*)getDisplayNameFromProfile:(NSDictionary*)profile
//{
//    NSString *name = nil;
//
//    if ([profile objectForKey:@"preferredUsername"])
//        name = [NSString stringWithFormat:@"%@", [profile objectForKey:@"preferredUsername"]];
//    else if ([[profile objectForKey:@"name"] objectForKey:@"formatted"])
//        name = [NSString stringWithFormat:@"%@",
//                [[profile objectForKey:@"name"] objectForKey:@"formatted"]];
//    else
//        name = [NSString stringWithFormat:@"%@%@%@%@%@",
//                ([[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]) ?
//                [NSString stringWithFormat:@"%@ ",
//                 [[profile objectForKey:@"name"] objectForKey:@"honorificPrefix"]] : @"",
//                ([[profile objectForKey:@"name"] objectForKey:@"givenName"]) ?
//                [NSString stringWithFormat:@"%@ ",
//                 [[profile objectForKey:@"name"] objectForKey:@"givenName"]] : @"",
//                ([[profile objectForKey:@"name"] objectForKey:@"middleName"]) ?
//                [NSString stringWithFormat:@"%@ ",
//                 [[profile objectForKey:@"name"] objectForKey:@"middleName"]] : @"",
//                ([[profile objectForKey:@"name"] objectForKey:@"familyName"]) ?
//                [NSString stringWithFormat:@"%@ ",
//                 [[profile objectForKey:@"name"] objectForKey:@"familyName"]] : @"",
//                ([[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]) ?
//                [NSString stringWithFormat:@"%@ ",
//                 [[profile objectForKey:@"name"] objectForKey:@"honorificSuffix"]] : @""];
//
//    return name;
//}

- (void)resaveCaptureUser
{
    [prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:captureUser]
              forKey:cJRCaptureUser];
}

+ (void)resaveCaptureUser
{
    [[SharedData sharedData] resaveCaptureUser];
}

- (void)postEngageErrorToDelegate:(NSError *)error
{
    DLog(@"error: %@", [error description]);
    if ([demoSigninDelegate respondsToSelector:@selector(engageSignInDidFailWithError:)])
        [demoSigninDelegate engageSignInDidFailWithError:error];
}

- (void)postCaptureErrorToDelegate:(NSError *)error
{
    DLog(@"error: %@", [error description]);
    if ([demoSigninDelegate respondsToSelector:@selector(captureSignInDidFailWithError:)])
        [demoSigninDelegate captureSignInDidFailWithError:error];
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
    [prefs setObject:currentProvider forKey:cJRCurrentProvider];

    if ([demoSigninDelegate respondsToSelector:@selector(engageSignInDidSucceed)])
        [demoSigninDelegate engageSignInDidSucceed];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)captureAuthenticationDidSucceedForUser:(JRCaptureUser *)newCaptureUser
                                        status:(JRCaptureRecordStatus)captureRecordStatus
{
    DLog(@"");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

//    if (engageSigninWasCanceled) /* Then we logged in directly with the Capture server */
//        [self setEmailAddr:captureUser.email
//               andProvider:nil];

    if (captureRecordStatus == JRCaptureRecordNewlyCreated)
        self.isNew = YES;
    else
        self.isNew = NO;

    if (captureRecordStatus == JRCaptureRecordMissingRequiredFields)
        self.isNotYetCreated = YES;
    else
        self.isNotYetCreated = NO;

    self.captureUser = newCaptureUser;

    [prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:captureUser]
              forKey:cJRCaptureUser];

    if ([demoSigninDelegate respondsToSelector:@selector(captureSignInDidSucceed)])
        [demoSigninDelegate captureSignInDidSucceed];

    engageSignInWasCanceled = NO;
}
@end
