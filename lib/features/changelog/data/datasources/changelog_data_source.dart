Map changelog = {
  "data": [
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
          "additional":
              "This new Users page features various UI/UX improvements",
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
          "detail":
              "Fade out indicators on announcement cards when marked as read",
        },
        {
          "type": "improvement",
          "detail":
              "New translations for French, Czech, Norwegian Bokmål, Chinese (Simplified), and Swedish",
          "additional":
              "Thanks @NathanBnm, David Nedvěd, @aunefyren, @FaintGhost & @blackisle, and Johan Qvist",
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
          "detail":
              "Tuned Inner Drawer to look better across a variety of screen sizes",
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
          "detail":
              "Added an Inner Drawer that supports swipe gestures to open/close",
        },
        {
          "type": "new",
          "detail":
              "Added a Server Selector to the Inner Drawer when more than one server are registered",
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
          "detail":
              "Selecting Chinese (Simplified) or Norwegian Bokmål would lock up app",
        }
      ],
    },
    {
      "version": "v3.0.0-alpha.2",
      "date": "March 8, 2022",
      "changes": [
        {
          "type": "new",
          "detail":
              "Translations are now implemented, check the Help Translate page to assist with translating",
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
          "detail":
              "Version 3 is a work in progress being re-written from the ground up",
        },
        {
          "type": "important",
          "detail":
              "Check the 'How To Test' page on how to submit feedback or bugs",
        },
        {
          "type": "important",
          "detail":
              "Donations cannot be tested in the alpha, they will always fail to load",
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
