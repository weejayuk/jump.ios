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

 File:   JRCaptureInterface.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Thursday, January 26, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "JRCaptureApidInterface.h"
#import "JRCaptureData.h"
#import "JSONKit.h"
#import "NSDictionary+JRQueryParams.h"

static NSString *const cSignInUser = @"signinUser";
static NSString *const cGetUser = @"getUser";
static NSString *const cGetObject = @"getObject";
static NSString *const cUpdateObject = @"updateObject";
static NSString *const cReplaceObject = @"replaceObject";
static NSString *const cReplaceArray = @"replaceArray";
static NSString *const cTagAction = @"action";


@implementation JRCaptureApidInterface
static JRCaptureApidInterface *singleton = nil;

- (JRCaptureApidInterface *)init
{
    if ((self = [super init])) { }

    return self;
}

+ (id)captureInterfaceInstance
{
    if (singleton == nil) {
        singleton = [((JRCaptureApidInterface *)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self captureInterfaceInstance] retain];
}

- (id)copyWithZone:(__unused NSZone *)zone __unused
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

typedef enum CaptureInterfaceStatEnum
{
    StatOk,
    StatFail,
} CaptureInterfaceStat;

- (void)finishSignInFailureWithError:(JRCaptureError *)error forDelegate:(id)delegate
                         withContext:(NSObject *)context
{
    if ([delegate conformsToProtocol:@protocol(JRCaptureSigninDelegate)] &&
            [delegate respondsToSelector:@selector(captureAuthenticationDidFailWithError:)])
    {
        [delegate captureAuthenticationDidFailWithError:error];
    }

    if ([delegate conformsToProtocol:@protocol(JRCaptureInterfaceDelegate)] &&
            [delegate respondsToSelector:@selector(signinCaptureUserDidFailWithResult:context:)])
        [delegate signinCaptureUserDidFailWithResult:error context:context];
}

- (void)finishSignInSuccessWithResult:(NSString *)result forDelegate:(id)delegate
                          withContext:(NSObject *)context
{
    if ([delegate conformsToProtocol:@protocol(JRCaptureSigninDelegate)] &&
            [delegate respondsToSelector:@selector(captureAuthenticationDidSucceedForUser:status:)])
    {
        BOOL respondsToFail = [delegate respondsToSelector:@selector(captureAuthenticationDidFailWithError:)];
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingOptions) 0
                                                                     error:nil];

        FinishSignInError err = [JRCaptureApidInterface finishSignInWithPayload:resultDict forDelegate:delegate];

        if ((err == cJRInvalidResponse || err == cJRInvalidCaptureUser) && respondsToFail)
        {
            [delegate captureAuthenticationDidFailWithError:[JRCaptureError invalidApiResponseErrorWithString:result]];
            return;
        }
    }

    if ([delegate conformsToProtocol:@protocol(JRCaptureInterfaceDelegate)] &&
            [delegate respondsToSelector:@selector(signinCaptureUserDidSucceedWithResult:context:)])
        [delegate signinCaptureUserDidSucceedWithResult:result context:context];
}


- (void)startSigninCaptureUserWithCredentials:(NSDictionary *)credentials ofType:(NSString *)signInFieldName
                                  forDelegate:(id)delegate withContext:(NSObject *)context
{
    DLog(@"");
    NSString *signInName = [credentials objectForKey:signInFieldName];
    NSString *password = [credentials objectForKey:@"password"];
    NSString *mergeToken = [credentials objectForKey:@"token"];
    NSString *clientId = [JRCaptureData sharedCaptureData].clientId;
    NSString *locale = [JRCaptureData sharedCaptureData].captureLocale;
    NSString *formName = [JRCaptureData sharedCaptureData].captureSignInFormName;
    NSString *flowName = [JRCaptureData sharedCaptureData].captureFlowName;
    NSString *redirectUri = [[JRCaptureData sharedCaptureData] redirectUri];
    NSString *refreshSecret = [JRCaptureData generateAndStoreRefreshSecret];
    NSString *bpChannelUrl = [JRCaptureData sharedCaptureData].bpChannelUrl;

    if (!refreshSecret)
    {
        JRCaptureError *error = [JRCaptureError invalidInternalStateErrorWithDescription:@"unable to generate secure "
                "random refresh secret"];
        [self finishSignInFailureWithError:error forDelegate:delegate withContext:context];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
                                                               @{
                                                                       signInFieldName : signInName,
                                                                       @"password" : password,
                                                                       @"client_id" : clientId,
                                                                       @"locale" : locale,
                                                                       @"form" : formName,
                                                                       @"redirect_uri" : redirectUri,
                                                                       @"response_type" : @"token",
                                                                       @"refresh_secret" : refreshSecret
                                                               }];

    if (bpChannelUrl) [params setObject:bpChannelUrl forKey:@"bp_channel"];
    if (flowName) [params setObject:flowName forKey:@"flow_name"];
    if (mergeToken) [params setObject:mergeToken forKey:@"merge_token"];

    NSString *const signInEndpoint = [NSString stringWithFormat:@"%@/oauth/auth_native_traditional.json",
                                                                [[JRCaptureData sharedCaptureData] captureBaseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:signInEndpoint]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[params asJRURLParamString] dataUsingEncoding:NSUTF8StringEncoding]];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                              cSignInUser, cTagAction,
                                              delegate, @"delegate",
                                              context, @"context", nil];

    NSString *urlString = [[request URL] absoluteString];
    DLog(@"%@ %@=%@", urlString, signInFieldName, signInName);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
    {
        NSString *desc = [NSString stringWithFormat:@"Could not create a connection to %@", urlString];
        NSNumber *code = [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection];
        NSDictionary *errDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"error", @"stat",
                                                      @"url_connection", @"error",
                                                      desc, @"error_description",
                                                      code, @"code",
                                                      nil];
        JRCaptureError *error = [JRCaptureError errorFromResult:errDict onProvider:nil engageToken:nil];
        [self finishSignInFailureWithError:error forDelegate:delegate withContext:context];
    }
}

- (void)finishGetCaptureUserWithStat:(CaptureInterfaceStat)stat andResult:(NSDictionary *)result
                         forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(getCaptureUserDidSucceedWithResult:context:)])
            [delegate getCaptureUserDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(getCaptureUserDidFailWithResult:context:)])
            [delegate getCaptureUserDidFailWithResult:result context:context];
    }
}

- (void)startGetCaptureUserWithToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate
                         withContext:(NSObject *)context
{
    DLog(@"");

    NSMutableData *body = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *entityUrl = [NSString stringWithFormat:@"%@/entity", [JRCaptureData sharedCaptureData].captureBaseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:entityUrl]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *newTag = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 cGetUser, cTagAction,
                                                 delegate, @"delegate",
                                                 context, @"context", nil];

    DLog(@"%@ access_token=%@", [[request URL] absoluteString], token);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:newTag])
    {
        NSString *errDesc = [NSString stringWithFormat:@"Could not create a connection to %@",
                                                       [[request URL] absoluteString]];
        NSNumber *errCode = [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection];
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"error", @"stat",
                                                     @"url_connection", @"error",
                                                     errDesc, @"error_description",
                                                     errCode, @"code", nil];
        [self finishGetCaptureUserWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
}

- (void)finishGetObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSDictionary *)result
                    forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(getCaptureObjectDidSucceedWithResult:context:)])
            [delegate getCaptureObjectDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(getCaptureObjectDidFailWithResult:context:)])
            [delegate getCaptureObjectDidFailWithResult:result context:context];
    }
}

- (void)startGetCaptureObjectAtPath:(NSString *)entityPath withToken:(NSString *)token
                        forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];

    if (!entityPath || [entityPath isEqualToString:@""])
    {
        ;
    }
    else
    {
        NSString *argString = [NSString stringWithFormat:@"&attribute_name=%@", entityPath];
        [body appendData:[argString dataUsingEncoding:NSUTF8StringEncoding]];
    }

    NSString *entityUrl = [NSString stringWithFormat:@"%@/entity", [JRCaptureData sharedCaptureData].captureBaseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:entityUrl]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                              cGetObject, cTagAction,
                                              delegate, @"delegate",
                                              context, @"context", nil];

    DLog(@"%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], token, entityPath);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
    {
        NSString *errDesc = [NSString stringWithFormat:@"Could not create a connection to %@",
                                                       [[request URL] absoluteString]];
        NSNumber *errCode = [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection];
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"error", @"stat",
                                                     @"url_connection", @"error",
                                                     errDesc, @"error_description",
                                                     errCode, @"code", nil];
        [self finishGetObjectWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }
}

- (void)finishUpdateObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSDictionary *)result
                       forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");

    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(updateCaptureObjectDidSucceedWithResult:context:)])
            [delegate updateCaptureObjectDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(updateCaptureObjectDidFailWithResult:context:)])
            [delegate updateCaptureObjectDidFailWithResult:result context:context];
    }
}

- (void)startUpdateObject:(NSDictionary *)captureObject atPath:(NSString *)entityPath
                withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate
              withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureObject JSONString] stringByAddingUrlPercentEscapes];
    NSMutableData *body       = [NSMutableData data];

    NSString *attrArgString = [NSString stringWithFormat:@"&attributes=%@", attributes];
    [body appendData:[attrArgString dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&include_record=true" dataUsingEncoding:NSUTF8StringEncoding]];

    if (!entityPath || [entityPath isEqualToString:@""])
    {
        ;
    }
    else
    {
        NSString *attrNameArgString = [NSString stringWithFormat:@"&attribute_name=%@", entityPath];
        [body appendData:[attrNameArgString dataUsingEncoding:NSUTF8StringEncoding]];
    }

    NSString *updateUrl = [NSString stringWithFormat:@"%@/entity.update",
                                                     [JRCaptureData sharedCaptureData].captureBaseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:updateUrl]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                              cUpdateObject, cTagAction,
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ attributes=%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], attributes, token, 
        entityPath);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
    {
        NSString *errDesc = [NSString stringWithFormat:@"Could not create a connection to %@",
                                                       [[request URL] absoluteString]];
        NSNumber *errCode = [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection];
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"error", @"stat",
                                                     @"url_connection", @"error",
                                                     errDesc, @"error_description",
                                                     errCode, @"code", nil];
        [self finishUpdateObjectWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }

}

- (void)finishReplaceObjectWithStat:(CaptureInterfaceStat)stat andResult:(NSDictionary *)result
                        forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");
    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureObjectDidSucceedWithResult:context:)])
            [delegate replaceCaptureObjectDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureObjectDidFailWithResult:context:)])
            [delegate replaceCaptureObjectDidFailWithResult:result context:context];
    }
}

- (void)startReplaceObject:(NSDictionary *)captureObject atPath:(NSString *)entityPath
                 withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate
               withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureObject JSONString] stringByAddingUrlPercentEscapes];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&include_record=true" dataUsingEncoding:NSUTF8StringEncoding]];

    if (!entityPath || [entityPath isEqualToString:@""])
    {
        ;
    }
    else
    {
        NSString *argString = [NSString stringWithFormat:@"&attribute_name=%@", entityPath];
        [body appendData:[argString dataUsingEncoding:NSUTF8StringEncoding]];        
    }

    NSString *replaceUrl = [NSString stringWithFormat:@"%@/entity.replace",
                                                      [JRCaptureData sharedCaptureData].captureBaseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:replaceUrl]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                              cReplaceObject, cTagAction,
                                        delegate, @"delegate",
                                        context, @"context", nil];

    DLog(@"%@ attributes=%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], attributes, token, 
    entityPath);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
    {
        NSString *errDesc = [NSString stringWithFormat:@"Could not create a connection to %@",
                                                      [[request URL] absoluteString]];
        NSNumber *errCode = [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection];
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"error", @"stat",
                                                     @"url_connection", @"error",
                                                     errDesc, @"error_description",
                                                     errCode, @"code", nil];
        [self finishReplaceObjectWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }

}

- (void)finishReplaceArrayWithStat:(CaptureInterfaceStat)stat andResult:(NSDictionary *)result
                       forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");
    if (stat == StatOk)
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureArrayDidSucceedWithResult:context:)])
            [delegate replaceCaptureArrayDidSucceedWithResult:result context:context];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(replaceCaptureArrayDidFailWithResult:context:)])
            [delegate replaceCaptureArrayDidFailWithResult:result context:context];
    }
}

- (void)startReplaceArray:(NSArray *)captureArray atPath:(NSString *)entityPath
                withToken:(NSString *)token forDelegate:(id <JRCaptureInterfaceDelegate>)delegate 
              withContext:(NSObject *)context
{
    DLog(@"");

    NSString      *attributes = [[captureArray JSONString] stringByAddingUrlPercentEscapes];
    NSMutableData *body       = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"&attributes=%@", attributes] 
            dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&access_token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"&include_record=true" dataUsingEncoding:NSUTF8StringEncoding]];

    if (!entityPath || [entityPath isEqualToString:@""]) 
    {
        ;
    }
    else
    {
        NSString *argString = [NSString stringWithFormat:@"&attribute_name=%@", entityPath];
        [body appendData:[argString dataUsingEncoding:NSUTF8StringEncoding]];
    }

    NSString *captureBaseUrl = [JRCaptureData sharedCaptureData].captureBaseUrl;
    NSString *replaceUrl = [NSString stringWithFormat:@"%@/entity.replace", captureBaseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:replaceUrl]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                              cReplaceArray, cTagAction,
                                              delegate, @"delegate",
                                              context, @"context", nil];

    DLog(@"%@ attributes=%@ access_token=%@ attribute_name=%@", [[request URL] absoluteString], attributes, token, 
        entityPath);

    /* tag vs context for workaround */
    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag]) 
    {
        NSString *errDesc = [NSString stringWithFormat:@"Could not create a connection to %@",
                                                      [[request URL] absoluteString]];
        NSNumber *code = [NSNumber numberWithInteger:JRCaptureLocalApidErrorUrlConnection];
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"error", @"stat",
                                                     @"url_connection", @"error",
                                                     errDesc, @"error_description",
                                                     code, @"code", nil];
        [self finishReplaceArrayWithStat:StatFail andResult:result forDelegate:delegate withContext:context];
    }

}

+ (void)signinCaptureUserWithCredentials:(NSDictionary *)credentials ofType:(NSString *)signInType
                             forDelegate:(id)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startSigninCaptureUserWithCredentials:credentials ofType:signInType forDelegate:delegate
                                      withContext:context];

}

+ (void)getCaptureUserWithToken:(NSString *)token
                    forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startGetCaptureUserWithToken:token forDelegate:delegate withContext:context];
}

+ (void)getCaptureObjectAtPath:(NSString *)entityPath withToken:(NSString *)token
                   forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context __unused
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startGetCaptureObjectAtPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

+ (void)updateCaptureObject:(NSDictionary *)captureObject atPath:(NSString *)entityPath withToken:(NSString *)token
                forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    DLog(@"");
    [[JRCaptureApidInterface captureInterfaceInstance]
            startUpdateObject:captureObject atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

+ (void)replaceCaptureObject:(NSDictionary *)captureObject atPath:(NSString *)entityPath withToken:(NSString *)token
                 forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startReplaceObject:captureObject atPath:entityPath withToken:token forDelegate:delegate 
                   withContext:context];
}

+ (void)replaceCaptureArray:(NSArray *)captureArray atPath:(NSString *)entityPath withToken:(NSString *)token
                forDelegate:(id <JRCaptureInterfaceDelegate>)delegate withContext:(NSObject *)context
{
    [[JRCaptureApidInterface captureInterfaceInstance]
            startReplaceArray:captureArray atPath:entityPath withToken:token forDelegate:delegate withContext:context];
}

- (void)connectionDidFinishLoadingWithPayload:(NSString *)payload request:(NSURLRequest*)request andTag:(id)userData
{
    DLog(@"%@", payload);

    NSDictionary *tag       = (NSDictionary *) userData;
    NSString     *action    = [tag objectForKey:cTagAction];
    NSObject     *context   = [tag objectForKey:@"context"];

    NSDictionary *response    = [payload objectFromJSONString];
    CaptureInterfaceStat stat = [[response objectForKey:@"stat"] isEqualToString:@"ok"] ? StatOk : StatFail;

    id<JRCaptureInterfaceDelegate> delegate = [tag objectForKey:@"delegate"];

    if ([action isEqualToString:cSignInUser])
    {
        [self finishSignInUserWithPayload:payload context:context response:response stat:stat delegate:delegate];
    }
    else if ([action isEqualToString:cGetUser])
    {
        [self finishGetCaptureUserWithStat:stat andResult:response forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:cGetObject])
    {
        [self finishGetObjectWithStat:stat andResult:response forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:cUpdateObject])
    {
        [self finishUpdateObjectWithStat:stat andResult:response forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:cReplaceObject])
    {
        [self finishReplaceObjectWithStat:stat andResult:response forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:cReplaceArray])
    {
        [self finishReplaceArrayWithStat:stat andResult:response forDelegate:delegate withContext:context];
    }
}

- (void)finishSignInUserWithPayload:(NSString *)payload context:(NSObject *)context response:(NSDictionary *)response
                               stat:(CaptureInterfaceStat)stat delegate:(id <JRCaptureInterfaceDelegate>)delegate
{
    if (stat == StatOk)
        [self finishSignInSuccessWithResult:payload forDelegate:delegate withContext:context];
    else
    {
        JRCaptureError *error = [JRCaptureError errorFromResult:response onProvider:nil engageToken:nil];
        [self finishSignInFailureWithError:error forDelegate:delegate withContext:context];
    }
}

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse*)fullResponse unencodedPayload:(NSData*)payload
                                           request:(NSURLRequest*)request andTag:(id)userData { }

- (void)connectionDidFailWithError:(NSError *)error request:(NSURLRequest*)request andTag:(id)userData
{
    DLog(@"");

    NSDictionary *tag       = (NSDictionary*) userData;
    NSString     *action    = [tag objectForKey:cTagAction];
    NSObject     *context   = [tag objectForKey:@"context"];
    id<JRCaptureInterfaceDelegate> delegate = [tag objectForKey:@"delegate"];

    NSDictionary *errDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"error", @"stat",
                                    [error localizedDescription], @"error",
                                    [error localizedFailureReason], @"error_description",
                                    [NSNumber numberWithInteger:JRCaptureLocalApidErrorConnectionDidFail], @"code",
                                    error, @"wrapped_error",
                                    nil];

    JRCaptureError *wrappingError = [JRCaptureError errorFromResult:errDict onProvider:nil engageToken:nil];

    if ([action isEqualToString:cSignInUser])
    {
        [self finishSignInFailureWithError:wrappingError forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:cGetUser])
    {
        [self finishGetCaptureUserWithStat:StatFail andResult:errDict forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:cGetObject])
    {
        [self finishGetObjectWithStat:StatFail andResult:errDict forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:cUpdateObject])
    {
        [self finishUpdateObjectWithStat:StatFail andResult:errDict forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:cReplaceObject])
    {
        [self finishReplaceObjectWithStat:StatFail andResult:errDict forDelegate:delegate withContext:context];
    }
    else if ([action isEqualToString:cReplaceArray])
    {
        [self finishReplaceArrayWithStat:StatFail andResult:errDict forDelegate:delegate withContext:context];
    }
}

+ (FinishSignInError)finishSignInWithPayload:(NSDictionary *)payloadDict
                                 forDelegate:(id<JRCaptureSigninDelegate>)delegate
{
    NSString *accessToken   = [payloadDict objectForKey:@"access_token"];
    BOOL      isNew         = [(NSNumber*)[payloadDict objectForKey:@"is_new"] boolValue];

    NSDictionary *captureProfile = [payloadDict objectForKey:@"capture_user"];

    if (!captureProfile || !(accessToken)) return cJRInvalidResponse;

    JRCaptureUser *captureUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];

    if (!captureUser) return cJRInvalidCaptureUser;

    if (accessToken)
        [JRCaptureData setAccessToken:accessToken];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    JRCaptureRecordStatus recordStatus;

    if (isNew)
        recordStatus = JRCaptureRecordNewlyCreated;
    else
        recordStatus = JRCaptureRecordExists;

    if ([delegate respondsToSelector:@selector(captureAuthenticationDidSucceedForUser:status:)])
        [delegate captureAuthenticationDidSucceedForUser:captureUser status:recordStatus];

    return cJRNoError;
}

- (void)connectionWasStoppedWithTag:(id)userData { }
@end
