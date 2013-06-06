First, get the library.

## Get the Library

Whether you are implementing Engage for iOS only, or Engage and Capture for iOS both, you need to get the library.

*   Clone the JUMP for iOS library from GitHub: `git clone git://github.com/janrain/jump.ios.git`
The current version of the library is 3.0, which now includes Capture integration, support for Xcode 4 and iOS 5, an updated social sharing UI, the ability to dynamically exclude providers from the list of sign-in providers or directly authenticate with one provider, better handling when your application quits or goes into the background, and several bug fixes.

**Important**:

*   If you are [upgrading from Engage for iOS version 2.x](/documentation/mobile-libraries/jump-for-android/update-from-janrain-engage-2-x-to-3-x/ "Update from Janrain Engage 2.x to 3.x") see the upgrade page.
*   If you are a Capture customer, we recommend that you generate the [Capture User Model](documentation/mobile-libraries/jump-for-ios/capture-for-ios/#generating-the-capture-user-model) code before adding the library to Xcode, so that you can add it all at once.
**Warning**: If you try to install an older version of Xcode, such as version 3, on a Macintosh machine that also has VMWare Fusion on it, you are likely to experience conflict and cause kernel panics. You may well need to reinstall the OS to resolve this. If you need an old version of Xcode, install it in a Virtual Machine, or a machine that does not have VMWare Fusion.

## Adding the Library to Xcode 4

1.  Open your project in Xcode.
2.  Make sure that the **Project Navigator** pane is showing. (**View &gt; Navigators &gt; Show Project Navigator**)
3.  Open the **Finder** and navigate to the location where you placed the `jump.ios` repository. Drag the **Janrain** folder into your Xcode project’s **Project Navigator** pane, and drop it below the root project node for your application.
4.  This step is different depending on whether you are doing a Social Sign-in (Engage) only integration or a JUMP (Capture) integration.

    1.  If you're doing a Social Sign-in only integration remove the JRCapture project group from the Janrain Project Group.
    2.  If you're doing a JUMP integration, In the dialog, do not check the **Copy items into destination group’s folder (if needed)** box. Ensure that the **Create groups for any added folders** radio button is selected, and that the **Add to targets** check box is selected for your application’s targets.

        [caption id="attachment_19252" align="alignnone" width="286"][![Destination Checkbox](/wp-content/uploads/2012/08/XcodeDestinationCheckbox-286x300.png)](/wp-content/uploads/2012/08/XcodeDestinationCheckbox.png) Figure 1: Destination Checkbox[/caption]

5.  Click **Finish**.
6. You must also add the **Security** framework, **QuartzCore** framework, and the **MessageUI** framework to your 
   project. As the **MessageUI** framework is not available on all iOS devices and versions, you must designate the
   framework as "optional."

## Working with ARC

The JUMP for iOS library does not, itself, use Automatic Reference Counting ([ARC](http://developer.apple.com/library/ios/#releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011226-CH1-SW13)), but you can easily add the library to a project that does.

To use the JUMP for iOS library with an ARC project, please follow these instructions:

1.  Add the Janrain files to your project by following the above instructions for Xcode 4.
2.  Go to your project settings, select your application’s targets and click the **Build Phases** tab.
3.  Expand the section named **Compile Sources**.
4.  Select all the files from the **Janrain** library, including `SFHFKeychainUtils.m` and `JSONKit.m`.
5.  Press **Return** to edit all the files at once, and, in the floating text-box, add the `-fno-objc-arc` compiler flag.
6.  After adding the compiler flag, either click **Done** in the input bubble, or press Return.

## Generating the Capture User Model

**Alert!** If you are integrating with Social Sign-in only, or integrating with Phonegap (now Cordova), do not generate the Capture User Model. Instead, skip ahead to [Engage for iOS](/documentation/mobile-libraries/jump-for-ios/engage-for-ios/ "Engage for iOS").

You should have already installed the [JUMP for iOS library](https://github.com/janrain/jump.ios "JumpForiOSLibrary").

You will also need the [JSON-2.53+](http://search.cpan.org/~makamaka/JSON-2.53/lib/JSON.pm "JSON-2.53+") perl module. To install the perl module, follow these instructions.

**Tip**: If you are not the root user of your computer, use `sudo` commands.

1.  Make sure that perl is installed on your system. If it is not, consider using [MacPorts](http://www.macports.org) or [Homebrew](http://mxcl.github.io/homebrew/).
2.  After you install perl, go [here](http://www.cpan.org/modules/INSTALL.html). Follow the instructions.
Once you have the JSON perl module installed, follow these steps.

1.  Go to the [janraincapture.com](https://www.janraincapture.com/home) dashboard, and sign-in.
2.  Use the **App** drop-down menu to select your Capture app.
3.  Click the **Schema** tab.
4.  Use the Entity Types drop-down menu to select the correct schema. Wait for the page to reload. (If you are already on the correct schema, the page will not reload.)
5.  Click **download schema**.
Once you have downloaded your schema, follow these steps.

1.  Open a terminal window.
2.  Change into the script directory:  `$ cd jump.ios/Janrain/JRCapture/Script`
3.  Run the `CaptureSchemaParser.pl` script, passing in your Capture schema as an argument with the `-f` flag and the path to your Xcode project with the -o flag, as shown here:
`$ ./CaptureSchemaParser.pl -f PATH_TO_YOUR_SCHEMA.JSON -o PATH_TO_YOUR_XCODE_PROJECT_DIRECTORY`

The script writes its output to:

`_&lt;path_to_your_xcode_project_directory&gt;_/JRCapture/Generated/`

That directory contains the Janrain Capture user record model for your iOS application.

## Adding the Generated Capture User Model

Follow these steps to add the generated Capture User Model to your project.

1.  If you have already added the JUMP for iOS library source code to your Xcode project, remove the project group which contains the generated user model first (select **Remove References** when prompted, do not move the files to the trash).
2.  Now, choose **File &gt; Add Files to "your_project"...** then select the folder containing the generated user model, then ensure that the **Destination** checkbox (**Copy items into Destination group's folder**) is not checked. (See Figure 1, above.)
3.  Click **Add**.
4.  Follow the instructions for disabling ARC above, for the project group that you just added.
5.  Make sure that your project builds.

## Upgrading the Library from a Previous Version

To update the library references in Xcode, remove the JREngage group and re-add it.

1.  Open your project in Xcode.
2.  In the **Project Navigator** pane — or the **Groups &amp; Files** pane if you’re using Xcode 3 — locate the **JREngage** folder (group) of your Xcode project.
3.  Right-click the **JREngage** folder and click **Delete**.
4.  In the dialog, make sure you select the **Remove References** button.
5.  Re-add the **JREngage** files following the [instructions for Xcode 4](https://rpxnow.com/docs/iphone#xcode4 "XCode 4"). You shouldn’t have to add the **Security** or **MessageUI** frameworks if you have already done so.
**Warning**: There have been changes to the JREngage API method names. Instance methods have been refactored into class methods (so library usage no longer requires management of a JREngage instance). These changes are only cosmetic and do not change the functionality of the library. Parameters have remained the same.

### Next

For your next steps, see:

[Engage for iOS Guide](/documentation/mobile-libraries/ios-v2/ "Engage for iOS")
[Capture for iOS Guide](/documentation/mobile-libraries/capture-for-ios/ "Capture for iOS")