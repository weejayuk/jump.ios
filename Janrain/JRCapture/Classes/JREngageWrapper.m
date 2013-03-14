/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "JREngageWrapper.h"
#import "JRCaptureData.h"
#import "JREngage+CustomInterface.h"
#import "JSONKit.h"

typedef enum
{
    JREngageDialogStateAuthentication,
    JREngageDialogStateSharing,
} JREngageDialogState;

@interface JREngageWrapper ()
@property (retain) JRConventionalSignInViewController *nativeSigninViewController;
@property (retain) id<JRCaptureSigninDelegate> delegate;
@property          JREngageDialogState dialogState;
@end

@implementation JREngageWrapper
@synthesize nativeSigninViewController;
@synthesize delegate;
@synthesize dialogState;

static JREngageWrapper *singleton = nil;

- (JREngageWrapper *)init
{
    if ((self = [super init])) { }

    return self;
}

+ (JREngageWrapper *)singletonInstance
{
    if (singleton == nil) {
        singleton = [((JREngageWrapper*)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self singletonInstance] retain];
}

- (id)copyWithZone:(__unused NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release { }

- (id)autorelease
{
    return self;
}

+ (void)configureEngageWithCaptureMobileEndpointUrlAndAppId:(NSString *)appId
{
    [JREngage setEngageAppId:appId tokenUrl:nil andDelegate:[JREngageWrapper singletonInstance]];
}

+ (void)startAuthenticationDialogWithConventionalSignIn:(JRConventionalSigninType)nativeSigninType
                            andCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                            forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngage updateTokenUrl:[JRCaptureData captureMobileEndpointUrl]];

    JREngageWrapper *wrapper = [JREngageWrapper singletonInstance];
    [wrapper setDelegate:delegate];
    [wrapper setDialogState:JREngageDialogStateAuthentication];

    NSMutableDictionary *expandedCustomInterfaceOverrides =
            [NSMutableDictionary dictionaryWithDictionary:customInterfaceOverrides];

    if (nativeSigninType != JRConventionalSigninNone)
    {
        NSString *nativeSignInTitleString =
                ([expandedCustomInterfaceOverrides objectForKey:kJRCaptureConventionalSigninTitleString] ?
                        [expandedCustomInterfaceOverrides objectForKey:kJRCaptureConventionalSigninTitleString] :
                        (nativeSigninType == JRConventionalSigninEmailPassword ?
                                @"Sign In With Your Email and Password" :
                                @"Sign In With Your Username and Password"));

        if (![expandedCustomInterfaceOverrides objectForKey:kJRProviderTableSectionHeaderTitleString])
            [expandedCustomInterfaceOverrides setObject:@"Sign In With a Social Provider"
                                                 forKey:kJRProviderTableSectionHeaderTitleString];

        UIView *const titleView = [expandedCustomInterfaceOverrides objectForKey:kJRCaptureConventionalSigninTitleView];
        JRConventionalSignInViewController *controller =
                [JRConventionalSignInViewController conventionalSignInViewController:nativeSigninType
                                                                         titleString:nativeSignInTitleString
                                                                           titleView:titleView
                                                                       engageWrapper:wrapper];
        [wrapper setNativeSigninViewController:controller];

        [expandedCustomInterfaceOverrides setObject:[wrapper nativeSigninViewController].view
                                             forKey:kJRProviderTableHeaderView];

        [expandedCustomInterfaceOverrides setObject:[wrapper nativeSigninViewController]
                                             forKey:kJRCaptureConventionalSigninViewController];
    }

    [JREngage showAuthenticationDialogWithCustomInterfaceOverrides:
                      [NSDictionary dictionaryWithDictionary:expandedCustomInterfaceOverrides]];
}

+ (void)startAuthenticationDialogOnProvider:(NSString *)provider
               withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngage updateTokenUrl:[JRCaptureData captureMobileEndpointUrl]];

    [[JREngageWrapper singletonInstance] setDelegate:delegate];
    [[JREngageWrapper singletonInstance] setDialogState:JREngageDialogStateAuthentication];

    [JREngage showAuthenticationDialogForProvider:provider withCustomInterfaceOverrides:customInterfaceOverrides];
}

- (void)engageLibraryTearDown
{
    [JREngage updateTokenUrl:nil];
    [self setDelegate:nil];
    [self setNativeSigninViewController:nil];
}

- (void)authenticationCallToTokenUrl:(NSString *)tokenUrl didFailWithError:(NSError *)error 
                         forProvider:(NSString *)provider
{
    if ([delegate respondsToSelector:@selector(captureAuthenticationDidFailWithError:)])
        [delegate captureAuthenticationDidFailWithError:error];

    [self engageLibraryTearDown];
}

- (void)authenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider
{
    if ([delegate respondsToSelector:@selector(engageAuthenticationDidFailWithError:forProvider:)])
        [delegate engageAuthenticationDidFailWithError:error forProvider:provider];

    [self engageLibraryTearDown];
}

- (void)authenticationDidNotComplete
{
    if ([delegate respondsToSelector:@selector(engageSigninDidNotComplete)])
        [delegate engageSigninDidNotComplete];

    [self engageLibraryTearDown];
}

- (void)authenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response
                            andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider
{
    NSString *payload = [[[NSString alloc] initWithData:tokenUrlPayload encoding:NSUTF8StringEncoding] autorelease];
    NSDictionary *payloadDict = [payload objectFromJSONString];

    DLog(@"%@", payload);

    if (!payloadDict)
        return [self authenticationCallToTokenUrl:tokenUrl
                                   didFailWithError:[JRCaptureError invalidPayloadError:payload]
                                        forProvider:provider];

    if (![(NSString *)[payloadDict objectForKey:@"stat"] isEqualToString:@"ok"])
        return [self authenticationCallToTokenUrl:tokenUrl
                                   didFailWithError:[JRCaptureError invalidPayloadError:payload]
                                        forProvider:provider];

    FinishSignInError error = [JRCaptureApidInterface finishSignInWithPayload:payloadDict forDelegate:delegate];

    if (error == cJRInvalidResponse)
        [self authenticationCallToTokenUrl:tokenUrl
                          didFailWithError:[JRCaptureError invalidPayloadError:payload]
                               forProvider:provider];

    if (error == cJRInvalidCaptureUser)
        return [self authenticationCallToTokenUrl:tokenUrl
                                 didFailWithError:[JRCaptureError invalidPayloadError:payload]
                                      forProvider:provider];

    [self engageLibraryTearDown];
}

- (void)authenticationDidSucceedForUser:(NSDictionary *)auth_info forProvider:(NSString *)provider
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    if ([delegate respondsToSelector:@selector(engageSigninDidSucceedForUser:forProvider:)])
            [delegate engageSigninDidSucceedForUser:auth_info forProvider:provider];
}

- (void)engageDialogDidFailToShowWithError:(NSError *)error
{
    if (dialogState == JREngageDialogStateAuthentication)
    {
        if ([delegate respondsToSelector:@selector(engageSigninDialogDidFailToShowWithError:)])
            [delegate engageSigninDialogDidFailToShowWithError:error];
    }

    [self engageLibraryTearDown];
}

- (void)dealloc
{
    [delegate release];

    [nativeSigninViewController release];
    [super dealloc];
}
@end
