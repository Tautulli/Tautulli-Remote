import 'package:equatable/equatable.dart';

abstract class NewFailure extends Equatable {
  @override
  List<Object> get props => [];
}

/// The TSL/SSL certificate is expired.
class CertificateExpiredFailure extends NewFailure {}

/// A failure in verifying the TSL/SSL certificate.
class CertificateVerificationFailure extends NewFailure {}

/// Connection details are missing.
class ConnectionDetailsFailure extends NewFailure {}

/// Device is not connected to a network.
class ConnectionFailure extends NewFailure {}

/// Error initalizing the database.
class DatabaseInitFailure extends NewFailure {}

/// A catch-all Failure.
class GenericFailure extends NewFailure {}

/// Error parsing JSON.
class JsonDecodeFailure extends NewFailure {}

/// No servers are configured.
class MissingServerFailure extends NewFailure {}

// Server has provided an undesired response.
class ServerFailure extends NewFailure {}

/// Server min version is not met.
class ServerVersionFailure extends NewFailure {}

/// Required settings are missing.
class SettingsFailure extends NewFailure {}

/// Unable to connect to a provided address.
class SocketFailure extends NewFailure {}

/// Time to connect to a server exceeded.
class TimeoutFailure extends NewFailure {}

/// A failure in TLS/SSL connection.
class TlsFailure extends NewFailure {}

/// URL provided is improperly formatted.
class UrlFormatFailure extends NewFailure {}
