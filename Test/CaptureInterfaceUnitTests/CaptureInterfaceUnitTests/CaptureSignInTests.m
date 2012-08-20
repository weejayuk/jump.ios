
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

#import <GHUnitIOS/GHUnit.h>
#import "SharedData.h"
#import "JRCaptureObject+Internal.h"
#import "JSONKit.h"
#import "debug_log.h"
#import "JRCapture.h"
#import "JRCaptureApidInterface.h"

@interface zz1_CaptureSignInTests : GHAsyncTestCase <JRCaptureInterfaceDelegate>
//{
//    JRCaptureUser *captureUser;
//}
@property(retain) JRCaptureUser *captureUser;
@end

@implementation zz1_CaptureSignInTests
@synthesize captureUser;

- (void)setUpClass
{
    DLog(@"");
    [SharedData initializeCapture];
}

- (void)tearDownClass
{
    DLog(@"");
    self.captureUser = nil;
}

- (void)setUp
{
    self.captureUser = [SharedData getBlankCaptureUser];
}

- (void)tearDown
{
    self.captureUser = nil;
}

/* Set a boolean with an NSNumber boolean */
- (void)test_zz101_SignInUser
{
    NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"lilli@janrain.com", @"email",
                                                      @"aaaaaa", @"password",
                                                      nil];
    [JRCaptureApidInterface signinCaptureUserWithCredentials:credentials
                                                      ofType:@"email"
                                                 forDelegate:self
                                                 withContext:NSStringFromSelector(_cmd)];
    [self prepare];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)signinCaptureUserDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString((NSString *) context)];
}

- (void)signinCaptureUserDidFailWithResult:(NSDictionary *)result context:(NSObject *)context
{
    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString((NSString *) context)];
}

//- (void)test_zz101_CheckAccessToken
//{
//    [self prepare];
//    [captureUser updateOnCaptureForDelegate:self context:NSStringFromSelector(_cmd)];
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
//}

//- (void)updateCaptureObject:(JRCaptureObject *)object didSucceedWithResult:(NSString *)result context:(NSObject *)context
//{
//    NSDictionary *resultDictionary = [result objectFromJSONString];
//    NSDictionary *captureProfile   = [resultDictionary objectForKey:@"result"];
//
//    JRCaptureUser *newUser = [JRCaptureUser captureUserObjectFromDictionary:captureProfile];
//
//    NSString *testSelectorString = (NSString *)context;
//    @try
//    {
//        if ([testSelectorString isEqualToString:@"test_a101_booleanWithBoolTrue"])
//        {
//            GHAssertTrue([newUser.basicBoolean boolValue], nil);
//        }
//        else if ([testSelectorString isEqualToString:@"test_a102_booleanWithBoolFalse"])
//        {
//            GHAssertFalse([newUser.basicBoolean boolValue], nil);
//        }
//        else if ([testSelectorString isEqualToString:@"test_a103_booleanWithIntTrue"])
//        {
//            GHAssertTrue([newUser.basicBoolean boolValue], nil);
//        }
//        else if ([testSelectorString isEqualToString:@"test_a104_booleanWithIntFalse"])
//        {
//            GHAssertFalse([newUser.basicBoolean boolValue], nil);
//        }
//        else if ([testSelectorString isEqualToString:@"test_a105_booleanWithDoubleTrue"])
//        {
//            GHAssertTrue([newUser.basicBoolean boolValue], nil);
//        }
//        else if ([testSelectorString isEqualToString:@"test_a106_booleanWithDoubleFalse"])
//        {
//            GHAssertFalse([newUser.basicBoolean boolValue], nil);
//        }
//        else if ([testSelectorString isEqualToString:@"test_a107_booleanWithNil"])
//        {
//            GHAssertNil(newUser.basicBoolean, nil);
//        }
//        else if ([testSelectorString isEqualToString:@"test_a108_booleanWithNSNull"])
//        {
//            GHAssertNil(newUser.basicBoolean, nil);
//        }
//        else if ([testSelectorString isEqualToString:@"test_a109_primitiveSetterTrue"])
//        {
//            GHAssertTrue([newUser getBasicBooleanBoolValue], nil);
//        }
//        else if ([testSelectorString isEqualToString:@"test_a110_primitiveSetterFalse"])
//        {
//            GHAssertFalse([newUser getBasicBooleanBoolValue], nil);
//        }
//        else
//        {
//            GHAssertFalse(TRUE, @"Missing test result comparison for %@ in %@", testSelectorString, NSStringFromSelector(_cmd));
//        }
//    }
//    @catch (NSException *exception)
//    {
//        GHTestLog([exception description]);
//        [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
//
//        return;
//    }
//
//    [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(testSelectorString)];
//}

//- (void)updateCaptureObject:(JRCaptureObject *)object didFailWithResult:(NSString *)result context:(NSObject *)context
//{
//    NSString *testSelectorString = (NSString *)context;
//    [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(testSelectorString)];
//}

- (void)dealloc
{
    [captureUser release];
    [super dealloc];
}
@end
