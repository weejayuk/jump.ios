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
#import "AlertViewWithBlocks.h"
#import "AppDelegate.h"
#import "CaptureDynamicForm.h"
#import "JRCaptureError.h"
#import "JRCaptureObject+Internal.h"

@interface RootViewController ()
@property(nonatomic, copy) void (^viewDidAppearContinuation)();
@property(nonatomic) BOOL viewIsApparent;

- (void)configureButtons;
@end

@interface JRCapture (BetaAPIs)
+ (void)refreshAccessTokenForDelegate:(id <JRCaptureDelegate>)delegate context:(id <NSObject>)context;
@end

@implementation RootViewController
@synthesize viewDidAppearContinuation;
@synthesize currentUserLabel;
@synthesize currentUserProviderIcon;
@synthesize browseButton;
@synthesize thirdButton;
@synthesize formButton;
@synthesize signInButton;
@synthesize signOutButton;
@synthesize shareWidgetButton;
@synthesize customUi;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.customUi =  @{kJRApplicationNavigationController : self.navigationController};
    [self configureUserLabelAndIcon];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configureButtons];
}

- (void)configureButtons
{
    [thirdButton setTitle:@"Refresh Access Token" forState:UIControlStateNormal];
    if (appDelegate.captureUser)
    {
        thirdButton.hidden = NO;
        signInButton.hidden = YES;
        signOutButton.hidden = NO;
        [formButton setTitle:@"Update" forState:UIControlStateNormal];
        browseButton.enabled = YES;
        browseButton.alpha = 1;
    }
    else
    {
        thirdButton.hidden = YES;
        signInButton.hidden = NO;
        [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
        signOutButton.hidden = YES;
        [formButton setTitle:@"Traditional Registration" forState:UIControlStateNormal];
        browseButton.enabled = NO;
        browseButton.alpha = 0.5;
    }

    //thirdButton.hidden = NO;
    //[thirdButton setTitle:@"Share" forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog();
    self.viewIsApparent = YES;
    [self configureUserLabelAndIcon];
    [self configureButtons];
    if (viewDidAppearContinuation)
    {
        viewDidAppearContinuation();
        self.viewDidAppearContinuation = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.viewIsApparent = NO;
    [super viewDidDisappear:animated];
}


- (IBAction)browseButtonPressed:(id)sender
{
    DLog(@"Capture user record: %@", [appDelegate.captureUser toDictionaryForEncoder:NO]);
}

- (IBAction)updateButtonPressed:(id)sender
{
    if (appDelegate.captureUser)
    {
        [RootViewController showProfileForm:self.navigationController];
    }
    else
    {
        [self showRegistrationForm];
    }
}

- (void)showRegistrationForm
{
    CaptureDynamicForm *viewController = [[CaptureDynamicForm alloc] initWithNibName:nil
                                                                                        bundle:[NSBundle mainBundle]];

    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)thirdButtonPressed:(id)sender
{
    //[BackplaneUtils asyncFetchNewLiveFyreUserTokenWithArticleId:appDelegate.liveFyreArticleId
    //                                                     network:appDelegate.liveFyreNetwork
    //                                                     siteId:appDelegate.liveFyreSiteId
    //                                           backplaneChannel:appDelegate.bpChannelUrl
    //                                                 completion:^(NSString *string, NSError *err)
    //                                                 //{
                                                     //
                                                     //}];

    //JRActivityObject *t = [JRActivityObject activityObjectWithAction:@"tested"];
    //t.sms = [JRSmsObject smsObjectWithMessage:@"test" andUrlsToBeShortened:nil];
    //t.email = [JREmailObject emailObjectWithSubject:@"test" andMessageBody:@"test"
    //                                         isHtml:NO andUrlsToBeShortened:nil];
    //[JREngage showSharingDialogWithActivity:t];

    [JRCapture refreshAccessTokenForDelegate:self context:nil];
}

- (void)refreshAccessTokenDidFailWithError:(NSError *)error context:(id <NSObject>)context
{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description]
                                                               delegate:nil cancelButtonTitle:@"Dismiss"
                                                      otherButtonTitles:nil];
            [alertView show];
}

- (void)refreshAccessTokenDidSucceedWithContext:(id <NSObject>)context
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:nil delegate:nil
                                              cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)signInButtonPressed:(id)sender
{
    currentUserProviderIcon.image = nil;

    [self signOutCurrentUser];

    [JRCapture startEngageSignInDialogWithConventionalSignIn:JRConventionalSignInEmailPassword
                                 andCustomInterfaceOverrides:self.customUi forDelegate:self];
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
    {
        currentUserLabel.text = [NSString stringWithFormat:@"Email: %@", appDelegate.captureUser.email];
    }
    else
    {
        currentUserLabel.text = @"No current user";
    }

    [self configureProviderIcon];
}

- (void)configureProviderIcon
{
    NSString *icon = [NSString stringWithFormat:@"icon_%@_30x30@2x.png", appDelegate.currentProvider];
    currentUserProviderIcon.image = [UIImage imageNamed:icon];
}

- (void)engageSignInDidFailWithError:(NSError *)error
{
    DLog(@"error: %@", [error description]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description]
                                                       delegate:nil cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)handleBadPasswordError
{
    [[[UIAlertView alloc] initWithTitle:@"Access Denied" message:@"Invalid password for email@address.com"
                                  delegate:nil cancelButtonTitle:@"Dismiss"
                         otherButtonTitles:nil] show];
}

- (void)handleMergeFlowError:(NSError *)error
{
    NSString *existingAccountProvider = [error JRMergeFlowExistingProvider];
    void (^mergeAlertCompletion)(UIAlertView *, BOOL, NSInteger) =
            ^(UIAlertView *alertView, BOOL cancelled, NSInteger buttonIndex)
            {
                if (cancelled) return;

                if ([existingAccountProvider isEqualToString:@"capture"]) // Traditional sign-in required
                {
                    [self handleTradMerge:error];

                }
                else
                {
                    // Social sign-in required:
                    [JRCapture startEngageSignInDialogOnProvider:existingAccountProvider
                                                                withCustomInterfaceOverrides:self.customUi
                                                                                  mergeToken:[error JRMergeToken]
                                                                                 forDelegate:self];
                }
            };

    [self showMergeAlertDialog:existingAccountProvider mergeAlertCompletion:mergeAlertCompletion];

}

- (void)handleTradMerge:(NSError *)error
{
    void (^signInCompletion)(UIAlertView *, BOOL, NSInteger) =
            ^(UIAlertView *alertView_, BOOL cancelled_, NSInteger buttonIndex_)
            {
                if (cancelled_) return;
                NSString *user = [[alertView_ textFieldAtIndex:0] text];
                NSString *password = [[alertView_ textFieldAtIndex:1] text];
                [JRCapture startCaptureConventionalSignInForUser:user withPassword:password
                                                  withSignInType:JRConventionalSignInEmailPassword
                                                      mergeToken:[error JRMergeToken]
                                                     forDelegate:self];
            };

    [[[AlertViewWithBlocks alloc] initWithTitle:@"Sign in" message:nil completion:signInCompletion
                                          style:UIAlertViewStyleLoginAndPasswordInput cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Sign-in", nil] show];
}

- (void)showMergeAlertDialog:(NSString *)existingAccountProvider
        mergeAlertCompletion:(void (^)(UIAlertView *, BOOL, NSInteger))mergeAlertCompletion
{
    NSString *captureAccountBrandPhrase = @"a SimpleCaptureDemo";
    NSString *existingAccountProviderPhrase = [existingAccountProvider isEqualToString:@"capture"] ?
            @"" : [NSString stringWithFormat:@"It is associated with your %@ account. ", existingAccountProvider];

    NSString *message = [NSString stringWithFormat:@"There is already %@ account with that email address. %@ Tap "
                                                           "'Merge' to sign-in with that account, and link the two.",
                                                   captureAccountBrandPhrase,
                                                   existingAccountProviderPhrase];

    [[[AlertViewWithBlocks alloc] initWithTitle:@"Email address in use" message:message
                                     completion:mergeAlertCompletion
                                          style:UIAlertViewStyleDefault
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Merge", nil] show];
}

- (void)handleTwoStepRegFlowError:(NSError *)error
{
    appDelegate.isNotYetCreated = YES;
    appDelegate.captureUser = [error JRPreregistrationRecord];
    appDelegate.registrationToken = [error JRSocialRegistrationToken];

    UINavigationController *controller = self.navigationController;
    if (self.viewIsApparent)
    {
        [RootViewController showProfileForm:controller];
    }
    else
    {
        self.viewDidAppearContinuation = ^()
        {
            [RootViewController showProfileForm:controller];
        };
    }
}

- (void)signOutCurrentUser
{
    appDelegate.currentProvider  = nil;
    appDelegate.captureUser      = nil;

    appDelegate.isNotYetCreated = NO;

    [appDelegate.prefs setObject:nil forKey:cJRCurrentProvider];
    [appDelegate.prefs setObject:nil forKey:cJRCaptureUser];

    //appDelegate.engageSignInWasCanceled = NO;

    [JRCapture clearSignInState];
}

- (void)engageAuthenticationDidCancel
{
    DLog(@"");
    //appDelegate.engageSignInWasCanceled = YES;
}

- (void)engageAuthenticationDialogDidFailToShowWithError:(NSError *)error
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

- (void)captureSignInDidFailWithError:(NSError *)error
{
    [self setProviderAndConfigureIcon:nil];

    DLog(@"error: %@", [error description]);
    if ([error code] == JRCaptureErrorGenericBadPassword)
    {
        [self handleBadPasswordError];
    }
    else if ([error isJRMergeFlowError])
    {
        [self handleMergeFlowError:error];
    }
    else if ([error isJRTwoStepRegFlowError])
    {
        [self handleTwoStepRegFlowError:error];
    }
    else
    {
        DLog(@"error: %@", [error description]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error description]
                                                           delegate:nil cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)engageAuthenticationDidSucceedForUser:(NSDictionary *)engageAuthInfo forProvider:(NSString *)provider
{
    [self setProviderAndConfigureIcon:provider];

    currentUserLabel.text = @"Signing in...";

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)setProviderAndConfigureIcon:(NSString *)provider
{
    appDelegate.currentProvider = provider;
    [appDelegate.prefs setObject:appDelegate.currentProvider forKey:cJRCurrentProvider];
    [self configureProviderIcon];
}

- (void)captureSignInDidSucceedForUser:(JRCaptureUser *)newCaptureUser
                                        status:(JRCaptureRecordStatus)captureRecordStatus
{
    DLog(@"");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    appDelegate.captureUser = newCaptureUser;
    [appDelegate.prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:appDelegate.captureUser]
                          forKey:cJRCaptureUser];

    [self configureButtons];
    [self configureUserLabelAndIcon];

    if (captureRecordStatus == JRCaptureRecordNewlyCreated)
    {
        [RootViewController showProfileForm:self.navigationController];
    }

    //appDelegate.engageSignInWasCanceled = NO;
}

+ (void)showProfileForm:(UINavigationController *)controller
{
    CaptureProfileViewController *viewController = [[CaptureProfileViewController alloc]
            initWithNibName:@"CaptureProfileViewController" bundle:[NSBundle mainBundle]];

    [controller pushViewController:viewController animated:YES];
}

@end
