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

/**
 * @brief A JRGamesElement object
 **/
@interface JRGamesElement : JRCaptureObject
@property (nonatomic, readonly) JRObjectId *gamesElementId; /**< Simple identifier for this sub-entity @note The \e id of the object should not be set. */ 
@property (nonatomic, copy)     JRBoolean *isFavorite; /**< If the game is a favorite @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     NSString *name; /**< The name of the game */ 
@property (nonatomic, copy)     JRStringArray *opponents; /**< The object's \e opponents property @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c name */ 
@property (nonatomic, copy)     JRInteger *rating; /**< User's rating of the game @note A ::JRInteger property is a property of type ef typesTable "integer" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithInteger:<em>myInteger</em>]</code>, <code>[NSNumber numberWithInt:<em>myInt</em>]</code>, or <code>nil</code> */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRGamesElement object
 *
 * @return
 *   A JRGamesElement object
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRGamesElement object
 *
 * @return
 *   A JRGamesElement object
 **/
+ (id)gamesElement;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceOpponentsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: Doxygen doc
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
- (BOOL)getIsFavoriteBoolValue;

/**
 * TODO
 **/
- (void)setIsFavoriteWithBool:(BOOL)boolVal;

/**
 * TODO
 **/
- (NSInteger)getRatingIntegerValue;

/**
 * TODO
 **/
- (void)setRatingWithInteger:(NSInteger)integerVal;
/*@}*/

@end
