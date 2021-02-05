/// Throw when no servers are configured
class MissingServerException implements Exception {}

/// Throw when a server provides an undesired response.
class ServerException implements Exception {}

/// Throw when the device has no network connectivity.
class ConnectionException implements Exception {}

/// Throw when required settings are missing.
class SettingsException implements Exception {}

/// Throw when a json.decode() fails.
class JsonDecodeException implements Exception {}

/// Throw when trying to add a Tautulli server does not meet the min version.
class ServerVersionException implements Exception {}

/// Throw when the get metadata API call returns an empty result.
class MetadataEmptyException implements Exception {}

/// Throw when the get library media info API call returns an empty result.
class LibraryMediaInfoEmptyException implements Exception {}
