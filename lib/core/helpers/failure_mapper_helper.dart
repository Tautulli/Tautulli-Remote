import 'dart:async';
import 'dart:io';

import '../../features/logging/domain/usecases/logging.dart';
import '../../injection_container.dart' as di;
import '../error/exception.dart';
import '../error/failure.dart';
import '../requirements/versions.dart';

// Error messages
const String MISSING_SERVER_FAILURE_MESSAGE = 'No servers are configured.';
const String SERVER_FAILURE_MESSAGE = 'Failed to connect to server.';
const String CONNECTION_FAILURE_MESSAGE = 'No network connectivity.';
const String SETTINGS_FAILURE_MESSAGE = 'Required settings are missing.';
const String SOCKET_FAILURE_MESSAGE =
    'Failed to connect to Connection Address.';
const String TLS_FAILURE_MESSAGE = 'Failed to establish TLS/SSL connection.';
const String CERTIFICATE_EXPIRED_FAILURE_MESSAGE =
    'TLS/SSL Certificate is Expired.';
const String CERTIFICATE_VERIFICATION_FAILURE_MESSAGE =
    'Certificate verification failed.';
const String URL_FORMAT_FAILURE_MESSAGE = 'Incorrect URL format.';
const String TIMEOUT_FAILURE_MESSAGE = 'Connection to server timed out.';
const String JSON_FAILURE_MESSAGE = 'Failed to parse response.';
const String TERMINATE_FAILURE_MESSAGE = 'Failed to terminate the stream.';
const String DELETE_SYNCED_FAILURE_MESSAGE =
    'Failed to delete the synced item.';
const String SERVER_VERSION_FAILURE_MESSAGE =
    'Server version does not meet requirements.';
const String METADATA_EMPTY_FAILURE_MESSAGE = 'No metadata found.';
const String LIBRARY_MEDIA_INFO_EMPTY_FAILURE_MESSAGE = 'No data found';

// Error suggestions
const String MISSING_SERVER_SUGGESTION =
    'Please register with a Tautulli server.';
const String CHECK_CONNECTION_ADDRESS_SUGGESTION =
    'Check your Connection Address for errors.';
const String CHECK_SERVER_SETTINGS_SUGGESTION =
    'Please verify your connection settings.';
const String PLEX_CONNECTION_SUGGESTION =
    'Check your Connection Address for errors and make sure Tautulli can communicate with Plex.';
const String CERTIFICATE_EXPIRED_FAILURE_SUGGESTION =
    'Please check your certificate and re-register with your Tautulli server.';
const String CERTIFICATE_VERIFICATION_FAILURE_SUGGESTION =
    'Please re-register with your Tautulli server.';
const String TERMINATE_SUGGESTION = 'Make sure the stream is still active.';
final String serverVersionSuggestion =
    'Please update the Tautulli server to v${MinimumVersion.tautulliServer} or greater';
const String METADATA_EMPTY_FAILURE_SUGGESTION =
    'The rating key for this item might be incorrect.';

class FailureMapperHelper {
  /// Map [Exception] to corresponding [Failure].
  static Failure mapExceptionToFailure(dynamic exception) {
    Failure failure;

    if ([
      TimeoutException,
      SettingsException,
      JsonDecodeException,
      HandshakeException,
      SocketException,
      ServerException,
      ServerVersionException,
    ].contains(exception.runtimeType)) {
      exception = exception.runtimeType;
    }

    switch (exception) {
      case (MissingServerException):
        failure = MissingServerFailure();
        break;
      case (SettingsException):
        failure = SettingsFailure();
        break;
      case (ServerException):
        failure = ServerFailure();
        break;
      case (SocketException):
        failure = SocketFailure();
        break;
      case (HandshakeException):
      case (TlsException):
        failure = TlsFailure();
        break;
      case (CertificateExpiredException):
        failure = CertificateExpiredFailure();
        break;
      case (CertificateVerificationException):
        failure = CertificateVerificationFailure();
        break;
      case (FormatException):
        failure = UrlFormatFailure();
        break;
      case (ArgumentError):
        failure = UrlFormatFailure();
        break;
      case (TimeoutException):
        failure = TimeoutFailure();
        break;
      case (JsonDecodeException):
        failure = JsonDecodeFailure();
        break;
      case (ServerVersionException):
        failure = ServerVersionFailure();
        break;
      case (MetadataEmptyException):
        failure = MetadataEmptyFailure();
        break;
      default:
        di
            .sl<Logging>()
            .error('FailureMapper: Exception not accounted for: $exception');
    }

    return failure;
  }

  /// Maps [Failure] to appropriate message.
  static String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case MissingServerFailure:
        return MISSING_SERVER_FAILURE_MESSAGE;
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case ConnectionFailure:
        return CONNECTION_FAILURE_MESSAGE;
      case SettingsFailure:
        return SETTINGS_FAILURE_MESSAGE;
      case SocketFailure:
        return SOCKET_FAILURE_MESSAGE;
      case TlsFailure:
        return TLS_FAILURE_MESSAGE;
      case CertificateExpiredFailure:
        return CERTIFICATE_EXPIRED_FAILURE_MESSAGE;
      case CertificateVerificationFailure:
        return CERTIFICATE_VERIFICATION_FAILURE_MESSAGE;
      case UrlFormatFailure:
        return URL_FORMAT_FAILURE_MESSAGE;
      case TimeoutFailure:
        return TIMEOUT_FAILURE_MESSAGE;
      case JsonDecodeFailure:
        return JSON_FAILURE_MESSAGE;
      case TerminateFailure:
        return TERMINATE_FAILURE_MESSAGE;
      case ServerVersionFailure:
        return SERVER_VERSION_FAILURE_MESSAGE;
      case MetadataEmptyFailure:
        return METADATA_EMPTY_FAILURE_MESSAGE;
      case LibraryMediaInfoEmptyFailure:
        return LIBRARY_MEDIA_INFO_EMPTY_FAILURE_MESSAGE;
      case DeleteSyncedFailure:
        return DELETE_SYNCED_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

  /// Maps [Failure] to appropriate suggestions.
  static String mapFailureToSuggestion(Failure failure) {
    switch (failure.runtimeType) {
      case MissingServerFailure:
        return MISSING_SERVER_SUGGESTION;
      case ServerFailure:
        return CHECK_SERVER_SETTINGS_SUGGESTION;
      case SettingsFailure:
        return CHECK_SERVER_SETTINGS_SUGGESTION;
      case SocketFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case TlsFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case CertificateExpiredFailure:
        return CERTIFICATE_EXPIRED_FAILURE_SUGGESTION;
      case CertificateVerificationFailure:
        return CERTIFICATE_VERIFICATION_FAILURE_SUGGESTION;
      case UrlFormatFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case TimeoutFailure:
        return PLEX_CONNECTION_SUGGESTION;
      case JsonDecodeFailure:
        return CHECK_CONNECTION_ADDRESS_SUGGESTION;
      case TerminateFailure:
        return TERMINATE_SUGGESTION;
      case ServerVersionFailure:
        return serverVersionSuggestion;
      case MetadataEmptyFailure:
      case LibraryMediaInfoEmptyFailure:
        return METADATA_EMPTY_FAILURE_SUGGESTION;
      case DeleteSyncedFailure:
        return PLEX_CONNECTION_SUGGESTION;
      default:
        return '';
    }
  }
}
