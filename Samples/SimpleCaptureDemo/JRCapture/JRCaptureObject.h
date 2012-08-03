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

@class JRCaptureObject;

/**
 * @brief
 * Protocol adopted by an object ...
 **/
@protocol JRCaptureObjectDelegate <NSObject>
@optional

/**
 * Sent if ...
 *
 * @param object
 *   object
 *
 * @param context
 *   context
 **/
- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context;

/**
 * Sent if ...
 *
 * @param object
 *   object
 *
 * @param error
 *   error
 *
 * @param context
 *   context
 **/
- (void)updateDidFailForObject:(JRCaptureObject *)object withError:(NSError *)error context:(NSObject *)context;

/**
 * Sent if ...
 *
 * @param object
 *   object
 *
 * @param replacedArray
 *   replacedArray
 *
 * @param arrayName
 *   replacedArray
 *
 * @param context
 *   context
 **/
- (void)replaceArrayDidSucceedForObject:(JRCaptureObject *)object newArray:(NSArray *)replacedArray
                                  named:(NSString *)arrayName context:(NSObject *)context;

/**
 * Sent if ...
 *
 * @param object
 *   object
 *
 * @param arrayName
 *   object
 *
 * @param error
 *   object
 *
 * @param context
 *   context
 **/
- (void)replaceArrayDidFailForObject:(JRCaptureObject *)object arrayNamed:(NSString *)arrayName
                           withError:(NSError *)error context:(NSObject *)context;
@end

/**
 * @brief
 * Base class for all Capture objects and plural elements
 **/
@interface JRCaptureObject : NSObject
@property (readonly) BOOL canBeUpdatedOnCapture; /**< foo */

/**
 * Use this method to determine if the object or element needs to be updated remotely.
 * That is, if there are local changes to any of the object/elements's properties or
 * sub-objects, then this object will need to be updated on Capture. You can update
 * an object on Capture by using the method updateOnCaptureForDelegate:context:().
 *
 * @return
 * \c YES if this object or any of it's sub-objects have any properties that have changed
 * locally. This does not include properties that are arrays, if any, or the elements contained
 * within the arrays. \c NO if no non-array properties or sub-objects have changed locally.
 *
 * @note
 * This method recursively checks all of the sub-objects of the JRCaptureObject.
 * If any of these objects are new, or if they need to be updated, this method returns \c YES.
 *
 * @warning
 * If this object, or one of its ancestors, is an element of a plural, and if any elements of the plural have changed,
 * (added or removed) the array must be replaced on Capture before the elements or their sub-objects can be
 * updated. Please use the appropriate replace&lt;<em>ArrayName</em>&gt;ArrayOnCaptureForDelegate:context:
 * method first. Even if needsUpdate returns \c YES, this object cannot be updated on Capture unless
 * canBeUpdatedOnCapture also returns \c YES.
 *
 * @par
 * This method recursively checks all of the sub-objects of the JRCaptureObject but does not check any of the arrays
 * or the arrays' elements. If you have added or removed any elements from the arrays, you must call the appropriate
 * \c replace&lt;<em>ArrayName</em>&gt;ArrayOnCaptureForDelegate:context: methods to update the array on Capture.
 * Otherwise, if the arrays' elements' canBeUpdatedOnCapture and needsUpdate returns \c YES, you can update
 * the elements by calling updateOnCaptureForDelegate:context:().
 **/
- (BOOL)needsUpdate;

/**
 * Sent if ...
 *
 * @param delegate
 *   delegate
 *
 * @param context
 *   context
 **/
- (void)updateOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;
@end

