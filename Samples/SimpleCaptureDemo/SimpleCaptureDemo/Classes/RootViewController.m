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

 Author: ${USER}
 Date:   ${DATE}
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "RootViewController.h"
#import "JREngage+CustomInterface.h"
#import "CaptureProfileViewController.h"
#import "ObjectDrillDownViewController.h"
#import "JRCaptureApidInterface.h"
#import "JRCaptureJsWidgetWrapper.h"
#import "JRCaptureWebViewController.h"
#import "JRUserInterfaceMaestro.h"

@interface RootViewController ()
- (void)adjustUiState;
@end

@implementation RootViewController
@synthesize currentUserLabel;
@synthesize currentUserProviderIcon;
@synthesize browseButton;
@synthesize captureWidgetButton;
@synthesize updateButton;
@synthesize signInButton;
@synthesize signOutButton;
@synthesize shareWidgetButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([SharedData currentEmail])
        currentUserLabel.text = [NSString stringWithFormat:@"Current user: %@", [SharedData currentEmail]];
    else
        currentUserLabel.text = @"No current user";

    if ([SharedData currentProvider])
        currentUserProviderIcon.image = [UIImage imageNamed:
                     [NSString stringWithFormat:@"icon_%@_30x30@2x.png", [SharedData currentProvider]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self adjustUiState];
}

- (BOOL)isUserSignedIn
{
    return [SharedData captureUser] != nil;
}

- (void)adjustUiState
{
    if ([self isUserSignedIn])
    {
        signInButton.hidden = YES;
        signOutButton.hidden = NO;
    }
    else
    {
        signInButton.hidden = NO;
        signOutButton.hidden = YES;
    }

    //shareWidgetButton.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([SharedData currentEmail])
        currentUserLabel.text = [NSString stringWithFormat:@"Current user: %@", [SharedData currentEmail]];

    if ([SharedData currentProvider])
        currentUserProviderIcon.image = [UIImage imageNamed:
                     [NSString stringWithFormat:@"icon_%@_30x30@2x.png", [SharedData currentProvider]]];
}

- (void)setButtonsEnabled:(BOOL)enabled
{
    [browseButton setEnabled:enabled];
    [captureWidgetButton setEnabled:enabled];
    [updateButton setEnabled:enabled];
    [signInButton setEnabled:enabled];
    [signOutButton setEnabled:enabled];
}

- (IBAction)browseButtonPressed:(id)sender
{
    ObjectDrillDownViewController *drillDown =
        [[ObjectDrillDownViewController alloc] initWithNibName:@"ObjectDrillDownViewController"
                                                        bundle:[NSBundle mainBundle]
                                                     forObject:[SharedData captureUser]
                                           captureParentObject:nil
                                                        andKey:@"CaptureUser"];

    [[self navigationController] pushViewController:drillDown animated:YES];
}

- (IBAction)updateButtonPressed:(id)sender
{
    CaptureProfileViewController *viewController = [[CaptureProfileViewController alloc]
        initWithNibName:@"CaptureProfileViewController" bundle:[NSBundle mainBundle]];

    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)captureWidgetButtonPressed:(id)sender
{
    DLog(@"");
    [JRCapture startJsWidgetWithUrl:nil];
}

- (IBAction)shareButtonPressed:(id)sender
{
    DLog(@"");

    NSString *embeddedShareUrl = @"http://nathan.janrain.com/~nathan/share_widget_webview/embedded_share.html";
    [JRCapture startJsWidgetWithUrl:embeddedShareUrl];
}

- (IBAction)signInButtonPressed:(id)sender
{
    [self setButtonsEnabled:NO];
    currentUserProviderIcon.image = nil;
    
    NSDictionary *customInterface = [NSDictionary dictionaryWithObject:self.navigationController
                                                                forKey:kJRApplicationNavigationController];
    
    [SharedData startAuthenticationWithCustomInterface:customInterface forDelegate:self];
}

- (IBAction)signOutButtonPressed:(id)sender
{
    currentUserLabel.text = @"No current user";
    currentUserProviderIcon.image = nil;
    [SharedData signOutCurrentUser];
    [self adjustUiState];
}

- (void)engageSignInDidSucceed
{
    currentUserLabel.text = @"Signing in...";
    currentUserProviderIcon.image = [SharedData currentProvider] ?
            [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_30x30@2x.png", [SharedData currentProvider]]] :
            nil;
}

- (void)captureSignInDidSucceed
{
    [self setButtonsEnabled:YES];

    //[self engageSignInDidSucceed]; /* In case this method wasn't called if the user signed in directly */

    if ([SharedData currentEmail])
        currentUserLabel.text = [NSString stringWithFormat:@"Current user: %@", [SharedData currentEmail]];

    if ([SharedData isNotYetCreated] || [SharedData isNew])
    {
        CaptureProfileViewController *viewController = [[CaptureProfileViewController alloc]
            initWithNibName:@"CaptureProfileViewController" bundle:[NSBundle mainBundle]];

        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)engageSignInDidFailWithError:(NSError *)error
{
    DLog(@"error: %@", [error description]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)captureSignInDidFailWithError:(NSError *)error
{
    if ([error code] == JRCaptureErrorGenericBadPassword)
    {
        [[[UIAlertView alloc] initWithTitle:@"Access Denied" message:@"Invalid password for email@address.com"
                                  delegate:nil cancelButtonTitle:@"Dismiss"
                         otherButtonTitles:nil] show];
    }
    else
    {
        DLog(@"error: %@", [error description]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error description]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)viewDidUnload
{
    [self setShareWidgetButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
