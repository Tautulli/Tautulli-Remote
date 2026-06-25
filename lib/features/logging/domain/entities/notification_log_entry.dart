class NotificationLogEntry {
  final DateTime timestamp;
  final String platform;
  final bool? encrypted;
  final int? encryptionVersion;
  final bool? decryptionSuccess;
  final String? decryptionError;
  final bool imageRequested;
  final bool? imageSuccess;
  final String? imageError;

  const NotificationLogEntry({
    required this.timestamp,
    required this.platform,
    required this.encrypted,
    required this.encryptionVersion,
    required this.decryptionSuccess,
    required this.decryptionError,
    required this.imageRequested,
    required this.imageSuccess,
    required this.imageError,
  });
}
