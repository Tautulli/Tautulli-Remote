/// Throw when a TSL/SSL certificate is expired.
class CertificateExpiredException implements Exception {}

/// Throw when a HandshakeException with CERTIFICATE_VERIFY_FAILED is thrown.
class CertificateVerificationException implements Exception {}

/// Throw when connection details are missing.
class ConnectionDetailsException implements Exception {}

/// Throw when there is an error initializing the database.
class DatabaseInitException implements Exception {}

/// Throw when the provided connection protocol is not `http` or `https`.
class IncorrectConnectionProtocolException implements Exception {}

/// Throw when a json.decode() fails.
class JsonDecodeException implements Exception {}

/// Throw when a server provides an undesired response.
class ServerException implements Exception {}

/// Throw when a returned ServerModel is null
class ServerNotFoundException implements Exception {}

/// Throw when trying to add a Tautulli server does not meet the min version.
class ServerVersionException implements Exception {}

/// Throw when required settings are missing.
class SettingsException implements Exception {}
