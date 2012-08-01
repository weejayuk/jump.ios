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

#import <Foundation/Foundation.h>
#import "JRCaptureUser.h"

@class JRCaptureObject;
@class JRCaptureUser;

/**
 * @brief
 * Protocol adopted by an object ...
 **/
@protocol JRCaptureUserDelegate <JRCaptureObjectDelegate>
@optional
/**
 * Sent if ...
 *
 * @param user
 *   user
 *
 * @param context
 *   context
 **/
- (void)createDidSucceedForUser:(JRCaptureUser *)user context:(NSObject *)context;

/**
 * Sent if ...
 *
 * @param user
 *   user
 *
 * @param error
 *   error
 *
 * @param context
 *   context
 **/
- (void)createDidFailForUser:(JRCaptureUser *)user withError:(NSError *)error context:(NSObject *)context;

/**
 * Sent if ...
 *
 * @param fetchedUser
 *   fetchedUser
 *
 * @param context
 *   context
 **/
- (void)fetchUserDidSucceed:(JRCaptureUser *)fetchedUser context:(NSObject *)context;

/**
 * Sent if ...
 *
 * @param error
 *   error
 *
 * @param context
 *   context
 **/
- (void)fetchUserDidFailWithError:(NSError *)error context:(NSObject *)context;


#ifdef JRCAPTURE_FETCH_LAST_UPDATED
/**
 * Sent if ...
 *
 * @param serverLastUpdated
 *   serverLastUpdated
 *
 * @param isOutdated
 *   isOutdated
 *
 * @param context
 *   context
 **/
- (void)fetchLastUpdatedDidSucceed:(JRDateTime *)serverLastUpdated isOutdated:(BOOL)isOutdated context:(NSObject *)context;

/**
 * Sent if ...
 *
 * @param error
 *   error
 *
 * @param context
 *   context
 **/
- (void)fetchLastUpdatedDidFailWithError:(NSError *)error context:(NSObject *)context;
#endif // JRCAPTURE_FETCH_LAST_UPDATED
@end

/**
 * @brief
 * The top-level class that holds the Capture user record
 **/
@interface JRCaptureUser (JRCaptureUser_Extras) <NSCoding>

/**
 * Sent if ...
 *
 * @param delegate
 *   delegate
 *
 * @param context
 *   context
 **/
- (void)createOnCaptureForDelegate:(id<JRCaptureUserDelegate>)delegate context:(NSObject *)context;

/**
 * Sent if ...
 *
 * @param delegate
 *   delegate
 *
 * @param context
 *   context
 **/
+ (void)fetchCaptureUserFromServerForDelegate:(id<JRCaptureUserDelegate>)delegate context:(NSObject *)context;

#ifdef JRCAPTURE_FETCH_LAST_UPDATED
/**
 * Sent if ...
 *
 * @param delegate
 *   delegate
 *
 * @param context
 *   context
 **/
- (void)fetchLastUpdatedFromServerForDelegate:(id<JRCaptureUserDelegate>)delegate context:(NSObject *)context;
#endif // JRCAPTURE_FETCH_LAST_UPDATED

/**
 * @internal
 **/
+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary;
@end
