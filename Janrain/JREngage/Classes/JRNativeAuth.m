#import <objc/message.h>
#import "JRNativeAuth.h"
#import "debug_log.h"
#import "JRConnectionManager.h"
#import "JRSessionData.h"
#import "JREngageError.h"

@implementation JRNativeAuth
static Class fbSession;
static SEL activeSessionSel;
static SEL stateSel;
static SEL accessTokenDataSel;
static SEL accessTokenSel;
static SEL openActiveSessionWithReadPermissionsSel;

+ (void)initGlobals
{
    fbSession = NSClassFromString(@"FBSession");
    activeSessionSel = NSSelectorFromString(@"activeSession");
    stateSel = NSSelectorFromString(@"state");
    accessTokenDataSel = NSSelectorFromString(@"accessTokenData");
    accessTokenSel = NSSelectorFromString(@"accessToken");
    openActiveSessionWithReadPermissionsSel =
                NSSelectorFromString(@"openActiveSessionWithReadPermissions:allowLoginUI:completionHandler:");
}

+ (BOOL)canHandlerProvider:(NSString *)provider
{
    if ([provider isEqual:@"facebook"]) return YES;
    return NO;
}

+ (void)authOnProvider:(NSString *)provider completion:(void (^)(id, NSError *))completion
{
    if ([provider isEqual:@"facebook"])
    {
        [self fbNativeAuthWithCompletion:completion];
    }
}

+ (void)fbNativeAuthWithCompletion:(void (^)(id, NSError *))completion
{
    [self initGlobals];

    id fbActiveSession = [fbSession performSelector:activeSessionSel];
    int64_t fbState = (BOOL) [fbActiveSession performSelector:stateSel]; //[FBSession activeSession].state;

    //#define FB_SESSIONSTATEOPENBIT (1 << 9)
    if (fbState & 1<<9)
    {
        id accessToken = [self getAccessToken:fbActiveSession];
        [self processAccessToken:accessToken completion:completion];
    }
    else
    {
        void (^handler)(id, BOOL, NSError *) =
                ^(id session, BOOL status, NSError *error)
                {
                    DLog(@"session %@ status %i error %@", session, status, error);
                    id accessToken = [self getAccessToken:session];
                    [self processAccessToken:accessToken completion:completion];
                };
        objc_msgSend(fbSession, openActiveSessionWithReadPermissionsSel, @[], YES, handler);
    }
}

+ (void)processAccessToken:(id)token completion:(void (^)(id, NSError *))completion
{
    DLog(@"token %@", token);
    if (![token isKindOfClass:[NSString class]])
    {
        completion(nil, [NSError errorWithDomain:JREngageErrorDomain code:JRAuthenticationNativeAuthError
                                        userInfo:nil]);
        return;
    }

    NSString *url = [[JRSessionData jrSessionData].baseUrl stringByAppendingString:@"/signin/oauth_token"];
    NSDictionary *params = @{@"token" : token, @"provider" : @"facebook"};

    void (^responseHandler)(id, NSError *) = ^(id o, NSError *error)
    {
        completion(o, error);
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