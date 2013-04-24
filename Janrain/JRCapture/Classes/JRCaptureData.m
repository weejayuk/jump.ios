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
#import "NSDictionary+JRQueryParams.h"

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
    NSString *identifier = [infoPlist objectForKey:@"CFBundleIdentifier"];

    return [NSString stringWithFormat:@"%@.%@", name, identifier];
}

typedef enum
{
    JRTokenTypeAccess,
    JRTokenTypeCreation,
} JRTokenType;

static NSString *const FLOW_KEY = @"JR_capture_flow";

@interface JRCaptureData ()
@property(nonatomic, retain) NSString *accessToken;
@property(nonatomic, retain) NSString *creationToken;

@property(nonatomic, retain) NSString *captureBaseUrl;
@property(nonatomic, retain) NSString *clientId;
@property(nonatomic, retain) NSString *captureAppId;
@property(nonatomic, retain) NSString *captureRedirectUri;

@property(nonatomic, retain) NSString *captureFlowName;
@property(nonatomic, retain) NSString *captureFlowVersion;
@property(nonatomic, retain) NSString *captureLocale;
@property(nonatomic, retain) NSString *captureSignInFormName;
@property(nonatomic, retain) NSString *captureRegistrationFormName;

@property(nonatomic) JRConventionalSigninType captureTradSignInType;
@property(nonatomic) BOOL captureEnableThinRegistration;

@property(nonatomic, retain) NSDictionary *captureFlow;
@end

@implementation JRCaptureData
static JRCaptureData *singleton = nil;

@synthesize clientId;
@synthesize captureBaseUrl;
@synthesize accessToken;
@synthesize creationToken;
@synthesize bpChannelUrl;
@synthesize captureLocale;
@synthesize captureSignInFormName;
@synthesize captureTradSignInType;
@synthesize captureFlowName;
@synthesize captureRegistrationFormName;
@synthesize captureFlowVersion;
@synthesize captureAppId;
@synthesize captureFlow;
@synthesize captureRedirectUri;

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
    if (singleton == nil)
    {
        singleton = [((JRCaptureData*)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedCaptureData] retain];
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

+ (NSString *)captureTokenUrlWithMergeToken:(NSString *)mergeToken
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
    NSString *thinReg = [JRCaptureData sharedCaptureData].captureEnableThinRegistration ? @"true" : @"false";
    NSMutableDictionary *urlArgs = [NSMutableDictionary dictionaryWithDictionary:
            @{
                    @"client_id" : captureData.clientId,
                    @"locale" : captureData.captureLocale,
                    @"response_type" : @"token",
                    @"redirect_uri" : redirectUri,
                    @"thin_registration" : thinReg,
                    //@"use_deprecated_attributes": @"true"
            }];

    if (captureData.captureFlowName) [urlArgs setObject:captureData.captureFlowName forKey:@"flow_name"];
    if ([captureData downloadedFlowVersion])
        [urlArgs setObject:[captureData downloadedFlowVersion] forKey:@"flow_version"];
    if (captureData.bpChannelUrl) [urlArgs setObject:captureData.bpChannelUrl forKey:@"bp_channel"];
    if (mergeToken) [urlArgs setObject:mergeToken forKey:@"merge_token"];
    if (captureData.captureRegistrationFormName) [urlArgs setObject:captureData.captureRegistrationFormName
                                                             forKey:@"registration_form"];

    NSString *getParams = [urlArgs asJRURLParamString];
    return [NSString stringWithFormat:@"%@/oauth/auth_native?%@", captureData.captureBaseUrl, getParams];
}

- (NSString *)downloadedFlowVersion
{
    id version = [captureFlow objectForKey:@"version"];
    if ([version isKindOfClass:[NSString class]]) return version;
    ALog(@"Error parsing flow version: %@", version);
    return nil;
}

- (NSString *)redirectUri
{
    if (captureRedirectUri) return captureRedirectUri;
    return [NSString stringWithFormat:@"%@/cmeu", singleton.captureBaseUrl];
}

+     (void)setCaptureDomain:(NSString *)captureDomain captureClientId:(NSString *)clientId
               captureLocale:(NSString *)captureLocale captureSignInFormName:(NSString *)captureSignInFormName
             captureFlowName:(NSString *)captureFlowName captureEnableThinRegistration:(BOOL)enableThinRegistration
captureTraditionalSignInType:(JRConventionalSigninType)tradSignInType
 captureRegistrationFormName:(NSString *)captureRegistrationFormName captureFlowVersion:(NSString *)captureFlowVersion
                captureAppId:(NSString *)captureAppId
{
    JRCaptureData *captureDataInstance = [JRCaptureData sharedCaptureData];

    captureDataInstance.captureBaseUrl = [captureDomain urlStringFromBaseDomain];
    captureDataInstance.clientId = clientId;
    captureDataInstance.captureLocale = captureLocale;
    captureDataInstance.captureSignInFormName = captureSignInFormName;
    captureDataInstance.captureFlowName = captureFlowName;
    captureDataInstance.captureEnableThinRegistration = enableThinRegistration;
    captureDataInstance.captureTradSignInType = tradSignInType;
    captureDataInstance.captureRegistrationFormName = captureRegistrationFormName;
    captureDataInstance.captureFlowVersion = captureFlowVersion;
    captureDataInstance.captureAppId = captureAppId;
    [captureDataInstance loadFlow];
    [captureDataInstance downloadFlow];
}

- (void)loadFlow
{
    self.captureFlow =
            [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:FLOW_KEY]];
}

- (void)downloadFlow
{
    NSString *flowVersion = self.captureFlowVersion ? self.captureFlowVersion : @"HEAD";

    //dlzjvycct5xka
    NSString *flowUrlString =
            [NSString stringWithFormat:@"https://dlzjvycct5xka.cloudfront.net/widget_data/flows/%@/%@/%@/%@.json",
                                       self.captureAppId, self.captureFlowName, flowVersion, self.captureLocale];
    NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:flowUrlString]];
    [downloadRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

    [NSURLConnection sendAsynchronousRequest:downloadRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *r, NSData *d, NSError *e)
                           {
                               if (e)
                               {
                                   ALog(@"Error downloading flow: %@", e);
                                   return;
                               }
                               DLog(@"Fetched flow URL: %@", flowUrlString);
                               [self processFlow:d response:(NSHTTPURLResponse *) r];
                           }];
}

- (void)processFlow:(NSData *)flowData response:(NSHTTPURLResponse *)response
{
    NSError *jsonErr = nil;
    NSObject *parsedFlow = [NSJSONSerialization JSONObjectWithData:flowData options:(NSJSONReadingOptions) 0
                                                             error:&jsonErr];

    if (jsonErr)
    {
        NSString *responseString = [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]];
        ALog(@"Error parsing flow JSON, response: %@", responseString);
        ALog(@"Error parsing flow JSON, err: %@", [jsonErr description]);
        return;
    }
    
    if (![parsedFlow isKindOfClass:[NSDictionary class]])
    {
        ALog(@"Error parsing flow JSON, top level object was not a hash...: %@", [parsedFlow description]);
        return;
    }

    self.captureFlow = (NSDictionary *) parsedFlow;
    DLog(@"Parsed flow, version: %@", [self downloadedFlowVersion]);
    
    [self writeCaptureFlow];
}

- (void)writeCaptureFlow
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:captureFlow]
                                             forKey:FLOW_KEY];
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

    if (tokenType == JRTokenTypeAccess)
    {
        [JRCaptureData sharedCaptureData].accessToken = token;

        [JRCaptureData storeTokenInKeychain:token ofType:JRTokenTypeAccess];
    }
}

+ (void)setCaptureRedirectUri:(NSString *)captureRedirectUri
{
    [JRCaptureData sharedCaptureData].captureRedirectUri = captureRedirectUri;
}

+ (void)setAccessToken:(NSString *)token
{
    [JRCaptureData saveNewToken:token ofType:JRTokenTypeAccess];
}

+ (NSString *)captureBaseUrl __unused
{
    return [[JRCaptureData sharedCaptureData] captureBaseUrl];
}

+ (NSString *)clientId __unused
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
    [captureSignInFormName release];
    [bpChannelUrl release];
    [captureRegistrationFormName release];
    [captureFlowVersion release];
    [captureRegistrationFormName release];
    [captureFlowVersion release];
    [captureAppId release];
    [captureAppId release];
    [captureFlow release];
    [captureRedirectUri release];
    [super dealloc];
}

+ (void)clearSignInState
{
    [JRCaptureData deleteTokenFromKeychainOfType:JRTokenTypeAccess];
    [JRCaptureData deleteTokenFromKeychainOfType:JRTokenTypeCreation];
    [JRCaptureData sharedCaptureData].accessToken = nil;
    [JRCaptureData sharedCaptureData].creationToken = nil;
}

+ (void)setBackplaneChannelUrl:(NSString *)bpChannelUrl __unused
{
    [JRCaptureData sharedCaptureData].bpChannelUrl = bpChannelUrl;
}
@end
