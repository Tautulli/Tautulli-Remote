/// Throw when a server provides an undesired response. 
class ServerException implements Exception {}
/// Throw when the device has no network connectivity.
class ConnectionException implements Exception {}
/// Throw when required settings are missing.
class SettingsException implements Exception {}