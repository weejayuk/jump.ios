/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

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

 File:   JRWebViewController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JRCaptureWebViewController.h"
#import "debug_log.h"
#import "JRUserInterfaceMaestro.h"

#ifdef DEBUG

@interface DebugWebDelegate : NSObject
@end

@class WebView;
@class WebScriptCallFrame;
@class WebFrame;

@implementation DebugWebDelegate
- (void)webView:(WebView *)webView exceptionWasRaised:(WebScriptCallFrame *)frame
       sourceId:(int)sid
           line:(int)lineno
    forWebFrame:(WebFrame *)webFrame
{
    NSLog(@"NSDD: exception: sid=%d line=%d function=%@, caller=%@, exception=%@",
          sid, lineno, [frame functionName], [[frame caller] description], [[frame exception] description]);
}
@end

@interface DebugWebView : UIWebView
{
    id windowScriptObject;
    id privateWebView;
}
@end

@implementation DebugWebView
- (void)webView:(id)sender didClearWindowObject:(id)windowObject forFrame:(WebFrame*)frame
{
    [sender setScriptDebugDelegate:[[DebugWebDelegate alloc] init]];
}
@end

#endif

@implementation JRCaptureWebViewController

@synthesize webView;
@synthesize url;

- (id)initWithUrl:(NSString *)urlString
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        self.url = [NSURL URLWithString:urlString];
    }

    return self;
}

- (void)viewDidLoad
{
    DLog(@"");
    [super viewDidLoad];

    if (!self.navigationController.navigationBar.backItem)
    {
        DLog(@"no back button");
        UIBarButtonItem *cancelButton =
                [[[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self
                                             action:@selector(cancelButton)] autorelease];

        self.navigationItem.rightBarButtonItem         = cancelButton;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.style   = UIBarButtonItemStyleBordered;
    }
    else
    {
        DLog(@"back button");
    }
}

- (void)cancelButton
{
    [[JRUserInterfaceMaestro sharedMaestro] unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");

    [super viewWillAppear:animated];

    self.title = [NSString stringWithFormat:@"%@", @"fixme"];


    #ifdef DEBUG
        self.webView = [[[DebugWebView alloc] initWithFrame:self.view.frame] autorelease];
    #else
        self.webView = [[[UIWebView alloc] initWithFrame:self.view.frame] autorelease];
    #endif
    [self.view addSubview:webView];
    webView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"");
    [super viewDidAppear:animated];

    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [webView becomeFirstResponder];
}

- (void)startProgress
{
    ([UIApplication sharedApplication]).networkActivityIndicatorVisible = YES;
}

- (void)stopProgress
{
    if ([JRConnectionManager openConnections] == 0)
    {
        ([UIApplication sharedApplication]).networkActivityIndicatorVisible = NO;
    }
}

- (BOOL)webView:(UIWebView *)webView_ shouldStartLoadWithRequest:(NSURLRequest *)request
                                                 navigationType:(UIWebViewNavigationType)navigationType
{
    //if ([[[request URL] absoluteString] hasPrefix:])
    //{
    //    return NO;
    //}

    NSString *requestString = [[[request URL] absoluteString]
            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if ([requestString hasPrefix:@"ios-log:"])
    {
        NSString* logString = [[requestString componentsSeparatedByString:@":#iOS#"] objectAtIndex:1];
        DLog(@"UIWebView console: %@", logString);
        return NO;
    }

    DLog(@"request: %@", [[request URL] absoluteString]);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSString *consoleDotLog = @"console = new Object();\n"
            "console.log = function(log) {\n"
            "  var iframe = document.createElement(\"IFRAME\");\n"
            "  iframe.setAttribute(\"src\", \"ios-log:#iOS#\" + log);\n"
            "  document.documentElement.appendChild(iframe);\n"
            "  iframe.parentNode.removeChild(iframe);\n"
            "  iframe = null;\n"
            "}\n"
            "console.debug = console.log;\n"
            "console.info = console.log;\n"
            "console.warn = console.log;\n"
            "console.error = console.log;";
    DLog(@"Loaded console.log: \"%@\"", [webView stringByEvaluatingJavaScriptFromString:consoleDotLog]);
    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"");
    [self stopProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"");
    DLog(@"error message: %@", [error localizedDescription]);

    if (error.code != NSURLErrorCancelled) /* Error code -999 */
    {
        [self stopProgress];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    DLog(@"");

    [webView stopLoading];

    [self stopProgress];

    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DLog(@"");

    [webView loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];

    [super viewDidDisappear:animated];
}

- (void)dealloc {
    DLog(@"");

    [url release];
    [webView release];
    [super dealloc];
}
@end
