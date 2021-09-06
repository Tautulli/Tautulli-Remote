// @dart=2.9

Map changelog = {
  "data": [
    {
      "version": "v2.12.3",
      "date": "September 5, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail":
              "The iOS app no longer requires the app tracking permission.",
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
          "detail":
              "New translations for Czech, Portuguese (Brazil), and Russian",
          "additional": "Thanks @karelkryda, @neitzke, and @barbuddah",
        },
        {
          "type": "improvement",
          "detail": "Add support for null safe code",
        },
        {
          "type": "fix",
          "detail":
              "Android notifications would fail when an Image Type was set in Tautulli",
        },
      ],
    },
    {
      "version": "v2.12.1",
      "date": "August 31, 2021",
      "changes": [
        {
          "type": "new",
          "detail":
              "The app drawer has been changed into a new inner drawer, swipe right to easily reveal the drawer",
        },
        {
          "type": "new",
          "detail": "Added Catalan and Danish languages",
        },
        {
          "type": "improvement",
          "detail":
              "Network images are now cached, this cache can be cleared under Advanced Settings",
        },
        {
          "type": "improvement",
          "detail":
              "New translations for Catalan, Danish, Dutch, French, German, Hungarian, Italian, Portuguese (Brazil), Portuguese (Portugal), and Swedish",
          "additional":
              "Thanks @dtalens, @Tntdruid, @raoul-m, @bninot, @NathanBnm, @TautulliPiece, @MaddionMax, @janus158, @taduo, @Bllstc, and @bittin",
        },
        {
          "type": "improvement",
          "detail": "Added a quit button to the setup Wizard",
        },
        {
          "type": "fix",
          "detail":
              "Enabling iOS notifications now requires the tracking permission",
          "additional":
              "This change was requested by Apple, there has been no change to the data collected",
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
          "detail":
              "Fixed history details buttons being clipped on some devices",
        },
        {
          "type": "fix",
          "detail":
              "Registration update could send a blank OneSignal Device ID after app version update",
        },
      ],
    },
    {
      "version": "v2.11.2",
      "date": "July 30, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail":
              "New translations for Dutch, Portuguese (Brazil), Spanish, and German",
          "additional":
              "Thanks @Zucht, @RubenKremer, @neitzke, @CMBoii, @granjerox, and @Jerome2103",
        },
        {
          "type": "improvement",
          "detail": "Added splash screen for iOS",
        },
        {
          "type": "improvement",
          "detail":
              "Add advanced setting to change app language rather than rely only on the system setting",
        },
        {
          "type": "improvement",
          "detail": "Add option to change app language from the setup wizard",
        },
        {
          "type": "improvement",
          "detail":
              "Moved Double Tap to Exit (Android) and Mask Sensitive Info under new Advanced Settings menu",
        },
        {
          "type": "fix",
          "detail": "Fix Swedish translations not working",
        },
        {
          "type": "fix",
          "detail":
              "Live TV history would display null for missing episode/season number",
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
          "detail":
              "The Android app is moving to stable, beta testing will continue as part of the Tautulli Remote development cycle",
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
          "detail":
              "Resolve issue where app could display black screen on resume",
        },
        {
          "type": "fix",
          "detail":
              "'Buy Me A Slice' donation level has been reduced on Android to 2.99 USD to match Apple restrictions",
        },
        {
          "type": "fix",
          "detail":
              "Adjust how the changelog is triggered on starting a new app version (to support iOS)",
        },
      ],
    },
    {
      "version": "v2.10.0",
      "date": "June 16, 2021",
      "changes": [
        {
          "type": "important",
          "detail":
              "Due to a OneSignal SDK change please re-accept the OneSignal Data Privacy, no other action is required",
        },
        {
          "type": "new",
          "detail":
              "There is now a Startup Wizard to improve the setup experience for new users",
        },
        {
          "type": "new",
          "detail":
              "Localization has been added, help translate under Settings > Help Translate",
        },
        {
          "type": "improvement",
          "detail":
              "Servers added before OneSignal registration is complete will automatically send Tautulli the OneSignal Device ID once registered",
        },
        {
          "type": "improvement",
          "detail":
              "Adding Tautulli servers has been visually adjusted and exposes the Secondary Connection Address setting",
        },
        {
          "type": "improvement",
          "detail":
              "Added a terminate stream button to the activity details bottom sheet",
        },
        {
          "type": "improvement",
          "detail":
              "Store the OneSignal consent state locally to prevent future issues with OneSignal SDK changes",
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
          "detail":
              "Updated donation backend and added recurring donation options, special thanks to those who have donated",
        },
        {
          "type": "fix",
          "detail": "Fixed 'View on Plex' action for photos, clips, and tracks",
        },
        {
          "type": "fix",
          "detail":
              "Fixed 'View on Plex' action not opening Plex app on Android 11+",
        },
      ],
    },
    {
      "version": "v2.8.0",
      "date": "April 4, 2021",
      "changes": [
        {
          "type": "new",
          "detail":
              "Library details page now has tabs for Stats and New (recently added), the page style has been updated to match user and media details",
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
          "detail":
              "Servers can now be reordered when using Multiserver, long press a server on the settings page to move it",
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
          "detail":
              "Adjust how user details page decides to fetch missing user information",
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
          "detail":
              "History details are now available, tap on any history item to view the full history details",
        },
        {
          "type": "new",
          "detail":
              "User details have been added, view stats and history for individual users",
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
          "detail":
              "Add support for an upcoming Tautulli setting to set the type of notification displayed by Tautulli Remote",
        },
        {
          "type": "improvement",
          "detail": "Adjust method for detecting public IP addresses",
        },
        {
          "type": "fix",
          "detail":
              "Fix image flickering with activity and history detail bottom sheets",
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
          "detail":
              "Upgraded to Flutter 2, please report any issues through the Settings > Help & Support page",
        },
        {
          "type": "improvement",
          "detail":
              "Library cards will now show a custom icon if one is set in Tautulli",
        },
        {
          "type": "improvement",
          "detail":
              "Connection address active/passive icons now update in UI immediately on failover",
        },
        {
          "type": "improvement",
          "detail":
              "Adjust concurrent icon color from white to Tautulli Not White",
        },
        {
          "type": "improvement",
          "detail": "Change announcements icon from a bell to a bullhorn",
        },
        {
          "type": "improvement",
          "detail":
              "If Tautulli Remote is not registered with OneSignal set OneSignal ID to onesignal-disabled when registering with Tautulli",
        },
        {
          "type": "improvement",
          "detail": "Make classes extending Equatable immutable",
        },
        {
          "type": "fix",
          "detail":
              "Catch if data is missing on users page to prevent failure to load",
        },
        {
          "type": "fix",
          "detail":
              "Fix potential for incorrect server to be called when using multiserver and going to a media item page from activity",
        },
        {
          "type": "fix",
          "detail":
              "Fix images sometimes being incorrect for TV and music statistics",
        },
        {
          "type": "fix",
          "detail":
              "Fix single statistic page being incorrect if stat type was set to duration",
        },
        {
          "type": "fix",
          "detail":
              "Fix connection failover not triggering custom cert trust prompt",
        },
      ]
    },
    {
      "version": "v2.4.5",
      "date": "March 15, 2021",
      "changes": [
        {
          "type": "new",
          "detail":
              "Add support for the upcoming Most Active Libraries statistic",
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
          "detail":
              "Enable Double Tap To Exit to require pressing back twice to exit the app",
        },
        {
          "type": "fix",
          "detail":
              "Fix an issue where a success would be emitted after a failure for a failed QR scan",
        },
        {
          "type": "fix",
          "detail":
              "Fix images not loading for manually trusted certs (ex. self-signed certs)",
        },
      ]
    },
    {
      "version": "v2.4.3",
      "date": "March 10, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail":
              "QR code scanner now fails when scanning bad QR codes and barcodes",
        },
        {
          "type": "improvement",
          "detail": "Long titles on announcement cards now wrap correctly",
        },
        {
          "type": "fix",
          "detail":
              "Fix incorrect values displayed for 15 and 30 sec server timeouts on Settings page",
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
          "detail":
              "Fix unknown activity bandwidth breaking activity details bottom sheet",
        },
      ]
    },
    {
      "version": "v2.4.0",
      "date": "March 8, 2021",
      "changes": [
        {
          "type": "new",
          "detail":
              "Added ability to trust self-signed certs and certs that fail to authenticate",
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
          "detail":
              "Added announcements page, allows for announcements to be shared without an app update",
        },
        {
          "type": "improvement",
          "detail": "Use square poster for playlist items",
        },
        {
          "type": "improvement",
          "detail":
              "In-app links are now set to the new wiki (pending wiki update)",
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
          "detail":
              "When synced item has multiple rating keys use the first one to load poster",
        },
        {
          "type": "fix",
          "detail":
              "Fix issues with playlists identifying incorrectly by switching to use syncMediaType before mediaType",
        },
      ]
    },
    {
      "version": "v2.2.3",
      "date": "February 23, 2021",
      "changes": [
        {
          "type": "new",
          "detail":
              "Allow synced items to be deleted, swipe left on a synced item to access the delete button",
        },
        {
          "type": "new",
          "detail":
              "Added pull to refresh on library media info tab, this triggers a full refresh of the library in Tautulli",
        },
        {
          "type": "new",
          "detail":
              "Add link to open Tautulli server in a web browser under the Server Settings page",
        },
        {
          "type": "improvement",
          "detail":
              "Adjust albums to be 3 across on media item page albums tab",
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
          "detail":
              "Add fallback to media item page to use metadata poster url if one isn't provided",
        },
        {
          "type": "improvement",
          "detail":
              "Adjust icons for links that navigate outside of the Tautulli Remote",
        },
        {
          "type": "improvement",
          "detail":
              "Add support to override the connection timeout to Tautulli for specific use cases",
        },
        {
          "type": "improvement",
          "detail":
              "Cleaned up various code elements, no changes to functionality",
        },
        {
          "type": "fix",
          "detail":
              "Correctly display collections and playlists on synced items page",
        },
        {
          "type": "fix",
          "detail":
              "Correctly display collections and playlists on media item page",
        },
      ]
    },
    {
      "version": "v2.2.2",
      "date": "February 20, 2021",
      "changes": [
        {
          "type": "improvement",
          "detail":
              "Show generic 'Unknown error' in Activity StatusCard when there is no failure mapping",
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
          "detail":
              "Multiserver headers will now 'stick' to the top when scrolling on the Activity Page",
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
          "detail":
              "Do not set refresh to true when calling get_library_media_info (should speed up the time to load library items)",
        },
        {
          "type": "improvement",
          "detail":
              "Move off deprecated FlatButton and RaisedButton to TextButton and ElevatedButton respectively",
        },
        {
          "type": "improvement",
          "detail":
              "Rename history_users to users_list and move from the history to users function",
        },
        {
          "type": "improvement",
          "detail": "Remove dependency on a custom modalBottomSheet",
        },
        {
          "type": "fix",
          "detail":
              "Adjust icon card behavior so the Concurrent Streams icon is not all one color",
        },
      ]
    },
    {
      "version": "v2.2.0",
      "date": "February 17, 2021",
      "changes": [
        {
          "type": "new",
          "detail":
              "Added an in-app changelog that displays on first start of a new app version",
        },
        {
          "type": "new",
          "detail":
              "Setting to mask sensitive info in the UI (useful for sharing screenshots)",
        },
        {
          "type": "improvement",
          "detail":
              "Move the logs page link out of the appbar on Help & Support",
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
          "detail":
              "Libraries are now displayed as a grid of posters/art (photo libraries distinguish between photo, photo album, and video clip)",
        },
        {
          "type": "new",
          "detail": "Photos now have a media info page",
        },
        {
          "type": "new",
          "detail":
              "Additional file details added to the media info details tab",
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
          "detail":
              "Jump directly to an item in the Plex app from the media info page",
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
          "detail":
              "Adjust sorting of information on media info page details tab",
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
          "detail":
              "Fix issue where resuming app with activity details open could result in black screen",
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
          "detail":
              "Media item history rows no longer cut off early on some screen sizes",
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
    }
  ]
};
