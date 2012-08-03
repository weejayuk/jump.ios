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
#import "JRAccountsElement.h"
#import "JRAddressesElement.h"
#import "JRBodyType.h"
#import "JRCurrentLocation.h"
#import "JREmailsElement.h"
#import "JRImsElement.h"
#import "JRName.h"
#import "JROrganizationsElement.h"
#import "JRPhoneNumbersElement.h"
#import "JRProfilePhotosElement.h"
#import "JRUrlsElement.h"

/**
 * @brief A JRProfile object
 **/
@interface JRProfile : JRCaptureObject
@property (nonatomic, copy)     NSString *aboutMe; /**< A general statement about the person. */ 
@property (nonatomic, copy)     NSArray *accounts; /**< Describes an account held by this Contact, which MAY be on the Service Provider's service, or MAY be on a different service. @note This is an array of JRAccountsElement objects */ 
@property (nonatomic, copy)     NSArray *addresses; /**< A physical mailing address for this Contact. @note This is an array of JRAddressesElement objects */ 
@property (nonatomic, copy)     JRDate *anniversary; /**< The wedding anniversary of this contact. @note A ::JRDate property is a property of type \ref typesTable "date" and a typedef of \e NSDate. The accepted format should be an ISO 8601 date string (e.g., <code>yyyy-MM-dd</code>) */ 
@property (nonatomic, copy)     NSString *birthday; /**< The birthday of this contact. */ 
@property (nonatomic, retain)   JRBodyType *bodyType; /**< Person's body characteristics. */ 
@property (nonatomic, copy)     JRStringArray *books; /**< Person's favorite books. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c book */ 
@property (nonatomic, copy)     JRStringArray *cars; /**< Person's favorite cars. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c car */ 
@property (nonatomic, copy)     JRStringArray *children; /**< Description of the person's children. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c value */ 
@property (nonatomic, retain)   JRCurrentLocation *currentLocation; /**< The object's \e currentLocation property */ 
@property (nonatomic, copy)     NSString *displayName; /**< The name of this Contact, suitable for display to end-users. */ 
@property (nonatomic, copy)     NSString *drinker; /**< Person's drinking status. */ 
@property (nonatomic, copy)     NSArray *emails; /**< E-mail address for this Contact. @note This is an array of JREmailsElement objects */ 
@property (nonatomic, copy)     NSString *ethnicity; /**< Person's ethnicity. */ 
@property (nonatomic, copy)     NSString *fashion; /**< Person's thoughts on fashion. */ 
@property (nonatomic, copy)     JRStringArray *food; /**< Person's favorite food. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c food */ 
@property (nonatomic, copy)     NSString *gender; /**< The gender of this contact. */ 
@property (nonatomic, copy)     NSString *happiestWhen; /**< Describes when the person is happiest. */ 
@property (nonatomic, copy)     JRStringArray *heroes; /**< Person's favorite heroes. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c hero */ 
@property (nonatomic, copy)     NSString *humor; /**< Person's thoughts on humor. */ 
@property (nonatomic, copy)     NSArray *ims; /**< Instant messaging address for this Contact. @note This is an array of JRImsElement objects */ 
@property (nonatomic, copy)     NSString *interestedInMeeting; /**< The object's \e interestedInMeeting property */ 
@property (nonatomic, copy)     JRStringArray *interests; /**< Person's interests, hobbies or passions. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c interest */ 
@property (nonatomic, copy)     JRStringArray *jobInterests; /**< Person's favorite jobs, or job interests and skills. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c jobInterest */ 
@property (nonatomic, copy)     JRStringArray *languages; /**< The object's \e languages property @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c language */ 
@property (nonatomic, copy)     JRStringArray *languagesSpoken; /**< List of the languages that the person speaks as ISO 639-1 codes. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c languageSpoken */ 
@property (nonatomic, copy)     NSString *livingArrangement; /**< Description of the person's living arrangement. */ 
@property (nonatomic, copy)     JRStringArray *lookingFor; /**< Person's statement about who or what they are looking for, or what they are interested in meeting people for. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c value */ 
@property (nonatomic, copy)     JRStringArray *movies; /**< Person's favorite movies. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c movie */ 
@property (nonatomic, copy)     JRStringArray *music; /**< Person's favorite music. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c music */ 
@property (nonatomic, retain)   JRName *name; /**< The object's \e name property */ 
@property (nonatomic, copy)     NSString *nickname; /**< The casual way to address this Contact in real life */ 
@property (nonatomic, copy)     NSString *note; /**< Notes about this person, with an unspecified meaning or usage. */ 
@property (nonatomic, copy)     NSArray *organizations; /**< Describes a current or past organizational affiliation of this contact. @note This is an array of JROrganizationsElement objects */ 
@property (nonatomic, copy)     JRStringArray *pets; /**< Description of the person's pets @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c value */ 
@property (nonatomic, copy)     NSArray *phoneNumbers; /**< Phone number for this Contact. @note This is an array of JRPhoneNumbersElement objects */ 
@property (nonatomic, copy)     NSArray *profilePhotos; /**< URL of a photo of this contact. @note This is an array of JRProfilePhotosElement objects */ 
@property (nonatomic, copy)     NSString *politicalViews; /**< Person's political views. */ 
@property (nonatomic, copy)     NSString *preferredUsername; /**< The preferred username of this contact on sites that ask for a username. */ 
@property (nonatomic, copy)     NSString *profileSong; /**< URL of a person's profile song. */ 
@property (nonatomic, copy)     NSString *profileUrl; /**< Person's profile URL, specified as a string. */ 
@property (nonatomic, copy)     NSString *profileVideo; /**< URL of a person's profile video. */ 
@property (nonatomic, copy)     JRDateTime *published; /**< The date this Contact was first added to the user's address book or friends list. @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRStringArray *quotes; /**< Person's favorite quotes @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c quote */ 
@property (nonatomic, copy)     NSString *relationshipStatus; /**< Person's relationship status. */ 
@property (nonatomic, copy)     JRStringArray *relationships; /**< A bi-directionally asserted relationship type that was established between the user and this contact by the Service Provider. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c relationship */ 
@property (nonatomic, copy)     NSString *religion; /**< Person's religion or religious views. */ 
@property (nonatomic, copy)     NSString *romance; /**< Person's comments about romance. */ 
@property (nonatomic, copy)     NSString *scaredOf; /**< What the person is scared of. */ 
@property (nonatomic, copy)     NSString *sexualOrientation; /**< Person's sexual orientation. */ 
@property (nonatomic, copy)     NSString *smoker; /**< Person's smoking status. */ 
@property (nonatomic, copy)     JRStringArray *sports; /**< Person's favorite sports @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c sport */ 
@property (nonatomic, copy)     NSString *status; /**< Person's status, headline or shout-out. */ 
@property (nonatomic, copy)     JRStringArray *tags; /**< A user-defined category or label for this contact. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c tag */ 
@property (nonatomic, copy)     JRStringArray *turnOffs; /**< Person's turn offs. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c turnOff */ 
@property (nonatomic, copy)     JRStringArray *turnOns; /**< Person's turn ons. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c turnOn */ 
@property (nonatomic, copy)     JRStringArray *tvShows; /**< Person's favorite TV shows. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c tvShow */ 
@property (nonatomic, copy)     JRDateTime *updated; /**< The most recent date the details of this Contact were updated. @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSArray *urls; /**< URL of a web page relating to this Contact. @note This is an array of JRUrlsElement objects */ 
@property (nonatomic, copy)     NSString *utcOffset; /**< The offset from UTC of this Contact's current time zone. */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRProfile object
 *
 * @return
 *   A JRProfile object
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRProfile object
 *
 * @return
 *   A JRProfile object
 **/
+ (id)profile;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceAccountsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceAddressesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceBooksArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceCarsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceChildrenArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceEmailsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceFoodArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceHeroesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceImsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceInterestsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceJobInterestsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceLanguagesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceLanguagesSpokenArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceLookingForArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceMoviesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceMusicArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceOrganizationsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePetsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replacePhoneNumbersArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceProfilePhotosArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceQuotesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceRelationshipsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceSportsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceTagsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceTurnOffsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceTurnOnsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceTvShowsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * TODO: DOXYGEN DOCS
 **/
- (void)replaceUrlsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

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
 * This method recursively checks all of the sub-objects of JRProfile:
 *   - JRProfile#bodyType
 *   - JRProfile#currentLocation
 *   - JRProfile#name
 * .
 * @par
 * If any of these objects are new, or if they need to be updated, this method returns \c YES.
 *
 * @warning
 * This object, or one of its ancestors, is an element of a plural. If any elements of the plural have changed,
 * (added or removed) the array must be replaced on Capture before the elements or their sub-objects can be
 * updated. Please use the appropriate <code>replace&lt;<em>ArrayName</em>&gt;ArrayOnCaptureForDelegate:context:</code>
 * method first. Even if JRCaptureObject#needsUpdate returns \c YES, this object cannot be updated on Capture unless
 * JRCaptureObject#canBeUpdatedOnCapture also returns \c YES.
 *
 * @par
 * This method recursively checks all of the sub-objects of JRProfile
 * but does not check any of the arrays of the JRProfile or the arrays' elements:
 *   - JRProfile#accounts, JRAccountsElement
 *   - JRProfile#addresses, JRAddressesElement
 *   - JRProfile#books, JRBooksElement
 *   - JRProfile#cars, JRCarsElement
 *   - JRProfile#children, JRChildrenElement
 *   - JRProfile#emails, JREmailsElement
 *   - JRProfile#food, JRFoodElement
 *   - JRProfile#heroes, JRHeroesElement
 *   - JRProfile#ims, JRImsElement
 *   - JRProfile#interests, JRInterestsElement
 *   - JRProfile#jobInterests, JRJobInterestsElement
 *   - JRProfile#languages, JRLanguagesElement
 *   - JRProfile#languagesSpoken, JRLanguagesSpokenElement
 *   - JRProfile#lookingFor, JRLookingForElement
 *   - JRProfile#movies, JRMoviesElement
 *   - JRProfile#music, JRMusicElement
 *   - JRProfile#organizations, JROrganizationsElement
 *   - JRProfile#pets, JRPetsElement
 *   - JRProfile#phoneNumbers, JRPhoneNumbersElement
 *   - JRProfile#profilePhotos, JRProfilePhotosElement
 *   - JRProfile#quotes, JRQuotesElement
 *   - JRProfile#relationships, JRRelationshipsElement
 *   - JRProfile#sports, JRSportsElement
 *   - JRProfile#tags, JRTagsElement
 *   - JRProfile#turnOffs, JRTurnOffsElement
 *   - JRProfile#turnOns, JRTurnOnsElement
 *   - JRProfile#tvShows, JRTvShowsElement
 *   - JRProfile#urls, JRUrlsElement
 * .
 * @par
 * If you have added or removed any elements from the arrays, you must call the following methods
 * to update the array on Capture: replaceAccountsArrayOnCaptureForDelegate:context:(),
 *   replaceAddressesArrayOnCaptureForDelegate:context:(),
 *   replaceBooksArrayOnCaptureForDelegate:context:(),
 *   replaceCarsArrayOnCaptureForDelegate:context:(),
 *   replaceChildrenArrayOnCaptureForDelegate:context:(),
 *   replaceEmailsArrayOnCaptureForDelegate:context:(),
 *   replaceFoodArrayOnCaptureForDelegate:context:(),
 *   replaceHeroesArrayOnCaptureForDelegate:context:(),
 *   replaceImsArrayOnCaptureForDelegate:context:(),
 *   replaceInterestsArrayOnCaptureForDelegate:context:(),
 *   replaceJobInterestsArrayOnCaptureForDelegate:context:(),
 *   replaceLanguagesArrayOnCaptureForDelegate:context:(),
 *   replaceLanguagesSpokenArrayOnCaptureForDelegate:context:(),
 *   replaceLookingForArrayOnCaptureForDelegate:context:(),
 *   replaceMoviesArrayOnCaptureForDelegate:context:(),
 *   replaceMusicArrayOnCaptureForDelegate:context:(),
 *   replaceOrganizationsArrayOnCaptureForDelegate:context:(),
 *   replacePetsArrayOnCaptureForDelegate:context:(),
 *   replacePhoneNumbersArrayOnCaptureForDelegate:context:(),
 *   replaceProfilePhotosArrayOnCaptureForDelegate:context:(),
 *   replaceQuotesArrayOnCaptureForDelegate:context:(),
 *   replaceRelationshipsArrayOnCaptureForDelegate:context:(),
 *   replaceSportsArrayOnCaptureForDelegate:context:(),
 *   replaceTagsArrayOnCaptureForDelegate:context:(),
 *   replaceTurnOffsArrayOnCaptureForDelegate:context:(),
 *   replaceTurnOnsArrayOnCaptureForDelegate:context:(),
 *   replaceTvShowsArrayOnCaptureForDelegate:context:(),
 *   replaceUrlsArrayOnCaptureForDelegate:context:()
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

@end
