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

#import "debug_log.h"
#import "RootViewController.h"
#import "JREngage+CustomInterface.h"
#import "CaptureProfileViewController.h"
#import "ObjectDrillDownViewController.h"
#import "AlertViewWithBlocks.h"
#import "AppDelegate.h"


@interface RootViewController ()
- (void)configureButtons;
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
@synthesize customUi = _customUi;


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.customUi = [NSMutableDictionary dictionaryWithObject:self.navigationController
                                                       forKey:kJRApplicationNavigationController];
    [self configureUserLabelAndIcon];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configureButtons];
}

- (BOOL)isUserSignedIn
{
    return appDelegate.captureUser != nil;
}

- (void)configureButtons
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [self configureUserLabelAndIcon];
}

- (IBAction)browseButtonPressed:(id)sender
{
    ObjectDrillDownViewController *drillDown =
        [[ObjectDrillDownViewController alloc] initWithNibName:@"ObjectDrillDownViewController"
                                                        bundle:[NSBundle mainBundle]
                                                     forObject:appDelegate.captureUser
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

- (IBAction)thirdButtonPressed:(id)sender
{
    //UIViewController *testModal = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    //testModal.view = ([[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]);
    //testModal.view.backgroundColor = [UIColor redColor];
    //
    //UIButton *testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[testButton addTarget:self action:@selector(signInButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //[testButton setTitle:@"Show View" forState:UIControlStateNormal];
    //testButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    //[testModal.view addSubview:testButton];
    //
    //testModal.modalPresentationStyle = UIModalPresentationFormSheet;
    //[self presentModalViewController:testModal animated:YES];
    ////[self presentViewController:testModal animated:YES completion:nil];
}

- (IBAction)signInButtonPressed:(id)sender
{
    currentUserProviderIcon.image = nil;

    [self signOutCurrentUser];

    [JRCapture startEngageSigninDialogWithConventionalSignin:JRConventionalSigninEmailPassword
                                 andCustomInterfaceOverrides:self.customUi
                                                 forDelegate:self];
}

- (IBAction)signOutButtonPressed:(id)sender
{
    currentUserLabel.text = @"No current user";
    currentUserProviderIcon.image = nil;
    [self signOutCurrentUser];
    [self configureButtons];
}

- (void)configureUserLabelAndIcon
{
    if (appDelegate.captureUser)
        currentUserLabel.text = [NSString stringWithFormat:@"Email: %@", appDelegate.captureUser.email];
    else
        currentUserLabel.text = @"No current user";
    [self configureProviderIcon];
}

- (void)configureProviderIcon
{
    NSString *icon = [NSString stringWithFormat:@"icon_%@_30x30@2x.png", appDelegate.currentProvider];
    currentUserProviderIcon.image = [UIImage imageNamed:icon];
}

- (void)captureSignInDidSucceed
{
    [self configureButtons];
    [self configureUserLabelAndIcon];

    if (appDelegate.isNotYetCreated || appDelegate.isNew)
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
    else if ([error isJRMergeFlowError])
    {
        NSString *captureAccountBrand = @"SimpleCaptureDemo";
        NSString *captureAccountBrandPhrase = @"a SimpleCaptureDemo";
        //NSString *mergeConflictedProvider = [error JRMergeFlowConflictedProvider];
        NSString *existingAccountProvider = [error JRMergeFlowExistingProvider];
        NSString *existingAccountProviderPhrase = [existingAccountProvider isEqualToString:@"capture"] ?
                @"" : [NSString stringWithFormat:@"It is associated with your %@ account. ", existingAccountProvider];

        NSString *message = [NSString stringWithFormat:@"There is already %@ account with that email address. %@ Tap "
                                                               "'Merge' to sign-in with that account, and link the "
                                                               "two.",
                                                       captureAccountBrandPhrase,
                                                       existingAccountProviderPhrase];

        void (^mergeAlertCompletion)(UIAlertView *, BOOL, NSInteger) =
                ^(UIAlertView *alertView, BOOL cancelled, NSInteger buttonIndex)
        {
            if (cancelled) return;

            if ([existingAccountProvider isEqualToString:@"capture"])
            {
                NSString *msg = [NSString stringWithFormat:@"Sign in with your %@ account", captureAccountBrand];
                void (^signInCompletion)(UIAlertView *, BOOL, NSInteger) =
                        ^(UIAlertView *alertView_, BOOL cancelled_, NSInteger buttonIndex_)
                {
                    if (cancelled_) return;
                    NSString *user = [[alertView_ textFieldAtIndex:0] text];
                    NSString *password = [[alertView_ textFieldAtIndex:1] text];
                    [JRCapture startCaptureConventionalSigninForUser:user
                                                        withPassword:password
                                                      withSigninType:JRConventionalSigninEmailPassword
                                                         forDelegate:self];
                };

                [[[AlertViewWithBlocks alloc] initWithTitle:@"Sign-in" message:msg
                                                 completion:signInCompletion
                                                      style:UIAlertViewStyleLoginAndPasswordInput
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Sign-in", nil] show];
            }
            else
            {
                [JRCapture startEngageSigninDialogOnProvider:existingAccountProvider
                                withCustomInterfaceOverrides:self.customUi
                                                 forDelegate:self];
            }
        };
        
        [[[AlertViewWithBlocks alloc] initWithTitle:@"Email address in use" message:message
                                         completion:mergeAlertCompletion
                                              style:UIAlertViewStyleDefault
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Merge", nil] show];
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


- (void)signOutCurrentUser
{
    appDelegate.currentProvider  = nil;
    appDelegate.captureUser      = nil;

    appDelegate.isNew         = NO;
    appDelegate.isNotYetCreated = NO;

    [appDelegate.prefs setObject:nil forKey:cJRCurrentProvider];
    [appDelegate.prefs setObject:nil forKey:cJRCaptureUser];

    appDelegate.engageSignInWasCanceled = NO;

    [JRCapture clearSignInState];
}

- (void)engageSigninDidNotComplete
{
    DLog(@"");
    appDelegate.engageSignInWasCanceled = YES;

    [self engageSignInDidFailWithError:nil];
}

- (void)engageSigninDialogDidFailToShowWithError:(NSError *)error
{
    DLog(@"error: %@", [error description]);
    [self engageSignInDidFailWithError:error];
}

- (void)engageAuthenticationDidFailWithError:(NSError *)error
                                 forProvider:(NSString *)provider
{
    DLog(@"error: %@", [error description]);
    [self engageSignInDidFailWithError:error];
}

- (void)captureAuthenticationDidFailWithError:(NSError *)error
{
    DLog(@"error: %@", [error description]);
    [self captureSignInDidFailWithError:error];
}

- (void)engageSigninDidSucceedForUser:(NSDictionary *)engageAuthInfo
                          forProvider:(NSString *)provider
{
    appDelegate.currentProvider = provider;
    [appDelegate.prefs setObject:appDelegate.currentProvider forKey:cJRCurrentProvider];

    currentUserLabel.text = @"Signing in...";
    [self configureProviderIcon];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)captureAuthenticationDidSucceedForUser:(JRCaptureUser *)newCaptureUser
                                        status:(JRCaptureRecordStatus)captureRecordStatus
{
    DLog(@"");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if (captureRecordStatus == JRCaptureRecordNewlyCreated)
        appDelegate.isNew = YES;
    else
        appDelegate.isNew = NO;

    if (captureRecordStatus == JRCaptureRecordRequiresCreation)
        appDelegate.isNotYetCreated = YES;
    else
        appDelegate.isNotYetCreated = NO;

    appDelegate.captureUser = newCaptureUser;

    [appDelegate.prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:appDelegate.captureUser]
                     forKey:cJRCaptureUser];

    [self captureSignInDidSucceed];

    appDelegate.engageSignInWasCanceled = NO;
}


@end
