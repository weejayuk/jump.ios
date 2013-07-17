#import <objc/message.h>
#import "JRNativeAuth.h"
#import "debug_log.h"
#import "JRConnectionManager.h"
#import "JRSessionData.h"
#import "JREngageError.h"

@implementation JRNativeAuth
static Class fbSession = nil;
static SEL activeSessionSel = nil;
static SEL stateSel = nil;
static SEL accessTokenDataSel = nil;
static SEL accessTokenSel = nil;
static SEL openActiveSessionWithReadPermissionsSel = nil;
static SEL appIdSel = nil;

+ (void)initGlobals
{
    if (fbSession != nil) return;
    fbSession = NSClassFromString(@"FBSession");
    activeSessionSel = NSSelectorFromString(@"activeSession");
    stateSel = NSSelectorFromString(@"state");
    accessTokenDataSel = NSSelectorFromString(@"accessTokenData");
    accessTokenSel = NSSelectorFromString(@"accessToken");
    openActiveSessionWithReadPermissionsSel =
            NSSelectorFromString(@"openActiveSessionWithReadPermissions:allowLoginUI:completionHandler:");
    appIdSel = NSSelectorFromString(@"appID");
}

+ (BOOL)canHandleProvider:(NSString *)provider
{
    [self initGlobals];
    if ([provider isEqual:@"facebook"] && fbSession != nil) return YES;
    return NO;
}

+ (id)fbSessionAppId
{
    return [fbSession performSelector:appIdSel];
}

+ (void)startAuthOnProvider:(NSString *)provider completion:(void (^)(NSError *))completion
{
    if ([provider isEqual:@"facebook"])
    {
        [self fbNativeAuthWithCompletion:completion];
    }
}

+ (void)fbNativeAuthWithCompletion:(void (^)(NSError *))completion
{
    [self initGlobals];

    id fbActiveSession = [fbSession performSelector:activeSessionSel];
    int64_t fbState = (BOOL) [fbActiveSession performSelector:stateSel]; //[FBSession activeSession].state;

    //#define FB_SESSIONSTATEOPENBIT (1 << 9)
    if (fbState & (1 << 9))
    {
        id accessToken = [self getAccessToken:fbActiveSession];
        [self getAuthInfoTokenForAccessToken:accessToken onProvider:@"facebook" completion:completion];
    }
    else
    {
        void (^handler)(id, BOOL, NSError *) =
                ^(id session, BOOL status, NSError *error)
                {
                    DLog(@"session %@ status %i error %@", session, status, error);
                    id accessToken = [self getAccessToken:session];
                    [self getAuthInfoTokenForAccessToken:accessToken onProvider:@"facebook" completion:completion];
                };
        objc_msgSend(fbSession, openActiveSessionWithReadPermissionsSel, @[], YES, handler);
    }
}

+ (void)getAuthInfoTokenForAccessToken:(id)token onProvider:(NSString *)provider
                            completion:(void (^)(NSError *))completion
{
    DLog(@"token %@", token);
    if (![token isKindOfClass:[NSString class]])
    {
        NSError *error = [NSError errorWithDomain:JREngageErrorDomain code:JRAuthenticationNativeAuthError
                                       userInfo:nil];
        DLog(@"Native auth error: %@", error);
        completion(error);
        return;
    }

    NSString *url = [[JRSessionData jrSessionData].baseUrl stringByAppendingString:@"/signin/oauth_token"];
    NSDictionary *params = @{@"token" : token, @"provider" : provider};


    void (^responseHandler)(id, NSError *) = ^(id result, NSError *error)
    {
        NSString *authInfoToken;
        if (error || ![result isKindOfClass:[NSDictionary class]]
                || ![[((NSDictionary *) result) objectForKey:@"stat"] isEqual:@"ok"]
                || ![authInfoToken = [((NSDictionary *) result) objectForKey:@"token"] isKindOfClass:[NSString class]])
        {
            NSObject *error_ = error; if (error_ == nil) error_ = [NSNull null];
            NSObject *result_ = result; if (result_ == nil) result_ = [NSNull null];
            NSError *nativeAuthError = [NSError errorWithDomain:JREngageErrorDomain
                                                           code:JRAuthenticationNativeAuthError
                                                       userInfo:@{@"result": result_, @"error": error_}];
            DLog(@"Native auth error: %@", nativeAuthError);
            completion(nativeAuthError);
            return;
        }

        JRSessionData *sessionData = [JRSessionData jrSessionData];
        [sessionData setCurrentProvider:[sessionData getProviderNamed:provider]];
        [sessionData triggerAuthenticationDidCompleteWithPayload:@{
                @"rpx_result" : @{@"token" : authInfoToken},
                @"auth_info" : @{}
        }];

        completion(nil);
    };
    [JRConnectionManager jsonRequestToUrl:url params:params completionHandler:responseHandler];
}

+ (id)getAccessToken:(id)fbActiveSession
{
    id accessTokenData = [fbActiveSession performSelector:accessTokenDataSel];
    id accessToken = [accessTokenData performSelector:accessTokenSel];
    return accessToken;
}

@end