import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // Failure([List properties = const <dynamic>[]]) : super(properties);
  @override
  List<Object> get props => [];
}

// General failures
/// Server provides an undesired response. 
class ServerFailure extends Failure {}
/// Device is not connected to a network.
class ConnectionFailure extends Failure {}
/// Required settings are missing.
class SettingsFailure extends Failure {}
/// Unable to connect to a provided address.
class SocketFailure extends Failure {}
/// A failure in TLS/SSL connection.
class TlsFailure extends Failure {}
/// URL provided is improperly formatted.
class UrlFormatFailure extends Failure {}