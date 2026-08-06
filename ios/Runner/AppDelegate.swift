import Flutter
import UIKit
import os.log

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    excludeSharedContainerFromBackup()
    // On a fresh install the shared container is not provisioned this early and
    // the database does not exist until Dart opens it, so the first pass marks
    // nothing. Backgrounding is the one that matters: it is the last thing to
    // happen before a backup can run, and by then the database exists.
    for event in [UIApplication.didBecomeActiveNotification, UIApplication.didEnterBackgroundNotification] {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(excludeSharedContainerFromBackup),
        name: event,
        object: nil
      )
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Keeps the shared container out of iCloud and Finder backups. It holds
  /// tautulli_remote.db, whose servers table carries every server's Tautulli API
  /// key along with its addresses and custom headers, and a local backup is not
  /// encrypted by default.
  ///
  /// Backups only. Whether Quick Start carries an excluded file across to a new
  /// phone is undocumented and not attempted here: it needs the old phone unlocked
  /// and in hand, and a device token is revoked per device from Tautulli.
  ///
  /// Re-applied on launch, on activation and on backgrounding, because ordinary
  /// file operations reset the value, and on a fresh install neither the container
  /// nor the database exists yet when the app first finishes launching.
  ///
  /// Each file is named rather than left to the container's mark. Marking a
  /// directory is the documented way to cover what it holds, but the container is
  /// a backup domain root and Apple documents nothing about marking one, so it is
  /// carried as a belt and not a strap. Failures are logged so this cannot
  /// quietly read as protection it is not providing.
  @objc private func excludeSharedContainerFromBackup() {
    guard let container = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.com.tautulli.tautulliRemote.onesignal"
    ) else { return }

    let contents = [
      "tautulli_remote.db",
      "notification_action.json",
      "notification_diagnostic_log.json",
    ].map(container.appendingPathComponent)

    for target in [container] + contents {
      guard FileManager.default.fileExists(atPath: target.path) else { continue }

      var url = target
      var values = URLResourceValues()
      values.isExcludedFromBackup = true

      do {
        try url.setResourceValues(values)
      } catch {
        os_log(
          "%{public}@",
          log: OSLog(subsystem: "com.tautulli.tautulliRemote", category: "Backup"),
          type: OSLogType.error,
          "Failed to exclude \(url.lastPathComponent) from backup: \(error)"
        )
      }
    }
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
