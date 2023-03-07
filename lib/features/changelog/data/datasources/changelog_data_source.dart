Map changelog = {
  "data": [
    {
      "version": "v3.0.0-alpha.25",
      "date": "Mar 7, 2023",
      "changes": [
        {
          "type": "improvement",
          "detail": "Updated the Inner Drawer to use the new Flutter navigation drawer style",
        },
        {
          "type": "improvement",
          "detail": "Removed the divider on the tabbed detail pages",
        },
        {
          "type": "improvement",
          "detail": "Buttons will no longer all be upper case",
          "additional":
              "This style change decision had the unfortunate consequence of removing many of the existing translations for button text",
        },
        {
          "type": "fix",
          "detail": "Notifications now display correctly and open the app when tapped",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.24",
      "date": "Mar 5, 2023",
      "changes": [
        {
          "type": "improvement",
          "detail": "Removed page with testing directions",
        },
        {
          "type": "fix",
          "detail": "Quick actions will now work if the app is on the Announcements or Donate page",
        },
        {
          "type": "fix",
          "detail": "History and Recently Added quick action icons should now display correctly",
          "additional": "You may need to reboot your device if the icons are still not displaying",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.23",
      "date": "Mar 4, 2023",
      "changes": [
        {
          "type": "improvement",
          "detail": "Added additional quick actions for activity, history, and recently added",
        },
        {
          "type": "improvement",
          "detail": "Display correct messaging on feature pages when no servers are configured",
        },
        {
          "type": "improvement",
          "detail": "Synced all pending translations from Tautulli Remote v2",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.22",
      "date": "Mar 3, 2023",
      "changes": [
        {
          "type": "improvement",
          "detail": "Added ETA to activity bottom sheet",
        },
        {
          "type": "fix",
          "detail":
              "Media and user pages will load correctly when selecting an item on multiactivity that is not the active server",
        },
        {
          "type": "fix",
          "detail": "Media page appbar title will now correctly displays the currently viewed item",
        },
        {
          "type": "fix",
          "detail": "Activity page will now load when setup wizard completes",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.21",
      "date": "Feb 16, 2023",
      "changes": [
        {
          "type": "new",
          "detail": "Multiactivity support has been added, it can be enabled under Advanced in Settings",
          "additional":
              "As a reminder, this allows you to view the activity for all servers in Tautulli Remote on a single page",
        },
        {
          "type": "new",
          "detail": "Activity refresh rate will now work",
        },
        {
          "type": "improvement",
          "detail": "Up to three activity cards will be displayed horizontally if the screen width is large enough",
        },
        {
          "type": "improvement",
          "detail": "More library and media posters will display horizontally on wider screens",
        },
        {
          "type": "improvement",
          "detail": "Various tiny styling adjustments",
        },
        {
          "type": "improvement",
          "detail": "New translations for Chinese (Simplified), French, and Polish",
          "additional": "Thanks @amorphobia, @Owautrip, @slundi, drzordz, and RafalHo",
        },
        {
          "type": "fix",
          "detail": "Posters for clip items will now fill the full poster area",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.20",
      "date": "Dec 3, 2022",
      "changes": [
        {
          "type": "important",
          "detail":
              "This is an abnormally limited alpha release as I do not expect to have time this year to develop it further, I will continue development in the new year",
        },
        {
          "type": "new",
          "detail": "Activity page will show cards for current activity items",
          "additional": "None of the available Activity settings will have any effect at this time",
        },
        {
          "type": "improvement",
          "detail": "New translations for Portuguese (Portugal) and Swedish",
          "additional": "Thanks @SantosSi, jacobnil, and @velcropaste",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.19",
      "date": "Nov 7, 2022",
      "changes": [
        {
          "type": "important",
          "detail": "Tautulli v2.10.5 or higher is needed to avoid some image loading issues with media details",
        },
        {
          "type": "new",
          "detail":
              "Media details can now be viewed and loaded from various source items (library, history, recently added, statistics)",
        },
        {
          "type": "new",
          "detail": "Added setting to disable library media full refresh",
        },
        {
          "type": "improvement",
          "detail": "Adjust placeholder and error images",
        },
        {
          "type": "improvement",
          "detail": "Popup menu border radius now matches the rest of the app",
        },
        {
          "type": "improvement",
          "detail": "Tab bar spacing should allow for more narrow screens without cutting off the tab labels",
        },
        {
          "type": "improvement",
          "detail": "Moved data dump page under More section in settings",
        },
        {
          "type": "improvement",
          "detail": "Added Albanian and Polish languages",
        },
        {
          "type": "improvement",
          "detail": "New translations for Albanian, Norwegian Bokmål, Polish, and Slovenian",
          "additional": "Thanks @TheFili, drzordz, and @mitchoklemen",
        },
        {
          "type": "fix",
          "detail": "Blurred background will no longer flicker when scrolling off screen",
        },
        {
          "type": "fix",
          "detail": "Detail page views will no longer have a thin line between the expanded section and tab bar",
        },
        {
          "type": "fix",
          "detail": "Announcements will now filter based on their intended operating system",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.18",
      "date": "September 27, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added individual statistics pages",
        },
        {
          "type": "improvement",
          "detail": "Added Slovene language",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.17",
      "date": "August 03, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added the Statistics page",
        },
        {
          "type": "improvement",
          "detail": "Added additional padding between poster and details on Poster Cards",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.16",
      "date": "July 27, 2022",
      "changes": [
        {
          "type": "improvement",
          "detail": "Added sorting to Libraries page",
        },
        {
          "type": "fix",
          "detail": "History tab for a library was fetching incorrect cached data",
        },
        {
          "type": "fix",
          "detail": "Libraries with no last streamed date would show 'unknown' instead of 'never'",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.15",
      "date": "July 26, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added the Libraries & Library Details pages",
        },
        {
          "type": "new",
          "detail": "Added Settings quick action",
          "additional": "Long press the app icon to view and select a quick action",
        },
        {
          "type": "improvement",
          "detail": "Card heights will now scale for devices using larger font sizes",
        },
        {
          "type": "improvement",
          "detail": "Update current default page to History",
        },
        {
          "type": "improvement",
          "detail": "Darken poster card background",
        },
        {
          "type": "improvement",
          "detail": "Add device details to data dump",
        },
        {
          "type": "improvement",
          "detail": "New translations for Catalan",
          "additional": "Thanks @dtalens",
        },
        {
          "type": "fix",
          "detail": "Calculation for largest time on graphs was incorrect",
        },
        {
          "type": "fix",
          "detail": "User card tap splash was only affecting background",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.14",
      "date": "June 25, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added the Graphs page",
        },
        {
          "type": "improvement",
          "detail": "New translations for Norwegian Bokmål",
          "additional": "Thanks @aunefyren",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.13",
      "date": "June 12, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added the Recently Added page",
        },
        {
          "type": "improvement",
          "detail": "Make sure all URLs launch in external application",
        },
        {
          "type": "fix",
          "detail": "Notification decryption was not working in the alpha",
        },
        {
          "type": "fix",
          "detail": "Activity Refresh Rate would cause settings not to load",
        },
        {
          "type": "fix",
          "detail": "History filter items would not reset when active server was changed",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.12",
      "date": "June 08, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added the ability to search history",
        },
        {
          "type": "new",
          "detail": "Added setting to clear Tautulli server image cache",
          "additional": "This can be found on each server's settings page",
        },
        {
          "type": "improvement",
          "detail": "Multiple options can now be selected for each history filter type",
        },
        {
          "type": "improvement",
          "detail": "Reduced the size of the History appbar action icons",
        },
        {
          "type": "fix",
          "detail": "Make sure URLs launch to external browser",
        },
        {
          "type": "fix",
          "detail": "Fix dialog content clipping",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.11",
      "date": "May 31, 2022",
      "changes": [
        {
          "type": "improvement",
          "detail": "Small adjustment to history details styling",
        },
        {
          "type": "fix",
          "detail": "Fix images not loading for manually trusted certs",
        },
        {
          "type": "fix",
          "detail": "Fix history filter icon from indicating a selection is active after server is changed",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.10",
      "date": "May 30, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added History page & details",
        },
        {
          "type": "improvement",
          "detail": "The history tab for User Details is now available",
        },
        {
          "type": "improvement",
          "detail": "Use 'time' instead of 'duration' for total play time",
        },
        {
          "type": "improvement",
          "detail": "Adjusted user details styling",
        },
        {
          "type": "improvement",
          "detail": "New translations for Norwegian Bokmål and French",
          "additional": "Thanks @aunefyren and @NathanBnm",
        },
        {
          "type": "fix",
          "detail": "Fix wizard closing page not being able to scroll",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.9",
      "date": "May 17, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added Users Details page with user stats",
          "additional": "User history will be added in a future update",
        },
        {
          "type": "improvement",
          "detail": "Implement Material Design 3",
        },
        {
          "type": "improvement",
          "detail": "Upgrade to Flutter 3",
        },
        {
          "type": "improvement",
          "detail": "Upgrade dependencies",
        },
        {
          "type": "improvement",
          "detail": "New translations for French",
          "additional": "Thanks @NathanBnm",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.8",
      "date": "May 6, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added Users page",
          "additional": "This new Users page features various UI/UX improvements",
        },
        {
          "type": "improvement",
          "detail": "Use the stretch animation for overscroll on Android",
        },
        {
          "type": "improvement",
          "detail": "Add visual indicator for current page in inner drawer",
        },
        {
          "type": "improvement",
          "detail": "Fade out indicators on announcement cards when marked as read",
        },
        {
          "type": "improvement",
          "detail": "New translations for French, Czech, Norwegian Bokmål, Chinese (Simplified), and Swedish",
          "additional": "Thanks @NathanBnm, David Nedvěd, @aunefyren, @FaintGhost & @blackisle, and Johan Qvist",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.7",
      "date": "March 25, 2022",
      "changes": [
        {
          "type": "fix",
          "detail": "Manually trusting a certificate would fail",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.6",
      "date": "March 23, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added Setup Wizard",
          "additional": "Please clear app data and launch the app to test",
        },
        {
          "type": "improvement",
          "detail": "Tuned Inner Drawer to look better across a variety of screen sizes",
        },
        {
          "type": "improvement",
          "detail": "Fixed issue with how old translations were moved over",
        },
        {
          "type": "improvement",
          "detail": "New translations for French and German",
          "additional": "Thanks @NathanBnm and @strausmann",
        },
        {
          "type": "fix",
          "detail":
              "Server Selector would not correctly display the active server after adding servers for the first time",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.5",
      "date": "March 11, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added Announcements page",
        },
        {
          "type": "improvement",
          "detail": "Show changelog on start after app update",
        },
        {
          "type": "improvement",
          "detail": "Added Donate page to Inner Drawer",
          "additional": "Donate page still won't work properly during Alpha",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.4",
      "date": "March 9, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Added an Inner Drawer that supports swipe gestures to open/close",
        },
        {
          "type": "new",
          "detail": "Added a Server Selector to the Inner Drawer when more than one server are registered",
        },
        {
          "type": "new",
          "detail": "Removed the locked portrait mode orientation",
        }
      ],
    },
    {
      "version": "v3.0.0-alpha.3",
      "date": "March 8, 2022",
      "changes": [
        {
          "type": "fix",
          "detail": "Selecting Chinese (Simplified) or Norwegian Bokmål would lock up app",
        }
      ],
    },
    {
      "version": "v3.0.0-alpha.2",
      "date": "March 8, 2022",
      "changes": [
        {
          "type": "new",
          "detail": "Translations are now implemented, check the Help Translate page to assist with translating",
        },
        {
          "type": "improvement",
          "detail":
              "Consenting to OneSignal data privacy will check for notification permission on Android as well as iOS",
        },
        {
          "type": "improvement",
          "detail":
              "When re-registering an existing server a message is now displayed to show that the entry was updated",
        },
      ],
    },
    {
      "version": "v3.0.0-alpha.1",
      "date": "Feb 13, 2022",
      "changes": [
        {
          "type": "important",
          "detail": "Version 3 is a work in progress being re-written from the ground up",
        },
        {
          "type": "important",
          "detail": "Check the 'How To Test' page on how to submit feedback or bugs",
        },
        {
          "type": "important",
          "detail": "Donations cannot be tested in the alpha, they will always fail to load",
        },
        {
          "type": "new",
          "detail": "Core settings and related functions/pages have been added",
        },
        {
          "type": "new",
          "detail":
              "A new data dump page for testing had been added to view current app, server, and OneSignal information",
        },
      ],
    },
  ]
};
