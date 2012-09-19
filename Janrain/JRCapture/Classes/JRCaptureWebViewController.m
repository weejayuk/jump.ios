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

@implementation JRCaptureWebViewController

//@interface JREngageError (JREngageError_setError)
//+ (NSError*)setError:(NSString*)message withCode:(NSInteger)code;
//@end

@synthesize webView;
@synthesize url;

- (id)initWithUrl:(NSString *)urlString
{
    if (self = [super init])
    {
        self.url = [NSURL URLWithString:urlString];
        self.webView = [[[UIWebView alloc] initWithFrame:self.view.frame] autorelease];
        [self.view addSubview:webView];
    }

    return self;
}

- (void)viewDidLoad
{
    DLog(@"");
    [super viewDidLoad];

    //self.navigationItem.backBarButtonItem.target = sessionData;
    //self.navigationItem.backBarButtonItem.action = @selector(triggerAuthenticationDidStartOver:);

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
    DLog(@"CANCEL");
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");

    [super viewWillAppear:animated];

    self.contentSizeForViewInPopover = CGSizeMake(320, 416);

    self.title = [NSString stringWithFormat:@"%@", @"fixme"];
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
    DLog(@"request: %@", [[request URL] absoluteString]);

    //NSString *mobileEndpointUrl = [NSString stringWithFormat:@"%@/signin/device", [sessionData baseUrl]];

    //if ([[[request URL] absoluteString] hasPrefix:mobileEndpointUrl])
    //{
    //    DLog(@"request url has prefix: %@", [sessionData baseUrl]);
    //
    //    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:MEU_CONNECTION_TAG];
    //
    //    keepProgress = YES;
    //    return NO;
    //}

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DLog(@"");
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

        //NSError *newError = [JREngageError setError:[NSString stringWithFormat:@"Authentication failed: %@",
        //                                                      [error localizedDescription]]
        //                                   withCode:JRAuthenticationFailedError];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    DLog(@"");

    [webView stopLoading];

    //[JRConnectionManager stopConnectionsForDelegate:self];
    [self stopProgress];

    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DLog(@"");

    [webView loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];

    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    DLog(@"");
    [super viewDidUnload];
}

- (void)dealloc {
    DLog(@"");

    [url release];
    [webView release];
    [super dealloc];
}
@end
