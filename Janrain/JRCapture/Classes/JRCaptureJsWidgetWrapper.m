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
+ (void)startJsWidget
{
    NSString *url = @"http://nathan.janrain.com/capture_widget/index_embedded_mobile.php";
    [[JRUserInterfaceMaestro sharedMaestro] showCaptureJsWidgetDialogWithCustomInterface:nil andUrl:url];
}
@end