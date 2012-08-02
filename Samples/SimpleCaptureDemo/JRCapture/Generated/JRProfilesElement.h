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
#import "JRCaptureObject.h"
#import "JRCaptureTypes.h"
#import "JRNSDate+ISO8601_CaptureDateTimeString.h"
#import "JRProfile.h"

/**
 * @brief A JRProfilesElement object
 **/
@interface JRProfilesElement : JRCaptureObject
@property (nonatomic, readonly) JRObjectId *profilesElementId; /**< Simple identifier for this sub-entity @note The \e id of the object should not be set. */ 
@property (nonatomic, copy)     JRJsonObject *accessCredentials; /**< User's authorization credentials for this provider @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSString *domain; /**< The object's \e domain property */ 
@property (nonatomic, copy)     JRStringArray *followers; /**< User's followers @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c identifier */ 
@property (nonatomic, copy)     JRStringArray *following; /**< Who the user is following @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c identifier */ 
@property (nonatomic, copy)     JRStringArray *friends; /**< User's friends @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c identifier */ 
@property (nonatomic, copy)     NSString *identifier; /**< Profile provider unique identifier */ 
@property (nonatomic, retain)   JRProfile *profile; /**< The object's \e profile property */ 
@property (nonatomic, copy)     JRJsonObject *provider; /**< Provider for this profile @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSString *remote_key; /**< PrimaryKey field from Engage */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRProfilesElement object
 *
 * @return
 *   A JRProfilesElement object
 *
 * @note 
 * Method creates a object without the required properties: \e domain, \e identifier.
 * These properties are required when updating the object on Capture. That is, you must set them before calling
 * updateOnCaptureForDelegate:context:().
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRProfilesElement object
 *
 * @return
 *   A JRProfilesElement object
 *
 * @note 
 * Method creates a object without the required properties: \e domain, \e identifier.
 * These properties are required when updating the object on Capture. That is, you must set them before calling
 * updateOnCaptureForDelegate:context:().
 **/
+ (id)profilesElement;

/**
 * Returns a JRProfilesElement object initialized with the given required properties: \c newDomain, \c newIdentifier
 *
 * @param newDomain
 *   The object's \e domain property
 *
 * @param newIdentifier
 *   Profile provider unique identifier
 * 
 * @return
 *   A JRProfilesElement object initialized with the given required properties: \e newDomain, \e newIdentifier.
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil
 **/
- (id)initWithDomain:(NSString *)newDomain andIdentifier:(NSString *)newIdentifier;

/**
 * Returns a JRProfilesElement object initialized with the given required properties: \c domain, \c identifier
 *
 * @param domain
 *   The object's \e domain property
 *
 * @param identifier
 *   Profile provider unique identifier
 * 
 * @return
 *   A JRProfilesElement object initialized with the given required properties: \e domain, \e identifier.
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil
 **/
+ (id)profilesElementWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceFollowersArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceFollowingArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceFriendsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: Doxygen doc
 **/
- (BOOL)needsUpdate;

/**
 * TODO: Doxygen doc
 **/
- (void)updateOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;
/*@}*/

@end
