Map changelog = {
  "data": [
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
