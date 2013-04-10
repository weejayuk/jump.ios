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

#import "debug_log.h"
#import "JRCaptureData.h"
#import "JRCaptureApidInterface.h"
#import "JSONKit.h"

@interface JRCaptureUserApidHandler : NSObject <JRCaptureInterfaceDelegate>
@end

@implementation JRCaptureUserApidHandler
+ (id)captureUserApidHandler
{
    return [[[JRCaptureUserApidHandler alloc] init] autorelease];
}

- (void)getCaptureUserDidFailWithResult:(NSDictionary *)result context:(NSObject *)context
{
    DLog(@"");
    NSDictionary *myContext = (NSDictionary *) context;
    NSObject *callerContext = [myContext objectForKey:@"callerContext"];
    id <JRCaptureUserDelegate> delegate = [myContext objectForKey:@"delegate"];

    if ([delegate respondsToSelector:@selector(fetchUserDidFailWithError:context:)])
        [delegate fetchUserDidFailWithError:[JRCaptureError errorFromResult:result onProvider:nil mergeToken:nil]
                                    context:callerContext];
}

- (void)getCaptureUserDidSucceedWithResult:(NSObject *)result context:(NSObject *)context
{
    DLog(@"");
    NSDictionary    *myContext     = (NSDictionary *)context;
    //NSString        *capturePath   = [myContext objectForKey:@"capturePath"];
    NSObject        *callerContext = [myContext objectForKey:@"callerContext"];
    id<JRCaptureUserDelegate>
                     delegate      = [myContext objectForKey:@"delegate"];

    NSDictionary *resultDictionary;
    if ([result isKindOfClass:[NSString class]])
        resultDictionary = [(NSString *)result objectFromJSONString];
    else /* Uh-oh!! */
        return [self getCaptureUserDidFailWithResult:[JRCaptureError invalidClassErrorForResult:result] 
                                             context:context];

    if (!resultDictionary)
        return [self createCaptureUserDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] 
                                                context:context];

    if (![((NSString *)[resultDictionary objectForKey:@"stat"]) isEqualToString:@"ok"])
        return [self getCaptureUserDidFailWithResult:[JRCaptureError invalidStatErrorForResult:result] context:context];

    NSDictionary *result_ = [resultDictionary objectForKey:@"result"];
    if (!result_ || ![result_ isKindOfClass:[NSDictionary class]])
        return [self getCaptureUserDidFailWithResult:[JRCaptureError invalidDataErrorForResult:result] context:context];

    JRCaptureUser *captureUser = [JRCaptureUser captureUserObjectFromDictionary:result_];

    if ([delegate respondsToSelector:@selector(fetchUserDidSucceed:context:)])
        [delegate fetchUserDidSucceed:captureUser context:callerContext];
}
@end

@implementation JRCaptureUser (JRCaptureUser_Extras)

+ (void)fetchCaptureUserFromServerForDelegate:(id<JRCaptureUserDelegate>)delegate
                                      context:(NSObject *)context __unused
{
    DLog(@"");
    NSDictionary *newContext = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"/", @"capturePath",
                                                     delegate, @"delegate",
                                                     context, @"callerContext", nil];

    [JRCaptureApidInterface getCaptureUserWithToken:[[JRCaptureData sharedCaptureData] accessToken]
                                        forDelegate:[JRCaptureUserApidHandler captureUserApidHandler]
                                        withContext:newContext];
}

+ (id)captureUserObjectFromDictionary:(NSDictionary *)dictionary
{
    return [JRCaptureUser captureUserObjectFromDictionary:dictionary withPath:@""];
}

+ (void)testCaptureUserApidHandlerGetCaptureUserDidFailWithResult:(NSDictionary *)result
                                                          context:(NSObject *)context __unused
{
    [[JRCaptureUserApidHandler captureUserApidHandler] getCaptureUserDidFailWithResult:result context:context];
}

+ (void)testCaptureUserApidHandlerGetCaptureUserDidSucceedWithResult:(NSDictionary *)result
                                                             context:(NSObject *)context __unused
{
    [[JRCaptureUserApidHandler captureUserApidHandler] getCaptureUserDidSucceedWithResult:result context:context];
}

@end

