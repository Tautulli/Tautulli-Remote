import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quiver/strings.dart';

import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';
import '../../translations/locale_keys.g.dart';
import '../error/exception.dart';
import '../error/failure.dart';
import '../requirements/tautulli_version.dart';

//* Error Messages
String badApiResponseMessage = LocaleKeys.error_message_bad_api_response.tr();
String certificateExpiredMessage = LocaleKeys.error_message_certificate_expired.tr();
String certificateVerificationMessage = LocaleKeys.error_message_certificate_verification.tr();
String connectionMessage = LocaleKeys.error_message_connection.tr();
String dataBaseInitMessage = LocaleKeys.error_message_database_init.tr();
String genericMessage = LocaleKeys.error_message_generic.tr();
String invalidApiKeyMessage = LocaleKeys.error_message_invalid_api_key.tr();
//  String jsonMessage = 'Failed to parse response.';
String missingServerMessage = LocaleKeys.error_message_no_servers.tr();
String serverMessage = LocaleKeys.error_message_server.tr();
String serverVersionMessage = LocaleKeys.error_message_server_version.tr();
// const String settingsMessage = 'Required settings are missing.';
// const String socketMessage = 'Failed to connect to Connection Address.';
const String timeoutMessage = 'Connection to server timed out.';
// const String tlsMessage = 'Failed to establish TLS/SSL connection.';
String terminateStreamMessage = LocaleKeys.error_message_terminate_stream_failed.tr();

//* Error Suggestions
String authorizationRequiredSuggestion = LocaleKeys.error_suggestion_authorization_required.tr();
String badApiResponseSuggestion = LocaleKeys.error_suggestion_bad_api_response.tr();
String certificateExpiredSuggestion = LocaleKeys.error_suggestion_certificate_expired.tr();
String certificateVerificationSuggestion = LocaleKeys.error_suggestion_certificate_verification.tr();
String checkConnectionAddressSuggestion = LocaleKeys.error_suggestion_check_connection_address.tr();
String checkServerSettingsSuggestion = LocaleKeys.error_suggestion_check_server_settings.tr();
String genericSuggestion = LocaleKeys.error_suggestion_generic.tr();
String missingServerSuggestion = LocaleKeys.error_suggestion_register_server.tr();
String invalidApiKeySuggestion = LocaleKeys.error_suggestion_invalid_api_key.tr();
String plexConnectionSuggestion = LocaleKeys.error_suggestion_plex_connection.tr();
String serverVersionSuggestion =
    LocaleKeys.error_suggestion_server_version.tr(args: [MinimumVersion.tautulliServer.toString()]);
String terminateStreamSuggestion = LocaleKeys.error_suggestion_terminate_stream_failed.tr();

class FailureHelper {
  /// Map `Exception` to corresponding `Failure`.
  ///
  /// Unknown exceptions will map to `GenericFailure`.
  static Failure castToFailure(dynamic exception) {
    if ([
      TimeoutException,
      // SettingsException,
      // JsonDecodeException,
      // HandshakeException,
      // SocketException,
      ServerException,
      ServerVersionException,
      // DioError,
    ].contains(exception.runtimeType)) {
      exception = exception.runtimeType;
    }

    // Parse DioError responses to map to more specific errors
    if (exception.runtimeType == DioException) {
      final responseString = exception.response.toString();

      if (responseString.toLowerCase().contains('authorization required')) {
        exception = AuthorizationRequiredException;
      } else if (responseString.contains('"message":"Invalid apikey"')) {
        exception = InvalidApiKeyException;
      } else if (responseString.contains('"message":"Failed to terminate session')) {
        exception = TerminateStreamException;
      } else {
        if (isNotBlank(responseString) && responseString != 'null') {
          di.sl<Logging>().error(
                'FailureMapper :: Unaccounted for HTTP client error response [$responseString]',
              );
        }
        exception = ServerException;
      }
    }

    switch (exception) {
      case (AuthorizationRequiredException):
        return AuthorizationRequiredFailure();
      case (BadApiResponseException):
        return BadApiResponseFailure();
      case (CertificateExpiredException):
        return CertificateExpiredFailure();
      case (CertificateVerificationException):
        return CertificateVerificationFailure();
      // case (ConnectionDetailsException):
      //   return ConnectionDetailsFailure();
      case (DatabaseInitException):
        return DatabaseInitFailure();
      case (DioException):
        return DioFailure();
      case (InvalidApiKeyException):
        return InvalidApiKeyFailure();
      // case (HandshakeException):
      //   return TlsFailure();
      // case (JsonDecodeException):
      //   return JsonDecodeFailure();
      case (ServerException):
        return ServerFailure();
      case (ServerVersionException):
        return ServerVersionFailure();
      // case (SettingsException):
      //   return SettingsFailure();
      // case (SocketException):
      //   return SocketFailure();
      case (TerminateStreamException):
        return TerminateStreamFailure();
      case (TimeoutException):
        return TimeoutFailure();
      // case (TlsException):
      //   return TlsFailure();
      default:
        di.sl<Logging>().error(
              'FailureMapper :: Unable to map [$exception] to a specific failure',
            );
        return GenericFailure();
    }
  }

  static String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case (AuthorizationRequiredFailure):
        return serverMessage;
      case (BadApiResponseFailure):
        return badApiResponseMessage;
      case (CertificateExpiredFailure):
        return certificateExpiredMessage;
      case (CertificateVerificationFailure):
        return certificateVerificationMessage;
      // case (ConnectionDetailsFailure):
      //   return settingsMessage;
      case (ConnectionFailure):
        return connectionMessage;
      case (DatabaseInitFailure):
        return dataBaseInitMessage;
      case (InvalidApiKeyFailure):
        return invalidApiKeyMessage;
      // case (JsonDecodeFailure):
      //   return jsonMessage;
      case (MissingServerFailure):
        return missingServerMessage;
      case (DioFailure):
      case (ServerFailure):
        return serverMessage;
      case (ServerVersionFailure):
        return serverVersionMessage;
      // case (SettingsFailure):
      //   return settingsMessage;
      // case (SocketFailure):
      //   return socketMessage;
      case (TerminateStreamFailure):
        return terminateStreamMessage;
      case (TimeoutFailure):
        return timeoutMessage;
      // case (TlsFailure):
      //   return tlsMessage;
      case (GenericFailure):
      default:
        return genericMessage;
    }
  }

  static String mapFailureToSuggestion(Failure failure) {
    switch (failure.runtimeType) {
      case (AuthorizationRequiredFailure):
        return authorizationRequiredSuggestion;
      case (BadApiResponseFailure):
        return badApiResponseSuggestion;
      case (CertificateExpiredFailure):
        return certificateExpiredSuggestion;
      case (CertificateVerificationFailure):
        return certificateVerificationSuggestion;
      // case (ConnectionDetailsFailure):
      //   return checkServerSettingsSuggestion;
      case (ConnectionFailure):
        return '';
      case (DatabaseInitFailure):
        return genericSuggestion;
      case (InvalidApiKeyFailure):
        return invalidApiKeySuggestion;
      // case (JsonDecodeFailure):
      //   return checkConnectionAddressSuggestion;
      case (MissingServerFailure):
        return missingServerSuggestion;
      case (DioFailure):
      case (ServerFailure):
        return checkServerSettingsSuggestion;
      case (ServerVersionFailure):
        return serverVersionSuggestion;
      // case (SettingsFailure):
      //   return checkServerSettingsSuggestion;
      // case (SocketFailure):
      //   return checkConnectionAddressSuggestion;
      case (TerminateStreamFailure):
        return terminateStreamSuggestion;
      case (TimeoutFailure):
        return plexConnectionSuggestion;
      // case (TlsFailure):
      //   return checkConnectionAddressSuggestion;
      case (GenericFailure):
      default:
        return genericSuggestion;
    }
  }
}
