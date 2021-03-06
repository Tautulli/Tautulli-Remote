import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // Failure([List properties = const <dynamic>[]]) : super(properties);
  @override
  List<Object> get props => [];
}

// General failures
/// No servers are configured.
class MissingServerFailure extends Failure {}

/// Server provides an undesired response.
class ServerFailure extends Failure {}

/// Device is not connected to a network.
class ConnectionFailure extends Failure {}

/// Scanning QR code fails to return a proper address and device token.
class QRScanFailure extends Failure {}

/// Required settings are missing.
class SettingsFailure extends Failure {}

/// Unable to connect to a provided address.
class SocketFailure extends Failure {}

/// A failure in TLS/SSL connection.
class TlsFailure extends Failure {}

/// The TSL/SSL certificate is expired
class CertificateExpiredFailure extends Failure {}

/// A failure in verifying the TSL/SSL certificate
class CertificateVerificationFailure extends Failure {}

/// URL provided is improperly formatted.
class UrlFormatFailure extends Failure {}

/// Time to connect to a server exceeded.
class TimeoutFailure extends Failure {}

/// A json.decode() failed.
class JsonDecodeFailure extends Failure {}

/// Server min version is not met.
class ServerVersionFailure extends Failure {}

/// The terminate session API call returned false.
class TerminateFailure extends Failure {}

/// The delete synced item API call returned false.
class DeleteSyncedFailure extends Failure {}

/// The get metadata API call returned an empty result.
class MetadataEmptyFailure extends Failure {}

/// The get library media info API call returned an empty result.
class LibraryMediaInfoEmptyFailure extends Failure {}

/// A catch-all Failure.
class UnknownFailure extends Failure {}
