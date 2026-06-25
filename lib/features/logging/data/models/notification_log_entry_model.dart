import '../../domain/entities/notification_log_entry.dart';

class NotificationLogEntryModel extends NotificationLogEntry {
  const NotificationLogEntryModel({
    required super.timestamp,
    required super.platform,
    required super.encrypted,
    required super.encryptionVersion,
    required super.decryptionSuccess,
    required super.decryptionError,
    required super.imageRequested,
    required super.imageSuccess,
    required super.imageError,
  });

  factory NotificationLogEntryModel.fromJson(Map<String, dynamic> json) {
    return NotificationLogEntryModel(
      timestamp: DateTime.parse(json['timestamp'] as String),
      platform: json['platform'] as String? ?? 'unknown',
      encrypted: json['encrypted'] as bool?,
      encryptionVersion: json['encryption_version'] as int?,
      decryptionSuccess: json['decryption_success'] as bool?,
      decryptionError: json['decryption_error'] as String?,
      imageRequested: json['image_requested'] as bool? ?? false,
      imageSuccess: json['image_success'] as bool?,
      imageError: json['image_error'] as String?,
    );
  }
}
