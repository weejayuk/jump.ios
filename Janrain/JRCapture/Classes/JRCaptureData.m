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

#import "JRCaptureData.h"
#import "SFHFKeychainUtils.h"
#import "NSMutableDictionary+get_params.h"

#define cJRCaptureKeychainIdentifier @"capture_tokens.janrain"
#define cJRCaptureKeychainUserName @"capture_user"

@implementation NSString (JRString_UrlWithDomain)
- (NSString *)urlStringFromBaseDomain
{
    if ([self hasPrefix:@"https://"])
        return self;

    if ([self hasPrefix:@"http://"])
        return [self stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];

    return [@"https://" stringByAppendingString:self];
}
@end

static NSString* applicationBundleDisplayNameAndIdentifier()
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoPlist objectForKey:@"CFBundleDisplayName"];
    NSString *ident = [infoPlist objectForKey:@"CFBundleIdentifier"];

    return [NSString stringWithFormat:@"%@.%@", name, ident];
}

typedef enum
{
    JRTokenTypeAccess,
    JRTokenTypeCreation,
} JRTokenType;

@interface JRCaptureData ()
+ (NSString *)retrieveTokenFromKeychainOfType:(JRTokenType)tokenType;

@property(nonatomic, retain) NSString *captureBaseUrl;
@property(nonatomic, retain) NSString *clientId;
@property(nonatomic, retain) NSString *accessToken;
@property(nonatomic, retain) NSString *creationToken;
@property(nonatomic, retain) NSString *captureLocale;
@property(nonatomic, retain) NSString *captureFormName;
@property(nonatomic, retain) NSString *captureFlowName;
@property(nonatomic) JRConventionalSigninType captureTradSignInType;


@end

@implementation JRCaptureData
static JRCaptureData *singleton = nil;

@synthesize clientId;
@synthesize captureBaseUrl;
@synthesize accessToken;
@synthesize creationToken;
@synthesize bpChannelUrl;
@synthesize captureLocale;
@synthesize captureFormName;
@synthesize captureTradSignInType;
@synthesize captureFlowName;


- (JRCaptureData *)init
{
    if ((self = [super init]))
    {
        accessToken   = [[JRCaptureData retrieveTokenFromKeychainOfType:JRTokenTypeAccess] retain];
        creationToken = [[JRCaptureData retrieveTokenFromKeychainOfType:JRTokenTypeCreation] retain];
    }

    return self;
}

+ (JRCaptureData *)sharedCaptureData
{
    if (singleton == nil) {
        singleton = [((JRCaptureData*)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedCaptureData] retain];
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

+ (NSString *)captureMobileEndpointUrlWithMergeToken:(NSString *)mergeToken
{
    /**
    * client_id
    * locale
    * response_type
    * redirect_uri
    * token
    * attributeUpdates
    * thin_registration
    * flow_name
    * token
    */

    JRCaptureData *captureData = [JRCaptureData sharedCaptureData];
    NSString *redirectUri = [singleton redirectUri];
    NSMutableDictionary *urlArgs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                captureData.clientId, @"client_id",
                                                                captureData.captureLocale, @"locale",
                                                                @"token", @"response_type",
                                                                redirectUri, @"redirect_uri",
                                                                @"true", @"thin_registration",
                                                                nil];

    if (captureData.captureFlowName) [urlArgs setObject:captureData.captureFlowName forKey:@"flow_name"];
    if (captureData.bpChannelUrl) [urlArgs setObject:captureData.bpChannelUrl forKey:@"bp_channel"];
    if (mergeToken) [urlArgs setObject:mergeToken forKey:@"merge_token"];

    NSString *getParams = [urlArgs asGetParamString];
    return [NSString stringWithFormat:@"%@/oauth/auth_native?%@", captureData.captureBaseUrl, getParams];
}

- (NSString *)redirectUri
{
    return [NSString stringWithFormat:@"%@/cmeu", singleton.captureBaseUrl];
}

+ (void)    setCaptureDomain:(NSString *)captureDomain captureClientId:(NSString *)clientId
               captureLocale:(NSString *)captureLocale captureFormName:(NSString *)captureFormName
             captureFlowName:(NSString *)captureFlowName
captureTraditionalSignInType:(JRConventionalSigninType) tradSignInType;
{
    JRCaptureData *captureDataInstance = [JRCaptureData sharedCaptureData];

    captureDataInstance.captureBaseUrl = [captureDomain urlStringFromBaseDomain];
    captureDataInstance.clientId = clientId;
    captureDataInstance.captureLocale = captureLocale;
    captureDataInstance.captureFormName = captureFormName;
    captureDataInstance.captureFlowName = captureFlowName;
    captureDataInstance.captureTradSignInType = tradSignInType;
}

+ (NSString *)serviceNameForTokenType:(JRTokenType)tokenType
{
    return [NSString stringWithFormat:@"%@.%@.%@.",
                cJRCaptureKeychainIdentifier,
                (tokenType == JRTokenTypeAccess ? @"access_token" : @"creation_token"),
                applicationBundleDisplayNameAndIdentifier()];
}

+ (void)deleteTokenFromKeychainOfType:(JRTokenType)tokenType
{
    [SFHFKeychainUtils deleteItemForUsername:cJRCaptureKeychainUserName
                              andServiceName:[JRCaptureData serviceNameForTokenType:tokenType]
                                       error:nil];
}

+ (void)storeTokenInKeychain:(NSString *)token ofType:(JRTokenType)tokenType
{
    NSError  *error = nil;

    [SFHFKeychainUtils storeUsername:cJRCaptureKeychainUserName
                         andPassword:token
                      forServiceName:[JRCaptureData serviceNameForTokenType:tokenType]
                      updateExisting:YES
                               error:&error];

    if (error)
        ALog (@"Error storing device token in keychain: %@", [error localizedDescription]);
}

+ (NSString *)retrieveTokenFromKeychainOfType:(JRTokenType)tokenType
{
    NSString *token = [SFHFKeychainUtils getPasswordForUsername:cJRCaptureKeychainUserName
                                                 andServiceName:[JRCaptureData serviceNameForTokenType:tokenType]
                                                          error:nil];

    return token;
}

+ (void)saveNewToken:(NSString *)token ofType:(JRTokenType)tokenType
{
    [JRCaptureData deleteTokenFromKeychainOfType:JRTokenTypeAccess];
    [JRCaptureData deleteTokenFromKeychainOfType:JRTokenTypeCreation];

    if (tokenType == JRTokenTypeAccess)
    {
        [JRCaptureData sharedCaptureData].accessToken = token;
        [JRCaptureData sharedCaptureData].creationToken = nil;

        [JRCaptureData storeTokenInKeychain:token ofType:JRTokenTypeAccess];
    }
    else
    {
        [JRCaptureData sharedCaptureData].creationToken = token;
        [JRCaptureData sharedCaptureData].accessToken = nil;

        [JRCaptureData storeTokenInKeychain:token ofType:JRTokenTypeCreation];
    }
}

+ (void)setAccessToken:(NSString *)newAccessToken
{
    [JRCaptureData saveNewToken:newAccessToken ofType:JRTokenTypeAccess];
}

+ (NSString *)getAccessToken
{
    return [JRCaptureData sharedCaptureData].accessToken;
}

+ (void)setCreationToken:(NSString *)newCreationToken
{
    [JRCaptureData saveNewToken:newCreationToken ofType:JRTokenTypeCreation];
}

+ (NSString *)accessToken
{
    return [[JRCaptureData sharedCaptureData] accessToken];
}

+ (NSString *)creationToken
{
    return [[JRCaptureData sharedCaptureData] creationToken];
}

+ (NSString *)captureBaseUrl
{
    return [[JRCaptureData sharedCaptureData] captureBaseUrl];
}

+ (NSString *)clientId
{
    return [[JRCaptureData sharedCaptureData] clientId];
}

- (void)dealloc
{
    [clientId release];
    [accessToken release];
    [creationToken release];
    [captureBaseUrl release];
    [captureFlowName release];
    [captureLocale release];
    [captureFormName release];
    [bpChannelUrl release];
    [super dealloc];
}

+ (void)clearSignInState
{
    DLog(@"");
    [JRCaptureData deleteTokenFromKeychainOfType:JRTokenTypeAccess];
    [JRCaptureData deleteTokenFromKeychainOfType:JRTokenTypeCreation];
    [JRCaptureData sharedCaptureData].accessToken = nil;
    [JRCaptureData sharedCaptureData].creationToken = nil;
}

+ (void)setBackplaneChannelUrl:(NSString *)bpChannelUrl
{
    [JRCaptureData sharedCaptureData].bpChannelUrl = bpChannelUrl;
}
@end
