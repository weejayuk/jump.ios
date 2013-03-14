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


 File:   JRCapture.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, January 31, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "JRCapture.h"

#import "JREngageWrapper.h"
#import "JRCaptureData.h"
#import "JRCaptureJsWidgetWrapper.h"

@implementation JRCapture

+ (void)setBackplaneChannelUrl:(NSString *)backplaneChannelUrl
{
    [JRCaptureData sharedCaptureData].bpChannelUrl = backplaneChannelUrl;
}

+ (void)      setEngageAppId:(NSString *)engageAppId captureDomain:(NSString *)captureDomain
             captureClientId:(NSString *)clientId captureLocale:(NSString *)captureLocale
             captureFlowName:(NSString *)captureFlowName
             captureFormName:(NSString *)captureFormName
captureTraditionalSignInType:(JRConventionalSigninType)tradSignInType
{
    [JRCaptureData setCaptureDomain:captureDomain captureClientId:clientId
                      captureLocale:captureLocale captureFormName:captureFormName
                    captureFlowName:(NSString *)captureFlowName
       captureTraditionalSignInType:tradSignInType];
    [JREngageWrapper configureEngageWithCaptureMobileEndpointUrlAndAppId:engageAppId];
}

+ (NSString *)captureMobileEndpointUrl
{
    return [JRCaptureData captureMobileEndpointUrl];
}

/**
 * Clears user sign-in state from the Capture Library
 * This includes:
 *  - access token
 *  - creation token
 *  - uuid
 * These are cleared from memory as well as from disk.
 *
 * This does not include:
 *  - user model
 * (User models are managed by the host application, not by the Capture library.)
 */
+ (void)clearSignInState
{
    [JRCaptureData clearSignInState];
}

+ (void)setAccessToken:(NSString *)newAccessToken
{
    [JRCaptureData setAccessToken:newAccessToken];
}

+ (NSString *)getAccessToken
{
    return [JRCaptureData sharedCaptureData].accessToken;
}

+ (void)setCreationToken:(NSString *)newCreationToken
{
    [JRCaptureData setCreationToken:newCreationToken];
}

+ (void)startJsWidgetWithUrl:(NSString *)url
{
    [JRCaptureJsWidgetWrapper startJsWidgetWithUrl:url];
}

+ (void)startEngageSigninDialogForDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogWithConventionalSignIn:JRConventionalSigninNone
                                         andCustomInterfaceOverrides:nil forDelegate:delegate];
}

+ (void)startEngageSigninDialogWithConventionalSignin:(JRConventionalSigninType)conventionalSigninType
                                          forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogWithConventionalSignIn:conventionalSigninType
                                         andCustomInterfaceOverrides:nil forDelegate:delegate];
}

+ (void)startEngageSigninDialogOnProvider:(NSString *)provider
                              forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogOnProvider:provider
                            withCustomInterfaceOverrides:nil forDelegate:delegate];
}

+ (void)startEngageSigninDialogWithCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                                forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogWithConventionalSignIn:JRConventionalSigninNone
                                         andCustomInterfaceOverrides:customInterfaceOverrides
                                                         forDelegate:delegate];
}

+ (void)startEngageSigninDialogWithConventionalSignin:(JRConventionalSigninType)conventionalSignInType
                      andCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                      forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogWithConventionalSignIn:conventionalSignInType
                                         andCustomInterfaceOverrides:customInterfaceOverrides forDelegate:delegate];
}

+ (void)startEngageSigninDialogOnProvider:(NSString *)provider
               withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogOnProvider:provider
                            withCustomInterfaceOverrides:customInterfaceOverrides forDelegate:delegate];
}

+ (void)startCaptureConventionalSigninForUser:(NSString *)user withPassword:(NSString *)password
                               withSigninType:(JRConventionalSigninType)conventionalSignInType
                                  forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    NSString *typeString = conventionalSignInType == JRConventionalSigninEmailPassword ? @"email" :
            conventionalSignInType == JRConventionalSigninUsernamePassword ? @"username" : nil;
    if (!typeString) return;

    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:user, typeString, password, @"password", nil];
    [JRCaptureApidInterface signinCaptureUserWithCredentials:d ofType:typeString forDelegate:delegate withContext:nil];
}

- (void)dealloc
{
    [super dealloc];
}
@end
