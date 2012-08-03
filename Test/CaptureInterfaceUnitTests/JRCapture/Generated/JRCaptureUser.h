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
#import "JRBasicPluralElement.h"
#import "JRBasicObject.h"
#import "JRObjectTestRequired.h"
#import "JRPluralTestUniqueElement.h"
#import "JRObjectTestRequiredUnique.h"
#import "JRPluralTestAlphabeticElement.h"
#import "JRPinapL1PluralElement.h"
#import "JRPinoL1Object.h"
#import "JROnipL1PluralElement.h"
#import "JROinoL1Object.h"
#import "JRPinapinapL1PluralElement.h"
#import "JRPinonipL1PluralElement.h"
#import "JRPinapinoL1Object.h"
#import "JRPinoinoL1Object.h"
#import "JROnipinapL1PluralElement.h"
#import "JROinonipL1PluralElement.h"
#import "JROnipinoL1Object.h"
#import "JROinoinoL1Object.h"

/**
 * @brief A JRCaptureUser object
 **/
@interface JRCaptureUser : JRCaptureObject
@property (nonatomic, readonly) JRUuid *uuid; /**< Globally unique indentifier for this entity @note A ::JRUuid property is a property of type \ref typesTable "uuid" and a typedef of \e NSString */ 
@property (nonatomic, readonly) JRDateTime *created; /**< When this entity was created @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, readonly) JRDateTime *lastUpdated; /**< When this entity was last updated @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSString *email; /**< The object's \e email property */ 
@property (nonatomic, copy)     JRBoolean *basicBoolean; /**< Basic boolean property for testing getting/setting with NSNumbers and primitives, updating, and replacing @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     NSString *basicString; /**< Basic string property for testing getting/setting, updating, and replacing */ 
@property (nonatomic, copy)     JRInteger *basicInteger; /**< Basic integer property for testing getting/setting with NSNumbers and primitives, updating, and replacing @note A ::JRInteger property is a property of type \ref typesTable "integer" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithInteger:<em>myInteger</em>]</code>, <code>[NSNumber numberWithInt:<em>myInt</em>]</code>, or <code>nil</code> */ 
@property (nonatomic, copy)     JRDecimal *basicDecimal; /**< Basic decimal property for testing getting/setting with various NSNumbers, updating, and replacing @note A ::JRDecimal property is a property of type \ref typesTable "decimal" and a typedef of \e NSNumber. Accepted values can be, for example, <code>[NSNumber numberWithNumber:<em>myDecimal</em>]</code>, <code>nil</code>, etc. */ 
@property (nonatomic, copy)     JRDate *basicDate; /**< Basic date property for testing getting/setting with various formats, updating, and replacing @note A ::JRDate property is a property of type \ref typesTable "date" and a typedef of \e NSDate. The accepted format should be an ISO 8601 date string (e.g., <code>yyyy-MM-dd</code>) */ 
@property (nonatomic, copy)     JRDateTime *basicDateTime; /**< Basic dateTime property for testing getting/setting with various formats, updating, and replacing @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRIpAddress *basicIpAddress; /**< Basic ipAddress property for testing getting/setting with various formats, updating, and replacing @note A ::JRIpAddress property is a property of type \ref typesTable "ipAddress" and a typedef of \e NSString. */ 
@property (nonatomic, copy)     JRPassword *basicPassword; /**< Property used to test password strings, getting/setting with various formats, updating, and replacing @note A ::JRPassword property is a property of type \ref typesTable "password", which can be either an \e NSString or \e NSDictionary, and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     JRJsonObject *jsonNumber; /**< Property used to test json numbers, getting/setting with various formats, updating, and replacing @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     JRJsonObject *jsonString; /**< Property used to test json strings, getting/setting with various formats, updating, and replacing @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     JRJsonObject *jsonArray; /**< Property used to test json arrays, getting/setting with various formats, updating, and replacing @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     JRJsonObject *jsonDictionary; /**< Property used to test json dictionaries, getting/setting with various formats, updating, and replacing @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSString *stringTestJson; /**< Property used to test getting/setting, updating, and replacing strings that contain valid json objects, json characters, etc. */ 
@property (nonatomic, copy)     NSString *stringTestEmpty; /**< Property used to test getting/setting, updating, and replacing empty strings */ 
@property (nonatomic, copy)     NSString *stringTestNull; /**< Property used to test getting/setting, updating, and replacing null strings */ 
@property (nonatomic, copy)     NSString *stringTestInvalid; /**< Property used to test getting/setting, updating, and replacing strings that contain special or dangerous characters */ 
@property (nonatomic, copy)     NSString *stringTestNSNull; /**< Property used to test getting/setting, updating, and replacing [NSNull null] strings */ 
@property (nonatomic, copy)     NSString *stringTestAlphanumeric; /**< Property used to test getting/setting, updating, and replacing strings that have the 'alphanumeric' constraint */ 
@property (nonatomic, copy)     NSString *stringTestUnicodeLetters; /**< Property used to test getting/setting, updating, and replacing strings that have the 'unicode-letters' constraint */ 
@property (nonatomic, copy)     NSString *stringTestUnicodePrintable; /**< Property used to test getting/setting, updating, and replacing strings that have the 'unicode-printable' constraint */ 
@property (nonatomic, copy)     NSString *stringTestEmailAddress; /**< Property used to test getting/setting, updating, and replacing strings that have the 'email-address' constraint */ 
@property (nonatomic, copy)     NSString *stringTestLength; /**< Property used to test getting/setting, updating, and replacing strings that have the length attribute defined */ 
@property (nonatomic, copy)     NSString *stringTestCaseSensitive; /**< Property used to test getting/setting, updating, and replacing strings that have the case-sensitive attribute defined */ 
@property (nonatomic, copy)     NSString *stringTestFeatures; /**< Property used to test getting/setting, updating, and replacing strings that have the features attribute defined */ 
@property (nonatomic, copy)     NSArray *basicPlural; /**< Basic plural property for testing getting/setting, updating, and replacing @note This is an array of JRBasicPluralElement objects */ 
@property (nonatomic, retain)   JRBasicObject *basicObject; /**< Basic object property for testing getting/setting, updating, and replacing */ 
@property (nonatomic, retain)   JRObjectTestRequired *objectTestRequired; /**< Object for testing getting/setting, updating, and replacing properties when one property has the constraint of being required */ 
@property (nonatomic, copy)     NSArray *pluralTestUnique; /**< Plural for testing getting/setting, updating, and replacing elements when one element property has the constraint of being unique @note This is an array of JRPluralTestUniqueElement objects */ 
@property (nonatomic, retain)   JRObjectTestRequiredUnique *objectTestRequiredUnique; /**< Object for testing getting/setting, updating, and replacing properties when the properties have the constraints of being required and unique */ 
@property (nonatomic, copy)     NSArray *pluralTestAlphabetic; /**< Plural for testing getting/setting, updating, and replacing elements when one element property has the constraint of being alphabetic @note This is an array of JRPluralTestAlphabeticElement objects */ 
@property (nonatomic, copy)     JRStringArray *simpleStringPluralOne; /**< Plural property for testing getting/setting, updating, and replacing lists of strings/JRStringPluralElements @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c simpleTypeOne */ 
@property (nonatomic, copy)     JRStringArray *simpleStringPluralTwo; /**< Another plural property for testing getting/setting, updating, and replacing lists of strings/JRStringPluralElements @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c simpleTypeTwo */ 
@property (nonatomic, copy)     NSArray *pinapL1Plural; /**< Plural in a plural (element in a plural in an element in a plural) @note This is an array of JRPinapL1PluralElement objects */ 
@property (nonatomic, retain)   JRPinoL1Object *pinoL1Object; /**< Plural in an object (element in a plural in an object) */ 
@property (nonatomic, copy)     NSArray *onipL1Plural; /**< Object in a plural (object in an element in a plural) @note This is an array of JROnipL1PluralElement objects */ 
@property (nonatomic, retain)   JROinoL1Object *oinoL1Object; /**< Object in a object */ 
@property (nonatomic, copy)     NSArray *pinapinapL1Plural; /**< Plural in a plural in a plural (element in a plural in an element in a plural in an element in a plural) @note This is an array of JRPinapinapL1PluralElement objects */ 
@property (nonatomic, copy)     NSArray *pinonipL1Plural; /**< Plural in an object in a plural (element in a plural in an object in an element in a plural) @note This is an array of JRPinonipL1PluralElement objects */ 
@property (nonatomic, retain)   JRPinapinoL1Object *pinapinoL1Object; /**< Plural in a plural in an object (element in a plural in an element in a plural in an object) */ 
@property (nonatomic, retain)   JRPinoinoL1Object *pinoinoL1Object; /**< Plural in an object in a object (element in a plural in an object in an object) */ 
@property (nonatomic, copy)     NSArray *onipinapL1Plural; /**< Object in a plural in a plural (object in an element in a plural in an element in a plural) @note This is an array of JROnipinapL1PluralElement objects */ 
@property (nonatomic, copy)     NSArray *oinonipL1Plural; /**< Object in an object in a plural (object in an object in an element in a plural) @note This is an array of JROinonipL1PluralElement objects */ 
@property (nonatomic, retain)   JROnipinoL1Object *onipinoL1Object; /**< Object in a plural in an object (object in an element in a plural in an object) */ 
@property (nonatomic, retain)   JROinoinoL1Object *oinoinoL1Object; /**< Object in an object in a object */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
+ (id)captureUser;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceBasicPluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePluralTestUniqueArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePluralTestAlphabeticArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceSimpleStringPluralOneArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceSimpleStringPluralTwoArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceOnipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePinapinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePinonipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceOnipinapL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceOinonipL1PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

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
 * This method recursively checks all of the sub-objects of JRCaptureUser:
 *   - JRCaptureUser#basicObject
 *   - JRCaptureUser#objectTestRequired
 *   - JRCaptureUser#objectTestRequiredUnique
 *   - JRCaptureUser#pinoL1Object
 *   - JRCaptureUser#oinoL1Object
 *   - JRCaptureUser#pinapinoL1Object
 *   - JRCaptureUser#pinoinoL1Object
 *   - JRCaptureUser#onipinoL1Object
 *   - JRCaptureUser#oinoinoL1Object
 * .
 * @par
 * If any of these objects are new, or if they need to be updated, this method returns \c YES.
 *
 * @warning
 * This method recursively checks all of the sub-objects of JRCaptureUser
 * but does not check any of the arrays of the JRCaptureUser or the arrays' elements:
 *   - JRCaptureUser#basicPlural, JRBasicPluralElement
 *   - JRCaptureUser#pluralTestUnique, JRPluralTestUniqueElement
 *   - JRCaptureUser#pluralTestAlphabetic, JRPluralTestAlphabeticElement
 *   - JRCaptureUser#simpleStringPluralOne, JRSimpleStringPluralOneElement
 *   - JRCaptureUser#simpleStringPluralTwo, JRSimpleStringPluralTwoElement
 *   - JRCaptureUser#pinapL1Plural, JRPinapL1PluralElement
 *   - JRCaptureUser#onipL1Plural, JROnipL1PluralElement
 *   - JRCaptureUser#pinapinapL1Plural, JRPinapinapL1PluralElement
 *   - JRCaptureUser#pinonipL1Plural, JRPinonipL1PluralElement
 *   - JRCaptureUser#onipinapL1Plural, JROnipinapL1PluralElement
 *   - JRCaptureUser#oinonipL1Plural, JROinonipL1PluralElement
 * .
 * @par
 * If you have added or removed any elements from the arrays, you must call the following methods
 * to update the array on Capture: replaceBasicPluralArrayOnCaptureForDelegate:context:(),
 *   replacePluralTestUniqueArrayOnCaptureForDelegate:context:(),
 *   replacePluralTestAlphabeticArrayOnCaptureForDelegate:context:(),
 *   replaceSimpleStringPluralOneArrayOnCaptureForDelegate:context:(),
 *   replaceSimpleStringPluralTwoArrayOnCaptureForDelegate:context:(),
 *   replacePinapL1PluralArrayOnCaptureForDelegate:context:(),
 *   replaceOnipL1PluralArrayOnCaptureForDelegate:context:(),
 *   replacePinapinapL1PluralArrayOnCaptureForDelegate:context:(),
 *   replacePinonipL1PluralArrayOnCaptureForDelegate:context:(),
 *   replaceOnipinapL1PluralArrayOnCaptureForDelegate:context:(),
 *   replaceOinonipL1PluralArrayOnCaptureForDelegate:context:()
 *
 * @par
 * Otherwise, if the array elements' JRCaptureObject#canBeUpdatedOnCapture and JRCaptureObject#needsUpdate returns \c YES, you can update
 * the elements by calling updateOnCaptureForDelegate:context:().
 **/
- (BOOL)needsUpdate;

/**
 * TODO: Doxygen doc
 **/
- (void)updateOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;
/*@}*/

/**
 * @name Primitive Getters/Setters 
 **/
/*@{*/
/**
 * TODO
 **/
- (BOOL)getBasicBooleanBoolValue;

/**
 * TODO
 **/
- (void)setBasicBooleanWithBool:(BOOL)boolVal;

/**
 * TODO
 **/
- (NSInteger)getBasicIntegerIntegerValue;

/**
 * TODO
 **/
- (void)setBasicIntegerWithInteger:(NSInteger)integerVal;
/*@}*/

@end
