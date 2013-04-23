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
    [self startCaptureConventionalSigninForUser:user withPassword:password withSigninType:conventionalSignInType
                                     mergeToken:nil forDelegate:delegate];
}

+ (void)refreshAccessToken
{
    NSString *date = [self utcTimeString];
    NSString *accessToken = [JRCaptureData sharedCaptureData].accessToken;
    NSString *refreshSecret = [JRCaptureData sharedCaptureData].refreshSecret;
    NSString *domain = [JRCaptureData sharedCaptureData].captureBaseUrl;
    NSString *refreshUrl = [NSString stringWithFormat:@"%@/access/getAccessToken", domain];
    NSDictionary *params = @{
            @"access_token" : accessToken,
            @"Signature" : [[self signatureForRefreshWithDate:date refreshSecret:refreshSecret 
                                                  accessToken:accessToken] stringByAddingUrlPercentEscapes],
            @"Date" : [date stringByAddingUrlPercentEscapes]
    };

    [self jsonRequestToUrl:refreshUrl params:params completionHandler:^(id r, NSError *e)
    {
        if (e)
        {
            fail
            return;
        }

        if ([@"ok" isEqual:[r objectForKey:@"stat"]])
        {
            [JRCaptureData setAccessToken:[r objectForKey:@"access_token"]];
            success
        } else {
            [JRCaptureError errorFromResult:r onProvider:nil engageToken:nil];
            fail
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
    NSString *stringToSign = [NSString stringWithFormat:@"refresh_access_token\n%@\n%@\n", dateString, accessToken];

    const char *cKey  = [refreshSecret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [stringToSign cStringUsingEncoding:NSASCIIStringEncoding];

    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    NSData *HMAC = [[[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)] autorelease];
    return [HMAC JR_stringWithBase64Encoding];
}

+ (void)registerNewUser:(JRCaptureUser *)newUser withRegistrationToken:(NSString *)registrationToken
            forDelegate:(id <JRCaptureSigninDelegate>)delegate context:(NSObject *)context
{
    if (!newUser)
    {
        [self maybeDispatch:@selector(registerUserDidFailWithError:context:) forDelegate:delegate
                    withArg:[JRCaptureError invalidArgumentErrorWithParameterName:@"newUser"] withArg:context];
        return;
    }
    JRCaptureData *config = [JRCaptureData sharedCaptureData];
    NSString *registrationForm = config.captureRegistrationFormName;
    NSDictionary *flow = config.captureFlow;
    NSMutableDictionary *params = [newUser toFormFieldsForForm:registrationForm withFlow:flow];
    [params addEntriesFromDictionary:@{
            @"client_id" : config.clientId,
            @"locale" : config.captureLocale,
            @"response_type" : @"token",
            @"redirect_uri" : [config redirectUri],
            @"flow_name" : config.captureFlowName,
            @"form" : config.captureRegistrationFormName
    }];
    if ([config downloadedFlowVersion]) [params setObject:[config downloadedFlowVersion] forKey:@"flow_version"];
    NSString *urlString;
    if (registrationToken)
    {
        [params setObject:registrationToken forKey:@"token"];
        urlString = [NSString stringWithFormat:@"%@/oauth/register_native", config.captureBaseUrl];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@/oauth/register_native_traditional", config.captureBaseUrl];
    }

    [self jsonRequestToUrl:urlString params:params completionHandler:^(id parsedResponse, NSError *e)
    {
        [self handleRegistrationResponse:parsedResponse orError:e delegate:delegate context:context];
    }];
}

+ (void)handleRegistrationResponse:(id)parsedResponse orError:(NSError *)e
                          delegate:(id <JRCaptureSigninDelegate>)delegate context:(NSObject *)context
{
    SEL failMsg = @selector(registerUserDidFailWithError:context:);
    SEL successMsg = @selector(registerUserDidSucceed:context:);
    if (e)
    {
        ALog(@"%@", e);
        [self maybeDispatch:failMsg forDelegate:delegate withArg:e withArg:context];
        return;
    }

    if (![parsedResponse isKindOfClass:[NSDictionary class]])
    {
        e = [JRCaptureError invalidApiResponseErrorWithObject:parsedResponse];
        ALog(@"%@", e);
        [self maybeDispatch:failMsg forDelegate:delegate withArg:e withArg:context];
        return;
    }

    NSDictionary *parsedResponse_ = parsedResponse;
    NSString *stat = [parsedResponse_ objectForKey:@"stat"];
    if (![stat isEqual:@"ok"])
    {
        NSDictionary *errDict = [JRCaptureError invalidStatErrorDictForResult:parsedResponse_];
        e = [JRCaptureError errorFromResult:errDict onProvider:nil engageToken:nil];
        ALog(@"%@", e);
        [self maybeDispatch:failMsg forDelegate:delegate withArg:e withArg:context];
        return;
    }

    NSDictionary *userResultDict = [parsedResponse_ objectForKey:@"capture_user"];
    if (!userResultDict)
    {
        NSDictionary *errDict = [JRCaptureError invalidDataErrorDictForResult:parsedResponse_];
        e = [JRCaptureError errorFromResult:errDict onProvider:nil engageToken:nil];
        ALog(@"%@", e);
        [self maybeDispatch:failMsg forDelegate:delegate withArg:e withArg:context];
        return;
    }

    NSDictionary *newUserDict = [userResultDict objectForKey:@"result"];
    if (!newUserDict)
    {
        NSDictionary *errDict = [JRCaptureError invalidDataErrorDictForResult:parsedResponse_];
        e = [JRCaptureError errorFromResult:errDict onProvider:nil engageToken:nil];
        ALog(@"%@", e);
        [self maybeDispatch:failMsg forDelegate:delegate withArg:e withArg:context];
        return;
    }

    JRCaptureUser *newUser_ = [JRCaptureUser captureUserObjectFromDictionary:newUserDict];
    [self setAccessToken:[parsedResponse_ objectForKey:@"access_token"]];

    [self maybeDispatch:successMsg forDelegate:delegate withArg:newUser_ withArg:context];
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
