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


#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "JRCapture.h"

#import "JREngageWrapper.h"
#import "JRCaptureData.h"
#import "NSDictionary+JRQueryParams.h"
#import "debug_log.h"
#import "JRBase64.h"

@implementation JRCapture

+ (void)setBackplaneChannelUrl:(NSString *)backplaneChannelUrl
{
    [JRCaptureData sharedCaptureData].bpChannelUrl = backplaneChannelUrl;
}

+        (void)setEngageAppId:(NSString *)engageAppId captureDomain:(NSString *)captureDomain
              captureClientId:(NSString *)clientId captureLocale:(NSString *)captureLocale
              captureFlowName:(NSString *)captureFlowName captureSignInFormName:(NSString *)captureSignInFormName
captureEnableThinRegistration:(BOOL)enableThinRegistration
 captureTraditionalSignInType:(__unused JRConventionalSigninType)tradSignInType
           captureFlowVersion:(NSString *)captureFlowVersion
  captureRegistrationFormName:(NSString *)captureRegistrationFormName captureAppId:(NSString *)captureAppId
      customIdentityProviders:(NSDictionary *)customProviders
{
    [JRCaptureData setCaptureDomain:captureDomain captureClientId:clientId captureLocale:captureLocale
              captureSignInFormName:captureSignInFormName captureFlowName:captureFlowName
      captureEnableThinRegistration:enableThinRegistration
       //captureTraditionalSignInType:tradSignInType
        captureRegistrationFormName:captureRegistrationFormName captureFlowVersion:captureFlowVersion
                       captureAppId:captureAppId];

    [JREngageWrapper configureEngageWithAppId:engageAppId customIdentityProviders:customProviders];
}

+ (NSString *)captureMobileEndpointUrl __unused
{
    return [JRCaptureData captureTokenUrlWithMergeToken:nil];
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

+ (void)setRedirectUri:(NSString *)redirectUri __unused
{
    [JRCaptureData setCaptureRedirectUri:redirectUri];
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
             withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
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
    [self startCaptureConventionalSigninForUser:user withPassword:password withSigninType:conventionalSignInType
                                     mergeToken:nil forDelegate:delegate];
}

+ (void)refreshAccessTokenWithCallback:(void (^)(BOOL, NSError *))callback __unused
{
    NSString *date = [self utcTimeString];
    NSString *accessToken = [JRCaptureData sharedCaptureData].accessToken;
    NSString *refreshSecret = [JRCaptureData sharedCaptureData].refreshSecret;
    NSString *domain = [JRCaptureData sharedCaptureData].captureBaseUrl;
    NSString *refreshUrl = [NSString stringWithFormat:@"%@/oauth/refresh_access_token", domain];
    NSString *signature = [[self signatureForRefreshWithDate:date refreshSecret:refreshSecret
                                                  accessToken:accessToken] stringByAddingUrlPercentEscapes];
    if (!signature)
    {
        callback(NO, [JRCaptureError invalidInternalStateErrorWithDescription:@"missing refresh secret"]);
        return;
    }

    NSDictionary *params =
            @{
                    @"access_token" : accessToken,
                    @"signature" : signature,
                    @"date" : [date stringByAddingUrlPercentEscapes]
            };
    DLog(@"refreshing access token");

    [self jsonRequestToUrl:refreshUrl params:params completionHandler:^(id r, NSError *e)
    {
        if (e)
        {
            ALog(@"Failure refreshing access token: %@", e);
            callback(NO, e);
            return;
        }

        if ([@"ok" isEqual:[r objectForKey:@"stat"]])
        {
            [JRCaptureData setAccessToken:[r objectForKey:@"access_token"]];
            DLog(@"refreshed access token");
            callback(YES, nil);
        }
        else
        {
            callback(NO, [JRCaptureError errorFromResult:r onProvider:nil engageToken:nil]);
        }
    }];
}

+ (NSString *)utcTimeString
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

+ (NSString *)signatureForRefreshWithDate:(NSString *)dateString refreshSecret:(NSString *)refreshSecret
                              accessToken:(NSString *)accessToken
{
    if (!refreshSecret) return nil;
    NSString *stringToSign = [NSString stringWithFormat:@"refresh_access_token\n%@\n%@\n", dateString, accessToken];

    const char *cKey  = [refreshSecret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [stringToSign cStringUsingEncoding:NSASCIIStringEncoding];

    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    return [[[[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)] autorelease] JRBase64EncodedString];
}

+ (void)registerNewUser:(JRCaptureUser *)newUser withSocialRegistrationToken:(NSString *)socialRegistrationToken
            forDelegate:(id <JRCaptureSigninDelegate>)delegate
{
    if (!newUser)
    {
        [self maybeDispatch:@selector(registerUserDidFailWithError:) forDelegate:delegate
                    withArg:[JRCaptureError invalidArgumentErrorWithParameterName:@"newUser"]];
        return;
    }

    JRCaptureData *config = [JRCaptureData sharedCaptureData];
    NSString *registrationForm = config.captureRegistrationFormName;
    NSDictionary *flow = config.captureFlow;
    NSMutableDictionary *params = [newUser toFormFieldsForForm:registrationForm withFlow:flow];
    NSString *refreshSecret = [JRCaptureData generateAndStoreRefreshSecret];

    if (!refreshSecret)
    {
        [self maybeDispatch:@selector(registerUserDidFailWithError:) forDelegate:delegate
                    withArg:[JRCaptureError invalidInternalStateErrorWithDescription:@"unable to generate secure "
                            "random refresh secret"]];
        return;
    }

    [params addEntriesFromDictionary:@{
            @"client_id" : config.clientId,
            @"locale" : config.captureLocale,
            @"response_type" : @"token",
            @"redirect_uri" : [config redirectUri],
            @"flow_name" : config.captureFlowName,
            @"form" : config.captureRegistrationFormName,
            @"refresh_secret" : refreshSecret,
    }];

    if (config.bpChannelUrl) [params setObject:config.bpChannelUrl forKey:@"bp_channel"];
    if ([config downloadedFlowVersion]) [params setObject:[config downloadedFlowVersion] forKey:@"flow_version"];

    NSString *urlString;
    if (socialRegistrationToken)
    {
        [params setObject:socialRegistrationToken forKey:@"token"];
        urlString = [NSString stringWithFormat:@"%@/oauth/register_native", config.captureBaseUrl];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@/oauth/register_native_traditional", config.captureBaseUrl];
    }

    [self jsonRequestToUrl:urlString params:params completionHandler:^(id parsedResponse, NSError *e)
    {
        [self handleRegistrationResponse:parsedResponse orError:e delegate:delegate];
    }];
}

+ (void)handleRegistrationResponse:(id)parsedResponse orError:(NSError *)e
                          delegate:(id <JRCaptureSigninDelegate>)delegate
{
    SEL failMsg = @selector(registerUserDidFailWithError:);
    SEL successMsg = @selector(registerUserDidSucceed:);
    if (e)
    {
        ALog(@"%@", e);
        [self maybeDispatch:failMsg forDelegate:delegate withArg:e];
        return;
    }

    if (![parsedResponse isKindOfClass:[NSDictionary class]])
    {
        e = [JRCaptureError invalidApiResponseErrorWithObject:parsedResponse];
        ALog(@"%@", e);
        [self maybeDispatch:failMsg forDelegate:delegate withArg:e];
        return;
    }

    NSDictionary *parsedResponse_ = parsedResponse;
    NSString *stat = [parsedResponse_ objectForKey:@"stat"];
    if (![stat isEqual:@"ok"])
    {
        e = [JRCaptureError errorFromResult:parsedResponse_ onProvider:nil engageToken:nil];
        ALog(@"%@", e);
        [self maybeDispatch:failMsg forDelegate:delegate withArg:e];
        return;
    }

    NSDictionary *newUserDict = [parsedResponse_ objectForKey:@"capture_user"];
    if (!newUserDict)
    {
        NSDictionary *errDict = [JRCaptureError invalidDataErrorDictForResult:parsedResponse_];
        e = [JRCaptureError errorFromResult:errDict onProvider:nil engageToken:nil];
        ALog(@"%@", e);
        [self maybeDispatch:failMsg forDelegate:delegate withArg:e];
        return;
    }

    JRCaptureUser *newUser_ = [JRCaptureUser captureUserObjectFromDictionary:newUserDict];
    [self setAccessToken:[parsedResponse_ objectForKey:@"access_token"]];

    [self maybeDispatch:successMsg forDelegate:delegate withArg:newUser_];
}

//+ (void)maybeDispatch:(SEL)pSelector forDelegate:(id <JRCaptureSigninDelegate>)delegate withArg:(id)arg1
//              withArg:(id)arg2
//{
//    if ([delegate respondsToSelector:pSelector])
//    {
//        [delegate performSelector:pSelector withObject:arg1 withObject:arg2];
//        [delegate performSelector:pSelector withObject:arg1];
//    }
//}

+ (void)maybeDispatch:(SEL)pSelector forDelegate:(id <JRCaptureSigninDelegate>)delegate withArg:(id)arg
{
    if ([delegate respondsToSelector:pSelector])
    {
        [delegate performSelector:pSelector withObject:arg];
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
                                   ALog(@"Error fetching JSON: %@", e);
                                   handler(nil, e);
                               }
                               else
                               {
                                   NSString *bodyString =
                                           [[[NSString alloc] initWithData:d
                                                                  encoding:NSUTF8StringEncoding] autorelease];
                                   ALog(@"Fetching expected JSON: %@", bodyString);
                                   NSError *err;
                                   id parsedJson = [NSJSONSerialization JSONObjectWithData:d
                                                                                   options:(NSJSONReadingOptions) 0
                                                                                     error:&err];
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
    NSString *paramString = [dictionary asJRURLParamString];
    DLog(@"Adding params to %@: %@", request, paramString);
    [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)dealloc
{
    [super dealloc];
}
@end
