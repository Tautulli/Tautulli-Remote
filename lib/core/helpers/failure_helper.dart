import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';
import '../error/exception.dart';
import '../error/failure.dart';
import '../requirements/tautulli_version.dart';

//* Error Messages
const String certificateExpiredMessage = 'TLS/SSL Certificate is Expired.';
const String certificateVerificationMessage =
    'Certificate verification failed.';
const String connectionMessage = 'No network connectivity.';
const String dataBaseInitMessage = 'Failed to initalize database.';
const String genericMessage = 'Unknown error.';
const String jsonMessage = 'Failed to parse response.';
const String missingServerMessage = 'No servers are configured.';
const String serverMessage = 'Failed to connect to server.';
const String serverVersionMessage =
    'Server version does not meet requirements.';
const String settingsMessage = 'Required settings are missing.';
const String socketMessage = 'Failed to connect to Connection Address.';
const String timeoutMessage = 'Connection to server timed out.';
const String tlsMessage = 'Failed to establish TLS/SSL connection.';

//* Error Suggestions
const String certificateExpiredSuggestion =
    'Please check your certificate and re-register with your Tautulli server.';
const String certificateVerificationSuggestion =
    'Please re-register with your Tautulli server.';
const String checkConnectionAddressSuggestion =
    'Check your Connection Address for errors.';
const String checkServerSettingsSuggestion =
    'Please verify your connection settings.';
const String genericSuggestion = 'Please contact Support.';
const String missingServerSuggestion =
    'Please register with a Tautulli server.';
const String plexConnectionSuggestion =
    'Check your Connection Address for errors and make sure Tautulli can communicate with Plex.';
final String serverVersionSuggestion =
    'Please update the Tautulli server to v${MinimumVersion.tautulliServer} or greater';

class FailureHelper {
  /// Map `Exception` to corresponding `Failure`.
  ///
  /// Unknown exceptions will map to `GenericFailure`.
  static Failure castToFailure(dynamic exception) {
    Response? dioResponse;

    if ([
      TimeoutException,
      SettingsException,
      JsonDecodeException,
      HandshakeException,
      SocketException,
      ServerException,
      ServerVersionException,
      // DioError,
    ].contains(exception.runtimeType)) {
      exception = exception.runtimeType;
    }

    if (exception.runtimeType == DioError) {
      dioResponse = exception.response;
      exception = exception.runtimeType;
    }

    switch (exception) {
      case (CertificateExpiredException):
        return CertificateExpiredFailure();
      case (CertificateVerificationException):
        return CertificateVerificationFailure();
      case (ConnectionDetailsException):
        return ConnectionDetailsFailure();
      case (DatabaseInitException):
        return DatabaseInitFailure();
      case (DioError):
        //TODO: More granular failures, could also provide tautulli error message
        return DioFailure(data: dioResponse);
      case (HandshakeException):
        return TlsFailure();
      case (JsonDecodeException):
        return JsonDecodeFailure();
      case (ServerException):
        return ServerFailure();
      case (ServerVersionException):
        return ServerVersionFailure();
      case (SettingsException):
        return SettingsFailure();
      case (SocketException):
        return SocketFailure();
      case (TimeoutException):
        return TimeoutFailure();
      case (TlsException):
        return TlsFailure();
      default:
        di.sl<Logging>().error(
              'Unable to map [$exception] to a specific failure',
            );
        return GenericFailure();
    }
  }

  static String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case (CertificateExpiredFailure):
        return certificateExpiredMessage;
      case (CertificateVerificationFailure):
        return certificateVerificationMessage;
      case (ConnectionDetailsFailure):
        return settingsMessage;
      case (ConnectionFailure):
        return connectionMessage;
      case (DatabaseInitFailure):
        return dataBaseInitMessage;
      case (JsonDecodeFailure):
        return jsonMessage;
      case (MissingServerFailure):
        return missingServerMessage;
      case (ServerFailure):
        return serverMessage;
      case (ServerVersionFailure):
        return serverVersionMessage;
      case (SettingsFailure):
        return settingsMessage;
      case (SocketFailure):
        return socketMessage;
      case (TimeoutFailure):
        return timeoutMessage;
      case (TlsFailure):
        return tlsMessage;
      case (GenericFailure):
      default:
        return genericMessage;
    }
  }

  static String mapFailureToSuggestion(Failure failure) {
    switch (failure.runtimeType) {
      case (CertificateExpiredFailure):
        return certificateExpiredSuggestion;
      case (CertificateVerificationFailure):
        return certificateVerificationSuggestion;
      case (ConnectionDetailsFailure):
        return checkServerSettingsSuggestion;
      case (ConnectionFailure):
        return '';
      case (DatabaseInitFailure):
        return genericSuggestion;
      case (JsonDecodeFailure):
        return checkConnectionAddressSuggestion;
      case (MissingServerFailure):
        return missingServerSuggestion;
      case (ServerFailure):
        return checkServerSettingsSuggestion;
      case (ServerVersionFailure):
        return serverVersionSuggestion;
      case (SettingsFailure):
        return checkServerSettingsSuggestion;
      case (SocketFailure):
        return checkConnectionAddressSuggestion;
      case (TimeoutFailure):
        return plexConnectionSuggestion;
      case (TlsFailure):
        return checkConnectionAddressSuggestion;
      case (GenericFailure):
      default:
        return genericSuggestion;
    }
  }
}
