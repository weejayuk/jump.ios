/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "AppDelegate.h"
#import "JRCapture.h"
#import "BackplaneUtils.h"
#import "debug_log.h"

AppDelegate *appDelegate = nil;

@implementation AppDelegate
@synthesize window;
@synthesize prefs;

// Capture stuff:
@synthesize captureUser;
@synthesize captureClientId;
@synthesize captureDomain;
@synthesize captureLocale;
@synthesize captureSignInFormName;
@synthesize captureFlowName;
@synthesize engageAppId;
@synthesize captureFlowVersion;
@synthesize captureEnableThinRegistration;
@synthesize captureRegistrationFormName;
@synthesize captureAppId;

// Backplane / LiveFyre stuff:
@synthesize bpChannelUrl;
@synthesize lfToken;
@synthesize bpBusUrlString;
@synthesize liveFyreNetwork;
@synthesize liveFyreSiteId;
@synthesize liveFyreArticleId;

// Demo state machine stuff:
@synthesize currentProvider;
@synthesize isNotYetCreated;
@synthesize engageSignInWasCanceled;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    appDelegate = self;

    [self loadDemoConfigFromPlist];

    [JRCapture setEngageAppId:engageAppId captureDomain:captureDomain captureClientId:captureClientId
                captureLocale:captureLocale captureFlowName:captureFlowName
        captureSignInFormName:captureSignInFormName captureEnableThinRegistration:captureEnableThinRegistration
 captureTraditionalSignInType:JRConventionalSigninEmailPassword captureFlowVersion:captureFlowVersion
  captureRegistrationFormName:captureRegistrationFormName captureAppId:captureAppId];

    [BackplaneUtils asyncFetchNewBackplaneChannelWithBus:bpBusUrlString
                                              completion:^(NSString *newChannel, NSError *error)
                                              {
                                                  if (newChannel)
                                                  {
                                                      self.bpChannelUrl = newChannel;
                                                  }
                                                  else
                                                  {
                                                      ALog("%@", [error description]);
                                                  }
                                              }];

    self.prefs = [NSUserDefaults standardUserDefaults];

    self.currentProvider = [self.prefs objectForKey:cJRCurrentProvider];

    NSData *archivedCaptureUser = [self.prefs objectForKey:cJRCaptureUser];
    if (archivedCaptureUser)
    {
        self.captureUser = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCaptureUser];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

- (void)loadDemoConfigFromPlist
{
    // See assets folder in Resources project group for janrain-config-default.plist
    // Copy to janrain-config.plist and change it to your details
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"assets/janrain-config" ofType:@"plist"];
    if (!plistPath)
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"assets/janrain-config-default" ofType:@"plist"];
    }
    NSDictionary *cfgPlist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *configKeyName = [cfgPlist objectForKey:@"default-config"];
    self.captureEnableThinRegistration = YES;
    [self parseConfigNamed:configKeyName fromConfigPlist:cfgPlist];
}

- (void)parseConfigNamed:(NSString *)cfgKeyName fromConfigPlist:(NSDictionary *)cfgPlist
{
    NSDictionary *cfg = [cfgPlist objectForKey:cfgKeyName];

    NSString *parentConfig = [cfg objectForKey:@"parentConfig"];
    if (parentConfig) [self parseConfigNamed:parentConfig fromConfigPlist:cfgPlist];

    if ([cfg objectForKey:@"captureClientId"])
        self.captureClientId = [cfg objectForKey:@"captureClientId"];
    if ([cfg objectForKey:@"captureDomain"])
        self.captureDomain = [cfg objectForKey:@"captureDomain"];
    if ([cfg objectForKey:@"captureLocale"])
        self.captureLocale = [cfg objectForKey:@"captureLocale"];
    if ([cfg objectForKey:@"captureSignInFormName"])
        self.captureSignInFormName = [cfg objectForKey:@"captureSignInFormName"];
    if ([cfg objectForKey:@"captureFlowName"])
        self.captureFlowName = [cfg objectForKey:@"captureFlowName"];
    if ([cfg objectForKey:@"captureEnableThinRegistration"])
        self.captureEnableThinRegistration = [[cfg objectForKey:@"captureEnableThinRegistration"] boolValue];
    if ([cfg objectForKey:@"captureFlowVersion"])
        self.captureFlowVersion = [cfg objectForKey:@"captureFlowVersion"];
    if ([cfg objectForKey:@"captureRegistrationFormName"])
        self.captureRegistrationFormName = [cfg objectForKey:@"captureRegistrationFormName"];
    if ([cfg objectForKey:@"captureAppId"])
        self.captureAppId = [cfg objectForKey:@"captureAppId"];
    if ([cfg objectForKey:@"engageAppId"])
        self.engageAppId = [cfg objectForKey:@"engageAppId"];
    if ([cfg objectForKey:@"bpBusUrlString"])
        self.bpBusUrlString = [cfg objectForKey:@"bpBusUrlString"];
    if ([cfg objectForKey:@"bpChannelUrl"])
        self.bpChannelUrl = [cfg objectForKey:@"bpChannelUrl"];
    if ([cfg objectForKey:@"liveFyreNetwork"])
        self.liveFyreNetwork = [cfg objectForKey:@"liveFyreNetwork"];
    if ([cfg objectForKey:@"liveFyreSiteId"])
        self.liveFyreSiteId = [cfg objectForKey:@"liveFyreSiteId"];
    if ([cfg objectForKey:@"liveFyreArticleId"])
        self.liveFyreArticleId = [cfg objectForKey:@"liveFyreArticleId"];
}

- (void)saveCaptureUser
{
    [self.prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:self.captureUser] forKey:cJRCaptureUser];
}

@end
