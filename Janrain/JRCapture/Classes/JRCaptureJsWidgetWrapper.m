//
// Created by nathan on 8/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "JRCaptureJsWidgetWrapper.h"
#import "JRUserInterfaceMaestro.h"
#import "debug_log.h"
#import "JRSessionData.h"
#import "JRCaptureWebViewController.h"

@interface JRUserInterfaceMaestro (JRCaptureWidget_Extras)
- (void)showCaptureJsWidgetDialogWithCustomInterface:(NSDictionary *)customUi andUrl:(NSString *)url;
@end

@implementation JRUserInterfaceMaestro (JRCaptureWidget_Extras)
- (void)showCaptureJsWidgetDialogWithCustomInterface:(NSDictionary *)customizations andUrl:(NSString *)url
{
    DLog(@"");
    [self buildCustomInterface:customizations];
    [self setUpDialogPresentation];

    sessionData.captureWidget = YES;
    sessionData.dialogIsShowing = YES;

    JRCaptureWebViewController *viewController = [[[JRCaptureWebViewController alloc] initWithUrl:url] autorelease];

    if (usingAppNav)
        [self loadApplicationNavigationControllerWithViewController:viewController];
    else
        [self loadModalNavigationControllerWithViewController:viewController];
}
@end

@implementation JRCaptureJsWidgetWrapper
+ (void)startJsWidgetWithUrl:(NSString *)url
{
    if (!url) url = @"https://mobile.dev.janraincapture.com/oauth/signin?redirect_uri=http://a"
            "&client_id=zc7tx83fqy68mper69mxbt5dfvd7c2jh&response_type=token";
    [[JRUserInterfaceMaestro sharedMaestro] showCaptureJsWidgetDialogWithCustomInterface:nil andUrl:url];
}
@end
