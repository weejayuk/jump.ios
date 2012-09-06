//
// Created by nathan on 8/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "JRCaptureJsWidgetWrapper.h"
#import "JRUserInterfaceMaestro.h"


@implementation JRCaptureJsWidgetWrapper

+ (void)startJsWidget
{
    NSString *url = @"http://nathan.janrain.com/capture_widget/index_embedded_mobile.php";
    [[JRUserInterfaceMaestro sharedMaestro] showCaptureJsWidgetDialogWithCustomInterface:nil andUrl:url];
}


@end