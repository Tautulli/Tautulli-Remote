Map changelog = {
  "data": [
    {
      "version": "v2.3.2",
      "date": "March 8, 2021",
      "changes": [
        {
          "type": "fix",
          "detail": "Fix failure mapping for ServerVersionException",
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
