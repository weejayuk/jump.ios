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

#import "JRCapture.h"

/**
 * @internal
 */
@interface JRCaptureData : NSObject
@property(nonatomic, retain) NSString *bpChannelUrl;
@property(nonatomic, readonly, retain) NSString *captureBaseUrl;
@property(nonatomic, readonly, retain) NSString *clientId;
@property(nonatomic, readonly, retain) NSString *accessToken;
@property(nonatomic, readonly, retain) NSString *creationToken;
@property(nonatomic, readonly, retain) NSString *captureLocale;
@property(nonatomic, readonly, retain) NSString *captureSignInFormName;
@property(nonatomic, readonly, retain) NSString *captureFlowName;
@property(nonatomic, readonly) JRConventionalSigninType captureTradSignInType;
@property(nonatomic, readonly, retain) NSString *captureRegistrationFormName;
@property(nonatomic, readonly, retain) NSString *captureFlowVersion;
@property(nonatomic, readonly, retain) NSString *captureAppId;
@property(nonatomic, readonly, retain) NSDictionary *captureFlow;

+ (void)setAccessToken:(NSString *)token;

+     (void)setCaptureDomain:(NSString *)captureDomain captureClientId:(NSString *)clientId
               captureLocale:(NSString *)captureLocale captureSignInFormName:(NSString *)captureSignInFormName
             captureFlowName:(NSString *)captureFlowName captureEnableThinRegistration:(BOOL)enableThinRegistration
captureTraditionalSignInType:(JRConventionalSigninType)tradSignInType
 captureRegistrationFormName:(NSString *)captureRegistrationFormName captureFlowVersion:(NSString *)captureFlowVersion
                captureAppId:(NSString *)captureAppId;

+ (NSString *)captureTokenUrlWithMergeToken:(NSString *)mergeToken;

+ (void)clearSignInState;

+ (JRCaptureData *)sharedCaptureData;

- (NSString *)downloadedFlowVersion;

- (NSString *)redirectUri;

- (void)loadFlow;

@end
