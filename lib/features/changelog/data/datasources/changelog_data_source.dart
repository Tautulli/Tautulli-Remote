Map changelog = {
  "data": [
    {
      "version": "v3.4.1",
      "date": "June 19, 2025",
      "changes": [
        {
          "type": "important",
          "detail":
              "Plex appears to have changed how deep linking into their app works with the new version. Until the new method is discovered the \"View On Plex\" functionality has been removed.",
        },
        {
          "type": "improvement",
          "detail": "New translations for Hungarian",
          "additional": "Thanks @ugyes",
        },
        {
          "type": "fix",
          "detail": "Prevent situations where the bottom sheet could render behind the navigation bar on Android",
        },
        {
          "type": "fix",
          "detail": "Account for when Location is null",
        },
      ],
    },
    {
      "version": "v3.4.0",
      "date": "June 8, 2025",
      "changes": [
        {
          "type": "important",
          "detail": "Donations have been re-enabled, any support you can provide is appreciated!",
        },
        {
          "type": "improvement",
          "detail": "Underscores no longer cause connection address to fail URL validation",
        },
        {
          "type": "improvement",
          "detail": "Added monochrome icon support on Android",
        },
        {
          "type": "improvement",
          "detail": "Migrate OneSignal notifications to v5",
        },
        {
          "type": "improvement",
          "detail": "Update Flutter version/packages and underlying Android/iOS code",
        },
        {
          "type": "improvement",
          "detail": "New translations for Hungarian, Italian, Swedish, Russian, and Portuguese (Portugal)",
          "additional": "Thanks @ugyes, @Pantanet96, @burk80, Ivan, Maksim_220 Кабанов, & @SantosSi",
        },
        {
          "type": "fix",
          "detail": "Re-enabled app version update check",
        },
        {
          "type": "fix",
          "detail": "Re-enabled donation code as it no longer is conflicting with notification code",
        },
      ],
    },
    {
      "version": "v3.3.1",
      "date": "October 21, 2024",
      "changes": [
        {
          "type": "improvement",
          "detail": "Added app version and build number to data dump page",
        },
        {
          "type": "improvement",
          "detail": "New translations for Catalan and Dutch",
          "additional": "Thanks @dtalens and @jonathan2oo7",
        },
        {
          "type": "fix",
          "detail": "Temporarily disable in-app update check due to issues with package used providing incorrect results",
        },
      ],
    },
    {
      "version": "v3.3.0",
      "date": "September 23, 2024",
      "changes": [
        {
          "type": "important",
          "detail":
              "There is currently a compatibility issue between the donation and notification packages used by Tautulli Remote. In order to ensure continued notification functionality, new donations have been temporarily disabled.",
        },
        {
          "type": "new",
          "detail": "Added the ability for OTA updates for troubleshooting difficult issues",
        },
        {
          "type": "improvement",
          "detail": "Save filter selection for Recently Added and History",
        },
        {
          "type": "improvement",
          "detail": "Added playback percent in activity sheet",
          "additional": "Thanks @micahmo",
        },
        {
          "type": "improvement",
          "detail": "Consider player name as sensitive when 'Mask Sensitive Info' is enabled",
          "additional": "Thanks @micahmo",
        },
        {
          "type": "improvement",
          "detail": "Updated Android package requirements",
        },
        {
          "type": "improvement",
          "detail": "Updated Flutter and dependencies",
        },
        {
          "type": "improvement",
          "detail": "New translations for Italian, Swedish, and Ukrainian",
          "additional": "Thanks @blackne0n, @MushK87, and @Michael5564445",
        },
      ],
    },
    {
      "version": "v3.2.4",
      "date": "April 11, 2024",
      "changes": [
        {
          "type": "important",
          "detail":
              "After an update OneSignal may need to re-register, please make sure the banner on the Settings page is gone before you attempt to test notifications",
        },
        {
          "type": "improvement",
          "detail": "Improved the encryption method for notifications",
          "additional": "Requires Tautulli v2.14.0 or later",
        },
        {
          "type": "improvement",
          "detail": "Further improvements to avoid loss of OneSignal ID registered with Tautulli",
        },
        {
          "type": "improvement",
          "detail": "Added Ukrainian language",
        },
        {
          "type": "improvement",
          "detail": "New translations for Burmese, Hungarian, Polish, Spanish, and Ukrainian",
          "additional": "Thanks gnu-ewm, @novamaxxhu, @evoke0, and @Michael5564445",
        },
      ],
    },
    {
      "version": "v3.2.3",
      "date": "February 1, 2024",
      "changes": [
        {
          "type": "new",
          "detail": "Added the ability to customize the home page under Settings > Advanced",
        },
        {
          "type": "improvement",
          "detail": "Added users filter to the graphs page",
        },
        {
          "type": "improvement",
          "detail": "Upgraded Flutter version and dependencies",
        },
        {
          "type": "improvement",
          "detail": "Added additional console logging",
        },
        {
          "type": "improvement",
          "detail": "Added Myanmar and Bulgarian languages",
        },
        {
          "type": "improvement",
          "detail": "New translations for Hungarian and Portuguese (Brazil)",
          "additional": "Thanks pzsolti92 and RsPlay",
        },
      ],
    },
    {
      "version": "v3.2.2",
      "date": "November 1, 2023",
      "changes": [
        {
          "type": "fix",
          "detail": "Unencrypted notification will display on Android if fetching image times out",
        },
      ],
    },
    {
      "version": "v3.2.1",
      "date": "October 27, 2023",
      "changes": [
        {
          "type": "improvement",
          "detail": "Adjusted post-update registration to avoid possible race condition that would clear OneSignal Device ID",
          "additional": "If you continue to see this problem after updating please submit a bug report",
        },
        {
          "type": "fix",
          "detail": "Notifications on Android no longer fail when images are enabled but no image is provided",
        },
      ],
    },
    {
      "version": "v3.2.0",
      "date": "October 26, 2023",
      "changes": [
        {
          "type": "new",
          "detail": "Added support for new Concurrent Stream Per Day graph",
          "additional": "Requires Tautulli v2.13.2+",
        },
        {
          "type": "improvement",
          "detail": "Added support for new quarter value icons for history watch status",
          "additional": "Requires Tautulli v2.13.2+",
        },
        {
          "type": "improvement",
          "detail": "Added new in app check to try and avoid OneSignal consent resets",
          "additional": "If you continue to see this problem after updating please submit a bug report",
        },
        {
          "type": "improvement",
          "detail": "Added additional console logging for notification troubleshooting",
        },
        {
          "type": "improvement",
          "detail": "New translations for French",
          "additional": "Thanks @EricG66",
        },
        {
          "type": "fix",
          "detail": "Reverted graph colors to Tautulli color palette regardless of theme to avoid contrast issues",
        },
      ],
    },
    {
      "version": "v3.1.0",
      "date": "September 1, 2023",
      "changes": [
        {
          "type": "new",
          "detail": "Tautulli Remote now has themes, choose a color to inspire the look of the app, Android users can also leverage their system theme color",
          "additional": "Head to Settings > Themes to try it out",
        },
        {
          "type": "new",
          "detail": "iOS notifications now support images",
          "additional": "This needs to be configured inside Tautulli v2.13.0 or higher",
        },
        {
          "type": "new",
          "detail": "Tapping a notification for watched or recently added items will open up the history and recently added pages respectively",
        },
        {
          "type": "new",
          "detail": "An accessibility option has been added to disable background images",
        },
        {
          "type": "improvement",
          "detail": "Accessibility options have been moved to a dedicated page under Settings",
        },
        {
          "type": "improvement",
          "detail": "Empty activity message will not display before activity is initially loaded",
        },
        {
          "type": "improvement",
          "detail": "Updated to a new grabbable scrollbar for media lists",
        },
        {
          "type": "improvement",
          "detail": "Exporting Tautulli Remote logs now leverages the OS share functionality",
        },
        {
          "type": "improvement",
          "detail": "The setup wizard now includes pages for themes and accessibility settings",
        },
        {
          "type": "improvement",
          "detail": "Improvement to QuickActions implementation",
        },
        {
          "type": "improvement",
          "detail": "Improve consistency when detecting device platform",
        },
        {
          "type": "improvement",
          "detail": "Improve how OneSignal notifications are processed",
        },
        {
          "type": "improvement",
          "detail": "Upgraded to Flutter 3.13.0",
        },
        {
          "type": "improvement",
          "detail": "New translations for French, Slovenian, Spanish, and Swedish",
          "additional": "Thanks Miguel, @Miha-2, @carichesman, and @MushK87",
        },
        {
          "type": "fix",
          "detail": "Setup wizard will no longer incorrectly mark as complete",
        },
        {
          "type": "fix",
          "detail": "Server activity info card will no longer always display the info from the first server",
        },
        {
          "type": "fix",
          "detail": "Unknown audio and subtitle languages will now display correctly",
        },
        {
          "type": "fix",
          "detail": "User history will properly display if there is no new history to fetch",
        },
        {
          "type": "fix",
          "detail": "Quick actions will no longer cause the inner drawer to consistently force close if app was already open on the quick action destination",
        },
        {
          "type": "fix",
          "detail": "Grouped notifications on Android now use the correct icon and color",
        },
      ],
    },
    {
      "version": "v3.0.4",
      "date": "August 1, 2023",
      "changes": [
        {
          "type": "new",
          "detail": "Added the option to use Atkinson Hyperlegible font",
          "additional": "This is available under the new Accessibility section in Settings > Advanced",
        },
        {
          "type": "new",
          "detail": "A banner is now displayed under Settings when there is an update available for Tautulli Remote",
        },
        {
          "type": "new",
          "detail": "Added a prompt to leave a review for Tautulli Remote",
          "additional":
              "In order to be prompted to leave a review you need to have v3.0.4+ installed for 30 days AND opened the app 60 times, selecting 'Later' will postpone for another 90 days and 30 opens, and selecting 'Don't ask again' does just that",
        },
        {
          "type": "improvement",
          "detail": "Audio and subtitle languages are now displayed under activity details",
        },
        {
          "type": "improvement",
          "detail": "Adjusted content of the activity details buttons",
        },
        {
          "type": "improvement",
          "detail": "New translations for Dutch, Polish, and Spanish",
          "additional": "Thanks @zucht, Marek, @mateusz-bak, @Chefski, and @jab3",
        },
      ],
    },
    {
      "version": "v3.0.3",
      "date": "June 22, 2023",
      "changes": [
        {
          "type": "new",
          "detail": "v3 now runs on iOS",
        },
        {
          "type": "improvement",
          "detail": "New translations for Danish and Portuguese (Brazil)",
          "additional": "Thanks Tntdruid and brunogiroleti",
        },
        {
          "type": "fix",
          "detail": "Update gradle versions for Android.",
        },
      ],
    },
    {
      "version": "v3.0.2",
      "date": "April 11, 2023",
      "changes": [
        {
          "type": "improvement",
          "detail": "New translations for Catalan",
          "additional": "Thanks @dtalens",
        },
        {
          "type": "fix",
          "detail": "Using a quick action will no longer cause the activity page to be stuck in the loading state",
        },
      ],
    },
    {
      "version": "v3.0.1",
      "date": "April 4, 2023",
      "changes": [
        {
          "type": "improvement",
          "detail": "New translations for Catalan, French, and German",
          "additional": "Thanks @dtalens, @c0nsideration, and lackmake",
        },
        {
          "type": "fix",
          "detail": "Using either Portuguese language options no longer causes the app to break",
        },
        {
          "type": "fix",
          "detail": "Custom header refactor process when upgrading from v2 to v3 will no longer cause the app to lock up for some users",
        },
      ],
    },
    {
      "version": "v3.0.0",
      "date": "March 11, 2023",
      "intro":
          "After many months of work the initial release for Tautulli Remote v3 is finally here!\nThis is a complete rewrite of the app, so please review the \"note\" entries below for some important information.",
      "changes": [
        {
          "type": "important",
          "detail": "Your servers have been migrated over from v2 but app settings (including OneSignal) will need to be updated",
        },
        {
          "type": "important",
          "detail": "Tautulli v2.10.5+ is recommended to avoid issues with loading some images",
          "additional": "New servers being registered will require Tautulli 2.10.5 or higher",
        },
        {
          "type": "important",
          "detail": "Multiserver activity is now disabled by default and can be enabled under Settings > Advanced Settings",
          "additional": "As a reminder this allows you to view the activity for all your registered servers on a single page",
        },
        {
          "type": "important",
          "detail": "Some existing translation work was lost due to the app changes, go to Settings > Help Translate to learn how you can contribute",
          "additional":
              "Thank you to all those who have provided translations so far, you are too many to list in a single update but I will keep calling you out directly in future updates",
        },
        {
          "type": "new",
          "detail": "The app has had an entire visual overhaul, improving look, usability, and bringing it in more line with Material Design 3",
          "additional": "I am investigating a more native look for Apple devices",
        },
        {
          "type": "new",
          "detail": "Landscape mode is now supported",
        },
        {
          "type": "new",
          "detail": "You can long press the app icon to select a quick actions and jump to activity, history, recently added, or settings",
        },
        {
          "type": "new",
          "detail": "The multiserver selector has been moved to the inner drawer",
        },
        {
          "type": "new",
          "detail": "The activity page will display multiple cards in a row on larger screens",
        },
        {
          "type": "new",
          "detail": "The history page now has a search feature",
        },
        {
          "type": "new",
          "detail": "A new data dump page has been added under the More section of Settings to assist with troubleshooting",
        },
        {
          "type": "new",
          "detail": "There is now the ability to clear the Tautulli server image cache under the server's settings page",
        },
        {
          "type": "new",
          "detail": "The library media full refresh action can now be disabled under Settings > Advanced",
        },
        {
          "type": "improvement",
          "detail": "The following languages have been added: Albanian, Chinese, Norwegian Bokmål, Polish, Slovak",
        },
        {
          "type": "improvement",
          "detail": "The activity page now displays more summary information for active streams",
        },
        {
          "type": "improvement",
          "detail": "The history page has improved filter options",
        },
        {
          "type": "improvement",
          "detail": "The selected \"stats type\" on the statistics page is now saved",
        },
        {
          "type": "improvement",
          "detail": "Card heights will scale based on the system font size",
          "additional":
              "This will make more data visible at larger font sizes, but will have diminishing returns. If you are directly impacted by this please reach out so we can work to improve the behavior.",
        },
        {
          "type": "improvement",
          "detail": "Donate page items will display in local currency",
        },
        {
          "type": "improvement",
          "detail": "OneSignal debug logging is available for more in depth troubleshooting",
          "additional": "This logging needs to be accessed with Logcat (Android) or Xcode (iOS)",
        },
        {
          "type": "fix",
          "detail": "Activity items now correctly display HDR for HDR10 and DV content",
        },
      ],
    },
    {
      "version": "v2.13.3",
      "date": "March 24, 2022",
      "changes": [
        {
          "type": "improvement",
          "detail": "Update to Flutter 2.10.3",
        },
        {
          "type": "fix",
          "detail": "Fix missing loading indicator on Activity page",
        },
      ],
    },
    {
      "version": "v2.13.2",
      "date": "October 31, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail": "Announcements can now target Android or iOS specifically",
        },
        {
          "type": "improvement",
          "detail": "Added transcode decision to history details",
        },
        {
          "type": "improvement",
          "detail": "New translations for Danish, French, German, Hungarian, and Slovak",
          "additional": "Thanks @starscream10, @NathanBnm, @iophobia, @MaddionMax, and @johny106",
        },
        {
          "type": "fix",
          "detail": "Activity details would break when some expected data was missing",
        },
      ],
    },
    {
      "version": "v2.13.1",
      "date": "October 12, 2021",
      "changes": [
        {
          "type": "fix",
          "detail": "Would fail to update OneSignal information without custom headers",
        },
      ],
    },
    {
      "version": "v2.13.0",
      "date": "September 30, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Added support for custom HTTP headers",
          "additional": "Use the prebuilt Basic Auth header or set your own custom ones.",
        },
        {
          "type": "new",
          "detail": "Added Slovak language",
        },
        {
          "type": "improvement",
          "detail": "Updated Flutter and packages",
        },
        {
          "type": "improvement",
          "detail": "New translations for Catalan, Danish, Hungarian, Italian, Russian, and Slovak",
          "additional": "Thanks @dtalens, @ThomasCSR, @MaddionMax, @janus158, @barbuddah, and @johny106",
        },
        {
          "type": "fix",
          "detail": "Long track names could overflow",
        },
        {
          "type": "fix",
          "detail": "Refresh Rate setting would say 'Default' instead of 'Disabled'.",
        },
      ],
    },
    {
      "version": "v2.12.3",
      "date": "September 5, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail": "The iOS app no longer requires the app tracking permission",
          "additional": "Existing users can safely disable this permission.",
        },
      ],
    },
    {
      "version": "v2.12.2",
      "date": "September 2, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Added Czech and Russian languages",
        },
        {
          "type": "improvement",
          "detail": "New translations for Czech, Portuguese (Brazil), and Russian",
          "additional": "Thanks @karelkryda, @neitzke, and @barbuddah",
        },
        {
          "type": "improvement",
          "detail": "Add support for null safe code",
        },
        {
          "type": "fix",
          "detail": "Android notifications would fail when an Image Type was set in Tautulli",
        },
      ],
    },
    {
      "version": "v2.12.1",
      "date": "August 31, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "The app drawer has been changed into a new inner drawer, swipe right to easily reveal the drawer",
        },
        {
          "type": "new",
          "detail": "Added Catalan and Danish languages",
        },
        {
          "type": "improvement",
          "detail": "Network images are now cached, this cache can be cleared under Advanced Settings",
        },
        {
          "type": "improvement",
          "detail": "New translations for Catalan, Danish, Dutch, French, German, Hungarian, Italian, Portuguese (Brazil), Portuguese (Portugal), and Swedish",
          "additional": "Thanks @dtalens, @Tntdruid, @raoul-m, @bninot, @NathanBnm, @TautulliPiece, @MaddionMax, @janus158, @taduo, @Bllstc, and @bittin",
        },
        {
          "type": "improvement",
          "detail": "Added a quit button to the setup Wizard",
        },
        {
          "type": "fix",
          "detail": "Enabling iOS notifications now requires the tracking permission",
          "additional": "This change was requested by Apple, there has been no change to the data collected",
        },
        {
          "type": "fix",
          "detail": "iOS notifications would wait to timeout before displaying",
        },
        {
          "type": "fix",
          "detail": "Unencrypted iOS notifications were incorrect",
        },
        {
          "type": "fix",
          "detail": "Fixed history details buttons being clipped on some devices",
        },
        {
          "type": "fix",
          "detail": "Registration update could send a blank OneSignal Device ID after app version update",
        },
      ],
    },
    {
      "version": "v2.11.2",
      "date": "July 30, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail": "New translations for Dutch, Portuguese (Brazil), Spanish, and German",
          "additional": "Thanks @Zucht, @RubenKremer, @neitzke, @CMBoii, @granjerox, and @Jerome2103",
        },
        {
          "type": "improvement",
          "detail": "Added splash screen for iOS",
        },
        {
          "type": "improvement",
          "detail": "Add advanced setting to change app language rather than rely only on the system setting",
        },
        {
          "type": "improvement",
          "detail": "Add option to change app language from the setup wizard",
        },
        {
          "type": "improvement",
          "detail": "Moved Double Tap to Exit (Android) and Mask Sensitive Info under new Advanced Settings menu",
        },
        {
          "type": "fix",
          "detail": "Fix Swedish translations not working",
        },
        {
          "type": "fix",
          "detail": "Live TV history would display null for missing episode/season number",
        },
        {
          "type": "fix",
          "detail": "Read more/less text for summaries was flipped",
        },
      ],
    },
    {
      "version": "v2.11.1",
      "date": "July 17, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail": "New translations for Dutch",
          "additional": "Thanks @Zucht",
        },
        {
          "type": "improvement",
          "detail": "Change display name to 'Tautulli' on iOS",
        },
        {
          "type": "fix",
          "detail": "Fixed translations not loading",
        },
        {
          "type": "fix",
          "detail": "OS font size could cause issues with text layout",
        },
      ],
    },
    {
      "version": "v2.11.0",
      "date": "July 15, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "The Android app is moving to stable, beta testing will continue as part of the Tautulli Remote development cycle",
        },
        {
          "type": "new",
          "detail": "iOS support is here, the iOS app is now in beta",
        },
        {
          "type": "improvement",
          "detail": "New translations for French, German, Swedish, and Spanish",
          "additional": "Thanks @NathanBnm, @Jerome2013, and @ferrangar",
        },
        {
          "type": "fix",
          "detail": "Resolve issue where app could display black screen on resume",
        },
        {
          "type": "fix",
          "detail": "'Buy Me A Slice' donation level has been reduced on Android to 2.99 USD to match Apple restrictions",
        },
        {
          "type": "fix",
          "detail": "Adjust how the changelog is triggered on starting a new app version (to support iOS)",
        },
      ],
    },
    {
      "version": "v2.10.0",
      "date": "June 16, 2021",
      "changes": [
        {
          "type": "important",
          "detail": "Due to a OneSignal SDK change please re-accept the OneSignal Data Privacy, no other action is required",
        },
        {
          "type": "new",
          "detail": "There is now a Startup Wizard to improve the setup experience for new users",
        },
        {
          "type": "new",
          "detail": "Localization has been added, help translate under Settings > Help Translate",
        },
        {
          "type": "improvement",
          "detail": "Servers added before OneSignal registration is complete will automatically send Tautulli the OneSignal Device ID once registered",
        },
        {
          "type": "improvement",
          "detail": "Adding Tautulli servers has been visually adjusted and exposes the Secondary Connection Address setting",
        },
        {
          "type": "improvement",
          "detail": "Added a terminate stream button to the activity details bottom sheet",
        },
        {
          "type": "improvement",
          "detail": "Store the OneSignal consent state locally to prevent future issues with OneSignal SDK changes",
        },
        {
          "type": "improvement",
          "detail": "Flutter upgraded to 2.2.1",
        },
        {
          "type": "improvement",
          "detail": "Various UI styling adjustments",
        },
        {
          "type": "fix",
          "detail": "TLS v1.3 is now supported",
        },
      ],
    },
    {
      "version": "v2.9.0",
      "date": "May 3, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Graphs are here! Check them out on the new graphs page",
        },
        {
          "type": "improvement",
          "detail": "Updated donation backend and added recurring donation options, special thanks to those who have donated",
        },
        {
          "type": "fix",
          "detail": "Fixed 'View on Plex' action for photos, clips, and tracks",
        },
        {
          "type": "fix",
          "detail": "Fixed 'View on Plex' action not opening Plex app on Android 11+",
        },
      ],
    },
    {
      "version": "v2.8.0",
      "date": "April 4, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Library details page now has tabs for Stats and New (recently added), the page style has been updated to match user and media details",
        },
        {
          "type": "improvement",
          "detail": "Added transcode decision filter to history page",
        },
        {
          "type": "improvement",
          "detail": "The summary on media info pages is now expandable",
        },
        {
          "type": "improvement",
          "detail": "Users page sort is now saved",
        },
        {
          "type": "improvement",
          "detail": "Updated the Microsoft Edge platform icon",
        },
        {
          "type": "improvement",
          "detail": "Added Alexa platform icon and color",
        },
        {
          "type": "improvement",
          "detail": "Adjust how images are fetched for track items",
        },
        {
          "type": "improvement",
          "detail": "Various small performance improvements",
        },
      ],
    },
    {
      "version": "v2.7.0",
      "date": "March 29, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Servers can now be reordered when using Multiserver, long press a server on the settings page to move it",
        },
        {
          "type": "improvement",
          "detail": "The OneSignal banner in settings can now be dismissed",
        },
        {
          "type": "improvement",
          "detail": "Updated the settings page floating action button",
        },
        {
          "type": "improvement",
          "detail": "Settings behavior has been revamped behind the scenes",
        },
        {
          "type": "fix",
          "detail": "Fix activity errors from missing bandwidth information",
        },
      ],
    },
    {
      "version": "v2.6.2",
      "date": "March 26, 2021",
      "changes": [
        {
          "type": "fix",
          "detail": "Fix activity not passing last seen to user details page",
        },
      ],
    },
    {
      "version": "v2.6.1",
      "date": "March 26, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail": "Adjust how user details page decides to fetch missing user information",
        },
        {
          "type": "improvement",
          "detail": "Adjust user cache behavior to prevent extra API calls",
        },
        {
          "type": "improvement",
          "detail": "Make sure user cache items are unique per server",
        },
      ],
    },
    {
      "version": "v2.6.0",
      "date": "March 25, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "History details are now available, tap on any history item to view the full history details",
        },
        {
          "type": "new",
          "detail": "User details have been added, view stats and history for individual users",
        },
        {
          "type": "new",
          "detail": "Jump to user details from activity and history details",
        },
        {
          "type": "new",
          "detail": "Bandwidth information has been added to the activity page",
        },
        {
          "type": "new",
          "detail": "Add support for an upcoming Tautulli setting to set the type of notification displayed by Tautulli Remote",
        },
        {
          "type": "improvement",
          "detail": "Adjust method for detecting public IP addresses",
        },
        {
          "type": "fix",
          "detail": "Fix image flickering with activity and history detail bottom sheets",
        },
      ],
    },
    {
      "version": "v2.5.0",
      "date": "March 20, 2021",
      "changes": [
        {
          "type": "important",
          "detail":
              "This update requires that you consent to the OneSignal Data Privacy again to receive notifications, you do not need to re-register with Tautulli",
        },
        {
          "type": "new",
          "detail": "Upgraded to Flutter 2, please report any issues through the Settings > Help & Support page",
        },
        {
          "type": "improvement",
          "detail": "Library cards will now show a custom icon if one is set in Tautulli",
        },
        {
          "type": "improvement",
          "detail": "Connection address active/passive icons now update in UI immediately on failover",
        },
        {
          "type": "improvement",
          "detail": "Adjust concurrent icon color from white to Tautulli Not White",
        },
        {
          "type": "improvement",
          "detail": "Change announcements icon from a bell to a bullhorn",
        },
        {
          "type": "improvement",
          "detail": "If Tautulli Remote is not registered with OneSignal set OneSignal ID to onesignal-disabled when registering with Tautulli",
        },
        {
          "type": "improvement",
          "detail": "Make classes extending Equatable immutable",
        },
        {
          "type": "fix",
          "detail": "Catch if data is missing on users page to prevent failure to load",
        },
        {
          "type": "fix",
          "detail": "Fix potential for incorrect server to be called when using multiserver and going to a media item page from activity",
        },
        {
          "type": "fix",
          "detail": "Fix images sometimes being incorrect for TV and music statistics",
        },
        {
          "type": "fix",
          "detail": "Fix single statistic page being incorrect if stat type was set to duration",
        },
        {
          "type": "fix",
          "detail": "Fix connection failover not triggering custom cert trust prompt",
        },
      ]
    },
    {
      "version": "v2.4.5",
      "date": "March 15, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Add support for the upcoming Most Active Libraries statistic",
        },
        {
          "type": "improvement",
          "detail": "Activity ETA now uses the Time Format from Tautulli",
        },
      ]
    },
    {
      "version": "v2.4.4",
      "date": "March 12, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Enable Double Tap To Exit to require pressing back twice to exit the app",
        },
        {
          "type": "fix",
          "detail": "Fix an issue where a success would be emitted after a failure for a failed QR scan",
        },
        {
          "type": "fix",
          "detail": "Fix images not loading for manually trusted certs (ex. self-signed certs)",
        },
      ]
    },
    {
      "version": "v2.4.3",
      "date": "March 10, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail": "QR code scanner now fails when scanning bad QR codes and barcodes",
        },
        {
          "type": "improvement",
          "detail": "Long titles on announcement cards now wrap correctly",
        },
        {
          "type": "fix",
          "detail": "Fix incorrect values displayed for 15 and 30 sec server timeouts on Settings page",
        },
      ]
    },
    {
      "version": "v2.4.2",
      "date": "March 9, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail":
              "Fall back to empty strings for various activity properties, this should help prevent bad data from preventing the loading of activity details",
        },
      ]
    },
    {
      "version": "v2.4.1",
      "date": "March 9, 2021",
      "changes": [
        {
          "type": "fix",
          "detail": "Fix unknown activity bandwidth breaking activity details bottom sheet",
        },
      ]
    },
    {
      "version": "v2.4.0",
      "date": "March 8, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Added ability to trust self-signed certs and certs that fail to authenticate",
        },
        {
          "type": "improvement",
          "detail": "Added 15 sec and 30 sec server timeout options",
        },
      ]
    },
    {
      "version": "v2.3.2",
      "date": "March 8, 2021",
      "changes": [
        {
          "type": "fix",
          "detail": "Fix failure mapping for ServerVersionException",
        },
        {
          "type": "fix",
          "detail": "Fix incorrect Support Wiki link",
        },
      ]
    },
    {
      "version": "v2.3.1",
      "date": "March 8, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail": "Add Bugs/Feature Requests section to Help & Support",
        },
        {
          "type": "fix",
          "detail": "Fix failure mapping for ServerException",
        },
      ]
    },
    {
      "version": "v2.3.0",
      "date": "March 1, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Added announcements page, allows for announcements to be shared without an app update",
        },
        {
          "type": "improvement",
          "detail": "Use square poster for playlist items",
        },
        {
          "type": "improvement",
          "detail": "In-app links are now set to the new wiki (pending wiki update)",
        },
        {
          "type": "fix",
          "detail": "Fix failure mapping for SocketException",
        },
      ]
    },
    {
      "version": "v2.2.4",
      "date": "February 23, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail": "When synced item has multiple rating keys use the first one to load poster",
        },
        {
          "type": "fix",
          "detail": "Fix issues with playlists identifying incorrectly by switching to use syncMediaType before mediaType",
        },
      ]
    },
    {
      "version": "v2.2.3",
      "date": "February 23, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Allow synced items to be deleted, swipe left on a synced item to access the delete button",
        },
        {
          "type": "new",
          "detail": "Added pull to refresh on library media info tab, this triggers a full refresh of the library in Tautulli",
        },
        {
          "type": "new",
          "detail": "Add link to open Tautulli server in a web browser under the Server Settings page",
        },
        {
          "type": "improvement",
          "detail": "Adjust albums to be 3 across on media item page albums tab",
        },
        {
          "type": "improvement",
          "detail": "Add a user filter to synced items page",
        },
        {
          "type": "improvement",
          "detail": "Add additional customization to PosterCard widget",
        },
        {
          "type": "improvement",
          "detail": "Add fallback to media item page to use metadata poster url if one isn't provided",
        },
        {
          "type": "improvement",
          "detail": "Adjust icons for links that navigate outside of the Tautulli Remote",
        },
        {
          "type": "improvement",
          "detail": "Add support to override the connection timeout to Tautulli for specific use cases",
        },
        {
          "type": "improvement",
          "detail": "Cleaned up various code elements, no changes to functionality",
        },
        {
          "type": "fix",
          "detail": "Correctly display collections and playlists on synced items page",
        },
        {
          "type": "fix",
          "detail": "Correctly display collections and playlists on media item page",
        },
      ]
    },
    {
      "version": "v2.2.2",
      "date": "February 20, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail": "Show generic 'Unknown error' in Activity StatusCard when there is no failure mapping",
        },
        {
          "type": "improvement",
          "detail": "Add logging when an exception has no failure mapping",
        },
        {
          "type": "improvement",
          "detail": "Add Failure mapping for HandshakeException",
        },
        {
          "type": "fix",
          "detail": "Make sure Activity StatusCards take up the full width",
        },
      ]
    },
    {
      "version": "v2.2.1",
      "date": "February 18, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Library detail pages now use tabs and show history",
        },
        {
          "type": "improvement",
          "detail": "Multiserver headers will now 'stick' to the top when scrolling on the Activity Page",
        },
        {
          "type": "improvement",
          "detail": "Adjusted layout of changelog change type tags",
        },
        {
          "type": "improvement",
          "detail": "Libraries page sort icons now use alpha and numeric icons",
        },
        {
          "type": "improvement",
          "detail": "Do not set refresh to true when calling get_library_media_info (should speed up the time to load library items)",
        },
        {
          "type": "improvement",
          "detail": "Move off deprecated FlatButton and RaisedButton to TextButton and ElevatedButton respectively",
        },
        {
          "type": "improvement",
          "detail": "Rename history_users to users_list and move from the history to users function",
        },
        {
          "type": "improvement",
          "detail": "Remove dependency on a custom modalBottomSheet",
        },
        {
          "type": "fix",
          "detail": "Adjust icon card behavior so the Concurrent Streams icon is not all one color",
        },
      ]
    },
    {
      "version": "v2.2.0",
      "date": "February 17, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Added an in-app changelog that displays on first start of a new app version",
        },
        {
          "type": "new",
          "detail": "Setting to mask sensitive info in the UI (useful for sharing screenshots)",
        },
        {
          "type": "improvement",
          "detail": "Move the logs page link out of the appbar on Help & Support",
        },
        {
          "type": "fix",
          "detail": "Change Kbps to kbps on media info page details tab",
        },
        {
          "type": "fix",
          "detail": "Prevent failure when sorting albums that have no year",
        },
      ]
    },
    {
      "version": "v2.1.5",
      "date": "February 15, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Libraries are now displayed as a grid of posters/art (photo libraries distinguish between photo, photo album, and video clip)",
        },
        {
          "type": "new",
          "detail": "Photos now have a media info page",
        },
        {
          "type": "new",
          "detail": "Additional file details added to the media info details tab",
        },
        {
          "type": "improvement",
          "detail": "Libraries load all their items at once",
        },
        {
          "type": "improvement",
          "detail": "Logging has been overhauled across the app",
        },
      ]
    },
    {
      "version": "v2.1.4",
      "date": "February 11, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Jump directly to an item in the Plex app from the media info page",
        },
      ]
    },
    {
      "version": "v2.1.3",
      "date": "February 11, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "Jump to a parent media info page for shows and music",
        },
        {
          "type": "improvement",
          "detail": "Adjust sorting of information on media info page details tab",
        },
        {
          "type": "improvement",
          "detail": "Adjust settings alert banner behavior",
        },
        {
          "type": "improvement",
          "detail": "Refactor API code",
        },
      ]
    },
    {
      "version": "v2.1.2",
      "date": "February 9, 2021",
      "changes": [
        {
          "type": "important",
          "detail": "Minimum Tautulli version bumped to 2.6.6",
        },
        {
          "type": "fix",
          "detail": "Fix behavior for loading synced items media details",
        },
        {
          "type": "fix",
          "detail": "Fix issue where resuming app with activity details open could result in black screen",
        },
      ]
    },
    {
      "version": "v2.1.1",
      "date": "February 5, 2021",
      "changes": [
        {
          "type": "new",
          "detail": "View media details for synced items",
        },
        {
          "type": "fix",
          "detail": "Media item history rows no longer cut off early on some screen sizes",
        },
        {
          "type": "fix",
          "detail": "Hide the activity details 'View Media' button for photos",
        },
        {
          "type": "fix",
          "detail": "Properly handle viewing photo albums",
        },
        {
          "type": "fix",
          "detail": "Do not allow Live TV to be selected in Libraries",
        },
      ]
    },
    {
      "version": "v2.1.0",
      "date": "February 5, 2021",
      "changes": [
        {
          "type": "new",
          "detail":
              "You can now view media details. Navigate through your libraries directly or tap on select items to view media details, seasons/episodes/albums/tracks, as well as unique history for each item.",
        },
      ]
    },
    {
      "version": "v2.0.1",
      "date": "October 23, 2020",
      "changes": [
        {
          "type": "new",
          "detail": "Use Tautulli server time/date format settings",
        },
      ]
    },
    {
      "version": "v2.0.0",
      "date": "October 18, 2020",
      "changes": [
        {
          "type": "",
          "detail": "Initial release",
        },
      ]
    },
  ]
};
