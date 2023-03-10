import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

/// A 401 response containing 'Authorization Required' was returned. Typically,
/// from missing basic authentication headers.
class AuthorizationRequiredFailure extends Failure {}

/// The API response is missing required information.
class BadApiResponseFailure extends Failure {}

/// The TSL/SSL certificate is expired.
class CertificateExpiredFailure extends Failure {}

/// A failure in verifying the TSL/SSL certificate.
class CertificateVerificationFailure extends Failure {}

// /// Connection details are missing.
// class ConnectionDetailsFailure extends Failure {}

/// Device is not connected to a network.
class ConnectionFailure extends Failure {}

/// Error initalizing the database.
class DatabaseInitFailure extends Failure {}

/// Error thrown by the dio HTTP client.
class DioFailure extends Failure {}

/// A catch-all Failure.
class GenericFailure extends Failure {}

/// Tautulli has responded with the error 'Invalid apikey'.
class InvalidApiKeyFailure extends Failure {}

// /// Error parsing JSON.
// class JsonDecodeFailure extends Failure {}

/// No servers are configured.
class MissingServerFailure extends Failure {}

// Server has provided an undesired response.
class ServerFailure extends Failure {}

/// Server min version is not met.
class ServerVersionFailure extends Failure {}

// /// Required settings are missing.
// class SettingsFailure extends Failure {}

// /// Unable to connect to a provided address.
// class SocketFailure extends Failure {}

/// Failed to terminate a stream
class TerminateStreamFailure extends Failure {}

/// Time to connect to a server exceeded.
class TimeoutFailure extends Failure {}

// /// A failure in TLS/SSL connection.
// class TlsFailure extends Failure {}

// /// URL provided is improperly formatted.
// class UrlFormatFailure extends Failure {}
