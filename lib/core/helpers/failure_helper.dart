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
String serverVersionSuggestion = LocaleKeys.error_suggestion_server_version.tr(
  args: [MinimumVersion.tautulliServer.toString()],
);
String terminateStreamSuggestion = LocaleKeys.error_suggestion_terminate_stream_failed.tr();

class FailureHelper {
  /// Map `Exception` to corresponding `Failure`.
  ///
  /// Unknown exceptions will map to `GenericFailure`.
  static Failure castToFailure(dynamic exception) {
    // Parse DioException responses to map to more specific errors
    if (exception is DioException) {
      final responseString = exception.response.toString();

      if (responseString.toLowerCase().contains('authorization required')) {
        exception = AuthorizationRequiredException();
      } else if (responseString.contains('"message":"Invalid apikey"')) {
        exception = InvalidApiKeyException();
      } else if (responseString.contains('"message":"Failed to terminate session')) {
        exception = TerminateStreamException();
      } else {
        if (isNotBlank(responseString) && responseString != 'null') {
          di.sl<Logging>().error(
            'FailureMapper :: Unaccounted for HTTP client error response [$responseString]',
          );
        }
        exception = ServerException();
      }
    }

    switch (exception) {
      case AuthorizationRequiredException _:
        return AuthorizationRequiredFailure();
      case BadApiResponseException _:
        return BadApiResponseFailure();
      case CertificateExpiredException _:
        return CertificateExpiredFailure();
      case CertificateVerificationException _:
        return CertificateVerificationFailure();
      // case ConnectionDetailsException _:
      //   return ConnectionDetailsFailure();
      case DatabaseInitException _:
        return DatabaseInitFailure();
      case DioException _:
        return DioFailure();
      case InvalidApiKeyException _:
        return InvalidApiKeyFailure();
      // case HandshakeException _:
      //   return TlsFailure();
      // case JsonDecodeException _:
      //   return JsonDecodeFailure();
      case ServerException _:
        return ServerFailure();
      case ServerVersionException _:
        return ServerVersionFailure();
      // case SettingsException _:
      //   return SettingsFailure();
      // case SocketException _:
      //   return SocketFailure();
      case TerminateStreamException _:
        return TerminateStreamFailure();
      case TimeoutException _:
        return TimeoutFailure();
      // case TlsException _:
      //   return TlsFailure();
      default:
        di.sl<Logging>().error(
          'FailureMapper :: Unable to map [$exception] to a specific failure',
        );
        return GenericFailure();
    }
  }

  static String mapFailureToMessage(Failure failure) {
    switch (failure) {
      case AuthorizationRequiredFailure _:
        return serverMessage;
      case BadApiResponseFailure _:
        return badApiResponseMessage;
      case CertificateExpiredFailure _:
        return certificateExpiredMessage;
      case CertificateVerificationFailure _:
        return certificateVerificationMessage;
      // case ConnectionDetailsFailure _:
      //   return settingsMessage;
      case ConnectionFailure _:
        return connectionMessage;
      case DatabaseInitFailure _:
        return dataBaseInitMessage;
      case InvalidApiKeyFailure _:
        return invalidApiKeyMessage;
      // case JsonDecodeFailure _:
      //   return jsonMessage;
      case MissingServerFailure _:
        return missingServerMessage;
      case DioFailure _:
      case ServerFailure _:
        return serverMessage;
      case ServerVersionFailure _:
        return serverVersionMessage;
      // case SettingsFailure _:
      //   return settingsMessage;
      // case SocketFailure _:
      //   return socketMessage;
      case TerminateStreamFailure _:
        return terminateStreamMessage;
      case TimeoutFailure _:
        return timeoutMessage;
      // case TlsFailure _:
      //   return tlsMessage;
      case GenericFailure _:
      default:
        return genericMessage;
    }
  }

  static String mapFailureToSuggestion(Failure failure) {
    switch (failure) {
      case AuthorizationRequiredFailure _:
        return authorizationRequiredSuggestion;
      case BadApiResponseFailure _:
        return badApiResponseSuggestion;
      case CertificateExpiredFailure _:
        return certificateExpiredSuggestion;
      case CertificateVerificationFailure _:
        return certificateVerificationSuggestion;
      // case ConnectionDetailsFailure _:
      //   return checkServerSettingsSuggestion;
      case ConnectionFailure _:
        return '';
      case DatabaseInitFailure _:
        return genericSuggestion;
      case InvalidApiKeyFailure _:
        return invalidApiKeySuggestion;
      // case JsonDecodeFailure _:
      //   return checkConnectionAddressSuggestion;
      case MissingServerFailure _:
        return missingServerSuggestion;
      case DioFailure _:
      case ServerFailure _:
        return checkServerSettingsSuggestion;
      case ServerVersionFailure _:
        return serverVersionSuggestion;
      // case SettingsFailure _:
      //   return checkServerSettingsSuggestion;
      // case SocketFailure _:
      //   return checkConnectionAddressSuggestion;
      case TerminateStreamFailure _:
        return terminateStreamSuggestion;
      case TimeoutFailure _:
        return plexConnectionSuggestion;
      // case TlsFailure _:
      //   return checkConnectionAddressSuggestion;
      case GenericFailure _:
      default:
        return genericSuggestion;
    }
  }
}
