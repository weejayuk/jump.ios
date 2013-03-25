## Generating the Capture User Model

Get the [JUMP for iOS library](/documentation/mobile-libraries/ios-v2/getting-the-library/ "Getting the Library") and
the required [JSON-2.53+](http://search.cpan.org/~makamaka/JSON-2.53/lib/JSON.pm "JSON-2.53+") perl module.

Change into the script directory:
`$ cd jump.ios/Janrain/JRCapture/Script`

Run the `CaptureSchemaParser.pl` script, passing in your Capture schema as an argument with the `-f` flag:
`$ ./CaptureSchemaParser.pl -f /`

The script sends its output to `jump.ios/Janrain/JRCapture/Classes/CaptureUserModel/Generated/`, which contains the
files necessary to use the Janrain Capture Record Interface from your iOS application.

After you have generated the code, you can
[add the library to Xcode](/documentation/mobile-libraries/jump-for-ios/adding-to-xcode/ "Adding to Xcode").

**Note**: If you've already added the library to Xcode, see
[Adding the Generated User Model](documentation/mobile-libraries/jump-for-ios/adding-to-xcode/#adding-the-generated-capture-user-model).

### Generated Documentation

The script uses Doxygen to generate a full set of documentation for your newly created Objective-C classes using the
attribute descriptions found in the schema. You can find the documentation in the `jump.ios/Docs/JRCapture/html/`
directory.

If you do not have Doxygen installed, the script skips this step automatically. You can still view the inline
documentation found in the Objective-C header files of the generated classes.

## Using the Capture Library

In your application, decide where you want to manage the authenticated Capture user object. You will want to implement
your Capture library interface code in an object that won't go away, such as the `AppDelegate` or a singleton object
that manages your application's data model.

1. Import the Capture header:
`#import "JRCapture.h"`

2. Modify your class to conform to
[JRCaptureSigninDelegate](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_signin_delegate-p.html "JRCaptureSigninDelegate"),
by adding it to the list of delegates. (All the messages of the protocol are optional.)
`@interface MyDataModel : NSObject `

3. Add a captureUser property to your delegate's header (see
[JRCaptureUser](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_user.html "JRCaptureUser")
and [captureUser](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_user.html#a131f0426ed1cfb455a1b13c8e525e697 "captureUser")):
`@property (retain, nonatomic) JRCaptureUser *captureUser;`

4. And synthesize that property in your application delegate's implementation:
`@synthesize captureUser;`

### Configure

To configure the library, pass your Engage Application ID, Capture APID domain, Capture UI domain, Capture Client ID,
and entity type name to the class method `setEngageAppId:captureApidDomain:captureUIDomain:clientId:andEntityTypeName:`
of the `JRCapture` class:

[sourcecode lang="objc"]   ... // Your existing initialization logic here

NSString *appId              = @"your_engage_app_id";
NSString *captureApidDomain  = @"your_capture_apid_base_url";
NSString *captureUIDomain    = @"your_capture_ui_base_url";
NSString *clientId           = @"your_capture_client_id";
NSString *entityTypeName     = @"your_capture_record_type_name";

[JRCapture setEngageAppId:appId captureApidDomain:captureApidDomain
          captureUIDomain:captureUIDomain clientId:clientId
        andEntityTypeName:entityTypeName];[/sourcecode]

**Note**: Typically, your Capture APID domain and Capture UI domain are the same.

## Start the User Sign-In Flow

To launch the authentication process, send the `startEngageSigninForDelegate:` message to the `JRCapture` class:
`[JRCapture startEngageSigninForDelegate:self];`

This starts the Engage sign-in flow, the result of which is sent to Capture. JUMP for iOS then returns a user record, t
hrough a [JRCaptureUser](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_user.html "JRCaptureUser")
instance.

The [JRCaptureSigninDelegate](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_signin_delegate-p.html "JRCaptureSigninDelegate")
protocol defines a set of optional messages your delegate can respond to in order to receive information about the
user's authentication with the Engage and Capture servers. All of the messages in this protocol are optional. As the
flow proceeds, a series of delegate messages will be sent to your delegate.

First, you will receive
[engageSigninDidSucceedForUser:forProvider:](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_signin_delegate-p.html#a39eb082986c4a029cbc8545cc8029c18 "engageSigninDidSucceedForUser:forProvider:")
when Engage authentication is complete. At this point, the library will close the dialog and then complete
authentication headlessly on Capture. This notification will contain limited data which can be used to update UI while
your app waits for Capture to complete authentication.


To receive the user's basic profile data (that is, the [auth_info](/documentation/api/auth_info/ "auth_info") data)
respond to the [engageSigninDidSucceedForUser:forProvider:](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_signin_delegate-p.html#a39eb082986c4a029cbc8545cc8029c18 "engageSigninDidSucceedForUser:forProvider:")
message from the [JRCaptureSigninDelegate](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_signin_delegate-p.html "JRCaptureSigninDelegate")
protocol:

[sourcecode lang="objc"]
- (void)engageSigninDidSucceedForUser:(NSDictionary *)engageAuthInfo
                          forProvider:(NSString *)provider
{
  self.currentDisplayName = [self getDisplayNameFromProfile:engageAuthInfo];

  // Update the UI to show that authentication is completing...
  [self showCompletingSigninMessage];

  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}[/sourcecode]

The basic profile data is included for your information while authentication completes. Once authentication reaches the
Capture server, Capture automatically adds the profile data from your user to the Capture record.

### More

*   For more information on what is returned by Engage, please see the [auth_info](/documentation/api/auth_info/ "auth_info")
    section of the Engage API docs.
*   For more information on the Capture flow, please see [Capture Flow](/documentation/mobile-libraries/#capture-sign-in)
    section of the [Overview](/documentation/mobile-libraries/ "Mobile").

## Finish the User Sign-In Flow

Once the the user record is retrieved from the Capture server, the
[captureAuthenticationDidSucceedForUser:status:](/documentation/api/add_or_update_access_token/ "captureAuthenticationDidSucceedForUser")
message is sent to your delegate. This message passes the [JRCaptureUser](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_user.html "JRCaptureUser")
object and the creation state of the record.

[sourcecode lang="objc"]
- (void)captureAuthenticationDidSucceedForUser:(JRCaptureUser *)newCaptureUser
                                        status:(JRCaptureRecordStatus)captureRecordStatus
{
    // Hold a reference to the current user
    self.captureUser = newCaptureUser;

    // User records can come back with one of three states; have the app
    // act accordingly
    if (captureRecordStatus == JRCaptureRecordMissingRequiredFields)
    {
        // Your schema has required fields that must be filled before
        // the user record can be created (e.g. an email address);
        // collect them
    }
    else if (captureRecordStatus == JRCaptureRecordNewlyCreated)
    {
        // The user has not signed in to Capture before and a new record
        // has been created.

        // You may wish to collect additional data from the user and add it
        // to the user's record, such as an avatar image URL or other
        // relevant personal information
    }
    else if (captureRecordStatus == JRCaptureRecordExists)
    {
        // The user had an existing Capture user record; update the
        // app state to reflect this
    }
}[/sourcecode]

There are three possible values for
[captureRecordStatus:](http://janrain.github.com/jump.ios/gh_docs/capture/html/_j_r_capture_8h.html#a3de9970dfc3458baae757eb39c61da6e "JRCaptureRecordStatus")

[JRCaptureRecordExists](http://janrain.github.com/jump.ios/gh_docs/capture/html/_j_r_capture_8h.html#a3de9970dfc3458baae757eb39c61da6e "JRCaptureRecordStatus")
indicates that the user had an existing Capture record and that record has been retrieved. Your application should
update its state to reflect the user being signed-in.

[JRCaptureRecordNewlyCreated](http://janrain.github.com/jump.ios/gh_docs/capture/html/_j_r_capture_8h.html#a3de9970dfc3458baae757eb39c61da6e "JRCaptureRecordStatus")
indicates that this is a new user and that a new Capture record has been automatically created. Your application may
wish to collect additional new-user information and push that information back to the Capture server.

[JRCaptureRecordMissingRequiredFields](http://janrain.github.com/jump.ios/gh_docs/capture/html/_j_r_capture_8h.html#a3de9970dfc3458baae757eb39c61da6e "JRCaptureRecordStatus")
indicates that this is a new user but that there was not enough information from the social profile data to fill the
required user record fields. (For example, your Capture instance may require an email address, but Twitter social
profiles do not have an email address, so the record cannot be automatically created on Capture when a user signs in
with Twitter.) The partially complete user record is passed back to your application, where it is your application's
responsibility to collect the missing required data and create the user record on Capture:

*   Your application should present a dialog to collect the missing information and any additional information you wish
to collect.
*   Your application should store this information in the
[JRCaptureUser](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_user.html "JRCaptureUser")
instance provided by the
[captureAuthenticationDidSucceedForUser:status:](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_signin_delegate-p.html#aa5dc2ae621394b1a97b55eb3fca6b2ef "captureAuthenticationDidSucceedForUser")
message.
*   Once the profile is complete, your application needs to create the record on Capture, see
[Creating a New Capture User Record](#creating-a-new-capture-user-record) for details.

### More

*   For information about Capture Authentication with Conventional Sign-In, please see
[Example Server-side Authentication App](documentation/mobile-libraries/jump-for-ios/capture-for-ios/capture-ios-examples/#sample-app-code).

## Creating a New Capture User Record

When you set your `captureRecordStatus` to `JRCaptureRecordMissingRequiredFields`, you will need to gather the required
information and create the user on Capture.

1. Add the [JRCaptureUserDelegate](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_user_delegate-p.html "JRCaptureUserDelegate")
protocol conformity to your delegate, as you did with the `JRCaptureSigninDelegate` above:

[sourcecode lang="objc"]@interface MyDelegate : UIResponder <JRCaptureSigninDelegate, JRCaptureUserDelegate>[/sourcecode]

2. Once you have populated the required attributes, send the user creation message:

[sourcecode lang="objc"]- (void)createUserRecordOnCapture
{
[captureUser createOnCaptureForDelegate:self context:nil];
}[/sourcecode]

3. Respond to the `createDidSucceedForUser:context:` message:

[sourcecode lang="objc"]- (void)createDidSucceedForUser:(JRCaptureUser *)user context:(NSObject *)context
{
// Now, update the application state to reflect the newly signed-in user
}[/sourcecode]

### More

*   For more information on Capture authentication with Engage, please
[Conventional Sign-in](/documentation/mobile-libraries/jump-for-ios/capture-for-ios/conventional-sign-in/ "Conventional Sign-in").

## Making Changes in a Capture User Record

Capture user records are structured by the Capture schema, which defines the attributes of the record. An attribute is
either a primitive value (a number, a string, a date, or similar) an object, or a plural.

Primitive attribute values are the actual data that make up your user record. For example, they are your user's
identifier or their email address.

Objects and plurals make up the structure of your user record. For example, in the default Capture schema, the user's
name is represented by an object with six primitive values (strings) used to contain the different parts of the name.
(The six values are `familyName`, `formatted`, `givenName`, `honorificPrefix`, `honorificSuffix`, `middleName`.)
Objects can contain primitive values, sub-objects, or plurals, and those attributes are defined in the schema.

Plurals contain collections of objects, or elements, where an element is just an object stored in a plural. Like
objects, plural elements can contain primitive values, sub-objects, or sub-plurals. Every element in a plural has the
same set of attributes, which are defined in the schema. You can think of a plural as an object that may have
zero-or-more instances. Each instance is called a plural element.

Generating your Capture user model produces Objective-C classes for all your objects and non-string-plural plural
\elements. For example, you will have a `JRName` class which contains `NSString` properties for the six attributes
noted above.

Internally, Capture user record updates occur through one of two mechanisms: updating and replacing. Both updating and
replacing are limited in scope to part of the record, depending on the object from which they are called. Broadly
speaking, parts of the record that are limited to objects can be updated, but to change the plural elements in a plural
you must replace the plural. For example, `JRName` (the users name) is an object and can be updated if the user changes
their name, but `JRInterests` (a plural of strings holding the user's interests) must be replaced if the user adds or
removes an interest.

### Updating Objects (Non-plurals)

Conform to the [JRCaptureObjectDelegate](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_object_delegate-p.html "JRCaptureObjectDelegate")
protocol in your class:

[sourcecode lang="objc"]@interface MyDataModel : UIResponder <JRCaptureSigninDelegate, JRCaptureUserDelegate,
                                    JRCaptureObjectDelegate>[/sourcecode]

Update the object's non-plural properties, and then send the object the
[`updateOnCaptureForDelegate:context:`](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_object.html#a307b20b8cb70eec684e7197550c9f4c3 "updateOnCaptureForDelegate")
 message. For example:

[sourcecode lang="objc"]captureUser.aboutMe = @"Hello. My name is Inigo Montoya.";
[captureUser updateOnCaptureForDelegate:self context:nil];[/sourcecode]

**Note**: Contexts are used across most of the asynchronous Capture methods to facilitate correlation of the response
messages with the calling code. Use of the context is entirely optional. You can use any object which conforms to the
`NSObject` protocol.

You may respond to [`updateDidSucceedForObject:context:`](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_object_delegate-p.html#afa043773e69351fc3115d7ae765986db "updateDidSucceedForObject")
for notification of success:

[sourcecode lang="objc"]- (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
{
  // Successful update
}[/sourcecode]

Similarly [`updateDidFailForObject:withError:context:`](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_object_delegate-p.html#affff9e5fe9d03312a4d5db8b39ba5ff0 "updateDidFailForObject")
will be sent on failure. See [Capture Errors](http://janrain.github.com/jump.ios/gh_docs/capture/html/group__capture_errors.html#ggabc7274cb58c13d8cda35a6554a013de9ac24c5311be2739cfa10797413b2023ca "CaptureErrors")
in the API documentation for possible errors.

You can send the `updateOnCaptureForDelegate:context:` message to the top-level object (a
[JRCaptureUser](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_user.html "JRCaptureUser")
instance) or a sub-object.

**Warning**: When you update an object, the update _does not_ affect plurals inside of that object.

### Replacing Plurals

To add or remove the elements of a plural send the `replace_ArrayName_ArrayOnCaptureForDelegate:context:` message to
the parent-object of the plural.

If you have a schema with a plural attribute named `photos`, Janrain generates a method named
`replacePhotosArrayOnCaptureForDelegate:context:`. So the `_ArrayName_` above is replaced with the actual name of the
array. After updating the plural array invoke
`replace_ArrayName_ArrayOnCaptureForDelegate:context:`, replacing the `_ArrayName_` as appropriate.

For example:

[sourcecode lang="objc"]// Make a new photos plural element:
JRPhotosElement *newPhoto = [[JRPhotosElement alloc] init];
newPhoto.value = @"http://janrain.com/wp-content/uploads/drupal/janrain-logo.png";

// Make a new array with the new element added:
NSMutableArray *newPhotos = [NSMutableArray arrayWithArray:captureUser.photos];
[newPhotos addObject:newPhoto];

// Assign the new array to the photos plural property:
captureUser.photos = newPhotos;

// ... And update the Capture server:
[captureUser replacePhotosArrayOnCaptureForDelegate:self context:nil];[/sourcecode]

**Warning**: The `NSArray` properties used to model plurals are copy-on-set. This means that to modify the array you
must create a new mutable array with the existing array, then modify the mutable array, then assign the mutable array
to the property. (Because the property is copy-on-set further modifications to the copied array will not change the
property.)

## Storing the Capture User Record

When your application terminates, you should save your active user record to local storage. For example, from your
[UIApplicationDelegate](http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UIApplicationDelegate_Protocol/Reference/Reference.html "UIApplicationDelegate"):

[sourcecode lang="objc"]#define cJRCaptureUser @"jr_capture_user"

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Store the Capture user record for use when your app restarts;
  // JRCaptureUser objects conform to NSCoding so you can serialize them with the
  // rest of your app state
  NSUserDefaults *myPreferences = [NSUserDefaults standardUserDefaults];
  [myPreferences setObject:[NSKeyedArchiver archivedDataWithRootObject:captureUser]
                    forKey:cJRCaptureUser];
}[/sourcecode]

Likewise, you should load any saved user record state when your application launches. For example, from your
`UIApplicationDelegate`:

[sourcecode lang="objc"]- (BOOL)          application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSUserDefaults *myPreferences = [NSUserDefaults standardUserDefaults];
  NSData *encodedUser = [myPreferences objectForKey:cJRCaptureUser];
  self.captureUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedUser];
}[/sourcecode]

**Note**: While your application is responsible for saving and restoring the user record the Capture library will
automatically save and restore the session token.

### Next

We recommend that you look at the
[Capture iOS Examples](/documentation/mobile-libraries/jump-for-ios/capture-for-ios/capture-ios-examples/ "Capture iOS Examples")
page.