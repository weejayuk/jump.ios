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

/**
 * @internal
 */
@interface JRCaptureData : NSObject
@property(nonatomic, retain) NSString *bpChannelUrl;
@property(nonatomic, readonly, retain) NSString *captureBaseUrl;
@property(nonatomic, readonly, retain) NSString *captureRedirectUri;
@property(nonatomic, readonly, retain) NSString *clientId;
@property(nonatomic, readonly, retain) NSString *accessToken;
@property(nonatomic, readonly, retain) NSString *refreshSecret;
@property(nonatomic, readonly, retain) NSString *captureLocale;
@property(nonatomic, readonly, retain) NSString *captureTraditionalSignInFormName;
@property(nonatomic, readonly, retain) NSString *captureFlowName;
@property(nonatomic, readonly, retain) NSString *captureTraditionalRegistrationFormName;
@property(nonatomic, readonly, retain) NSString *captureSocialRegistrationFormName;
@property(nonatomic, readonly, retain) NSString *captureFlowVersion;
@property(nonatomic, readonly, retain) NSString *captureAppId;
@property(nonatomic, readonly, retain) NSDictionary *captureFlow;
@property(nonatomic) BOOL flowUsesTestingCdn;

+ (void)setAccessToken:(NSString *)token;

+ (void)setCaptureRedirectUri:(NSString *)redirectUri;

+ (void)setCaptureDomain:(NSString *)captureDomain captureClientId:(NSString *)clientId
           captureLocale:(NSString *)captureLocale captureTraditionalSignInFormName:(NSString *)captureTraditionalSignInFormName
                                                                    captureFlowName:(NSString *)captureFlowName
         captureEnableThinRegistration:(BOOL)enableThinRegistration
captureTraditionalRegistrationFormName:(NSString *)captureTraditionalRegistrationFormName
     captureSocialRegistrationFormName:(NSString *)captureSocialRegistrationFormName
                    captureFlowVersion:(NSString *)captureFlowVersion captureAppId:(NSString *)captureAppId;

+ (NSString *)captureTokenUrlWithMergeToken:(NSString *)mergeToken;

+ (void)clearSignInState;

+ (JRCaptureData *)sharedCaptureData;

+ (NSString *)generateAndStoreRefreshSecret;

+ (NSMutableURLRequest *)requestWithPath:(NSString *)path;

- (NSString *)downloadedFlowVersion;

- (NSString *)redirectUri;

- (void)loadFlow;

@end
