import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Notification-permission request that tolerates a concurrent request.
///
/// iOS `permission_handler` throws
/// `PlatformException(ERROR_ALREADY_REQUESTING_PERMISSIONS)` when
/// `Permission.notification.request()` is called while a previous request is
/// still pending (e.g. the notifications consent switch is tapped again before
/// the system prompt resolves). Swallow that specific error so the redundant tap
/// is a no-op instead of an uncaught crash.
class PermissionHelper {
  /// Requests the notification permission, or returns `null` when the platform
  /// rejected the call because a request was already running. Callers should
  /// treat `null` as "do nothing" and let the original request resolve.
  static Future<PermissionStatus?> requestNotification() async {
    try {
      return await Permission.notification.request();
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_ALREADY_REQUESTING_PERMISSIONS') return null;
      rethrow;
    }
  }
}
