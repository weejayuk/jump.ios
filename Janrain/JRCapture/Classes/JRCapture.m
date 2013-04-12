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
#import "NSDictionary+JRQueryParams.h"

@implementation JRCapture

+ (void)setBackplaneChannelUrl:(NSString *)backplaneChannelUrl
{
    [JRCaptureData sharedCaptureData].bpChannelUrl = backplaneChannelUrl;
}

+        (void)setEngageAppId:(NSString *)engageAppId captureDomain:(NSString *)captureDomain
              captureClientId:(NSString *)clientId captureLocale:(NSString *)captureLocale
              captureFlowName:(NSString *)captureFlowName captureSignInFormName:(NSString *)captureSignInFormName
captureEnableThinRegistration:(BOOL)enableThinRegistration
 captureTraditionalSignInType:(JRConventionalSigninType)tradSignInType captureFlowVersion:(NSString *)captureFlowVersion
  captureRegistrationFormName:(NSString *)captureRegistrationFormName captureAppId:(NSString *)captureAppId
{
    [JRCaptureData setCaptureDomain:captureDomain captureClientId:clientId captureLocale:captureLocale
              captureSignInFormName:captureSignInFormName captureFlowName:captureFlowName
      captureEnableThinRegistration:enableThinRegistration captureTraditionalSignInType:tradSignInType
        captureRegistrationFormName:captureRegistrationFormName captureFlowVersion:captureFlowVersion
                       captureAppId:captureAppId];
    [JREngageWrapper configureEngageWithCaptureMobileEndpointUrlAndAppId:engageAppId];
}

+ (NSString *)captureMobileEndpointUrl __unused
{
    return [JRCaptureData captureMobileEndpointUrlWithMergeToken:nil];
}

/**
 * Clears user sign-in state from the Capture Library
 * This includes:
 *  - access token
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

+ (void)setAccessToken:(NSString *)newAccessToken __unused
{
    [JRCaptureData setAccessToken:newAccessToken];
}

+ (NSString *)getAccessToken __unused
{
    return [JRCaptureData sharedCaptureData].accessToken;
}

+ (void)startEngageSigninDialogForDelegate:(id <JRCaptureSigninDelegate>)delegate __unused
{
    [JREngageWrapper startAuthenticationDialogWithConventionalSignIn:JRConventionalSigninNone
                                         andCustomInterfaceOverrides:nil forDelegate:delegate];
}

+ (void)startEngageSigninDialogWithConventionalSignin:(JRConventionalSigninType)conventionalSigninType
                                          forDelegate:(id <JRCaptureSigninDelegate>)delegate __unused
{
    [JREngageWrapper startAuthenticationDialogWithConventionalSignIn:conventionalSigninType
                                         andCustomInterfaceOverrides:nil forDelegate:delegate];
}

+ (void)startEngageSigninDialogOnProvider:(NSString *)provider
                              forDelegate:(id <JRCaptureSigninDelegate>)delegate __unused
{
    [JREngageWrapper startAuthenticationDialogOnProvider:provider withCustomInterfaceOverrides:nil mergeToken:nil
                                             forDelegate:delegate];
}

+ (void)startEngageSigninDialogWithCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                                forDelegate:(id <JRCaptureSigninDelegate>)delegate __unused
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
             withCustomInterfaceOverrides:(NSMutableDictionary *)customInterfaceOverrides
                               mergeToken:(NSString *)mergeToken
                              forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogOnProvider:provider
                            withCustomInterfaceOverrides:customInterfaceOverrides mergeToken:mergeToken
                                             forDelegate:delegate];
}

+ (void)startEngageSigninDialogOnProvider:(NSString *)provider
               withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                forDelegate:(id <JRCaptureSigninDelegate>)delegate __unused
{
    [JREngageWrapper startAuthenticationDialogOnProvider:provider
                            withCustomInterfaceOverrides:customInterfaceOverrides mergeToken:nil
                                             forDelegate:delegate];
}

+ (void)startCaptureConventionalSigninForUser:(NSString *)user withPassword:(NSString *)password
                               withSigninType:(JRConventionalSigninType)conventionalSignInType
                                   mergeToken:(NSString *)mergeToken forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    NSString *typeString = conventionalSignInType == JRConventionalSigninEmailPassword ? @"email" :
            conventionalSignInType == JRConventionalSigninUsernamePassword ? @"username" : nil;
    if (!typeString) return;

    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                          user, typeString,
                                                          password, @"password", nil];
    if (mergeToken) [d setObject:mergeToken forKey:@"token"];

    [JRCaptureApidInterface signinCaptureUserWithCredentials:d ofType:typeString forDelegate:delegate withContext:nil];
}

+ (void)startCaptureConventionalSigninForUser:(NSString *)user withPassword:(NSString *)password
                               withSigninType:(JRConventionalSigninType)conventionalSignInType
                                  forDelegate:(id <JRCaptureSigninDelegate>)delegate __unused
{
    [self startCaptureConventionalSigninForUser:user withPassword:password
                                 withSigninType:conventionalSignInType
                                     mergeToken:nil
                                    forDelegate:delegate];
}

+ (void)registerNewUser:(JRCaptureUser *)newUser forDelegate:(id <JRCaptureSigninDelegate>)delegate
                context:(void *)context
{
    NSString *urlString = @"https://%@/oauth/register_native";
    NSString *registrationForm;
    NSDictionary *flow;
    [self jsonRequestToUrl:urlString params:[newUser toFormFieldsForForm:registrationForm withFlow:flow]
         completionHandler:^(id parsedResponse, NSError *e)
         {
             SEL failMsg = @selector(registerUserDidFailWithError:context:);
             if (e)
             {
                 [self maybeDispatch:failMsg forDelegate:delegate withArg:e withArg:context];
                 return;
             }

             if (![parsedResponse isKindOfClass:[NSDictionary class]])
             {
                 e = [JRCaptureError invalidApiResponseErrorWithObject:parsedResponse];
                 [self maybeDispatch:failMsg forDelegate:delegate withArg:e withArg:context];
                 return;
             }

             NSDictionary *parsedResponse_ = parsedResponse;
             NSString *stat = [parsedResponse_ objectForKey:@"stat"];
             if (![stat isEqual:@"ok"])
             {
                 NSDictionary *errDict = [JRCaptureError invalidStatErrorDictForResult:parsedResponse_];
                 e = [JRCaptureError errorFromResult:errDict onProvider:nil mergeToken:nil];
                 [self maybeDispatch:failMsg forDelegate:delegate withArg:e withArg:context];
                 return;
             }

             NSDictionary *newUserDict = [parsedResponse_ objectForKey:@"userrrr"];
             if (!newUserDict)
             {
                 NSDictionary *errDict = [JRCaptureError invalidDataErrorDictForResult:parsedResponse_];
                 e = [JRCaptureError errorFromResult:errDict onProvider:nil mergeToken:nil];
                 [self maybeDispatch:failMsg forDelegate:delegate withArg:e withArg:context];
                 return;
             }

             JRCaptureUser *newUser = [JRCaptureUser captureUserObjectFromDictionary:newUserDict];

             SEL successMsg = @selector(registerUserDidSucceed:context:);
             [self maybeDispatch:successMsg forDelegate:delegate withArg:newUser withArg:context];
         }];
}

+ (void)maybeDispatch:(SEL)pSelector forDelegate:(id <JRCaptureSigninDelegate>)delegate withArg:(id)arg1
              withArg:(id)arg2
{
    if ([delegate respondsToSelector:pSelector])
    {
        [delegate performSelector:pSelector withObject:arg1 withObject:arg2];
    }
}

+ (void)jsonRequestToUrl:(NSString *)url params:(NSDictionary *)params
     completionHandler:(void(^)(id parsedResponse, NSError *e))handler
{
    NSMutableURLRequest *registrationRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self addParams:params toRequest:registrationRequest];
    [NSURLConnection sendAsynchronousRequest:registrationRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *r, NSData *d, NSError *e)
                           {
                               if (e)
                               {
                                   handler(nil, e);
                               }
                               else
                               {
                                   NSError *err;
                                   id parsedJson = [NSJSONSerialization JSONObjectWithData:d options:0 error:&err];
                                   if (err)
                                   {
                                       handler(nil, e);
                                   }
                                   else
                                   {
                                       handler(parsedJson, nil);
                                   }
                               }
                           }];
}

+ (void)addParams:(NSDictionary *)dictionary toRequest:(NSMutableURLRequest *)request
{
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[dictionary asJRGetQueryParamString] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)dealloc
{
    [super dealloc];
}
@end
