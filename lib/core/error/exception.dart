/// Throw when a 401 response containing 'Authorization Required' is returned.
/// Typically, from missing basic authentication headers.
class AuthorizationRequiredException implements Exception {}

/// Throw when the API response is missing required information.
class BadApiResponseException implements Exception {}

/// Throw when a TSL/SSL certificate is expired.
class CertificateExpiredException implements Exception {}

/// Throw when a HandshakeException with CERTIFICATE_VERIFY_FAILED is thrown.
class CertificateVerificationException implements Exception {}

// /// Throw when connection details are missing.
// class ConnectionDetailsException implements Exception {}

/// Throw when there is an error initializing the database.
class DatabaseInitException implements Exception {}

/// Throw when the provided connection protocol is not `http` or `https`.
class IncorrectConnectionProtocolException implements Exception {}

/// Throw when a custom header key or value is not valid HTTP (e.g. a key
/// containing ':' or whitespace), which dart:io would otherwise reject with a
/// FormatException when building the request.
class InvalidHeaderException implements Exception {}

/// Throw when Tautulli responds with 'Invalid apikey'.
class InvalidApiKeyException implements Exception {}

// /// Throw when a json.decode() fails.
// class JsonDecodeException implements Exception {}

/// Throw when a server provides an undesired response.
class ServerException implements Exception {}

/// Throw when a returned ServerModel is null
class ServerNotFoundException implements Exception {}

/// Throw when trying to add a Tautulli server does not meet the min version.
class ServerVersionException implements Exception {}

/// Throw when the push token cannot be determined.
///
/// Distinct from the device having notifications turned off: that is recorded
/// deliberately, whereas a lookup that failed must not be, or the server would
/// be told to stop sending notifications to a device that still wants them.
class PushTokenUnavailableException implements Exception {}

// /// Throw when required settings are missing.
// class SettingsException implements Exception {}

/// Throw when a stream fails to terminate
class TerminateStreamException implements Exception {}
