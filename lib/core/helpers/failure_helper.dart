import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:tautulli/tautulli.dart' as pkg;

import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';
import '../../translations/locale_keys.g.dart';
import '../error/exception.dart';
import '../error/failure.dart';
import '../requirements/tautulli_version.dart';

const String timeoutMessage = 'Connection to server timed out.';

class FailureHelper {
  /// Map `Exception` to corresponding `Failure`.
  ///
  /// Unknown exceptions will map to `GenericFailure`.
  static Failure castToFailure(dynamic exception) {
    switch (exception) {
      // --- Package exceptions (new TautulliConnectionAdapter-based datasources) ---
      case pkg.TautulliAuthException _:
        return AuthorizationRequiredFailure();
      case pkg.TautulliBadResponseException _:
        return BadApiResponseFailure();
      case pkg.TautulliCertExpiredException _:
        return CertificateExpiredFailure();
      case pkg.TautulliCertVerificationException _:
        return CertificateVerificationFailure();
      case pkg.TautulliConnectionException _:
        return ConnectionFailure();
      case pkg.TautulliInvalidApiKeyException _:
        return InvalidApiKeyFailure();
      case pkg.TautulliServerException _:
        return ServerFailure();
      case pkg.TautulliTerminateStreamException _:
        return TerminateStreamFailure();
      case pkg.TautulliTimeoutException _:
        return TimeoutFailure();
      case pkg.TautulliVersionException _:
        return ServerVersionFailure();
      case pkg.TautulliProtocolException _:
        return ConnectionFailure();
      // --- Legacy app exceptions (datasources not yet migrated to the adapter) ---
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
        FirebaseCrashlytics.instance.recordError(exception, StackTrace.current, fatal: false);
        return GenericFailure();
    }
  }

  static String mapFailureToMessage(Failure failure) {
    switch (failure) {
      case AuthorizationRequiredFailure _:
        return LocaleKeys.error_message_server.tr();
      case BadApiResponseFailure _:
        return LocaleKeys.error_message_bad_api_response.tr();
      case CertificateExpiredFailure _:
        return LocaleKeys.error_message_certificate_expired.tr();
      case CertificateVerificationFailure _:
        return LocaleKeys.error_message_certificate_verification.tr();
      // case ConnectionDetailsFailure _:
      //   return settingsMessage;
      case ConnectionFailure _:
        return LocaleKeys.error_message_connection.tr();
      case DatabaseInitFailure _:
        return LocaleKeys.error_message_database_init.tr();
      case InvalidApiKeyFailure _:
        return LocaleKeys.error_message_invalid_api_key.tr();
      case InvalidParamsFailure _:
        return LocaleKeys.error_message_invalid_params.tr();
      // case JsonDecodeFailure _:
      //   return jsonMessage;
      case MissingServerFailure _:
        return LocaleKeys.error_message_no_servers.tr();
      case ServerFailure _:
        return LocaleKeys.error_message_server.tr();
      case ServerVersionFailure _:
        return LocaleKeys.error_message_server_version.tr();
      // case SettingsFailure _:
      //   return settingsMessage;
      // case SocketFailure _:
      //   return socketMessage;
      case TerminateStreamFailure _:
        return LocaleKeys.error_message_terminate_stream_failed.tr();
      case TimeoutFailure _:
        return timeoutMessage;
      // case TlsFailure _:
      //   return tlsMessage;
      case GenericFailure _:
      default:
        return LocaleKeys.error_message_generic.tr();
    }
  }

  static String mapFailureToSuggestion(Failure failure) {
    switch (failure) {
      case AuthorizationRequiredFailure _:
        return LocaleKeys.error_suggestion_authorization_required.tr();
      case BadApiResponseFailure _:
        return LocaleKeys.error_suggestion_bad_api_response.tr();
      case CertificateExpiredFailure _:
        return LocaleKeys.error_suggestion_certificate_expired.tr();
      case CertificateVerificationFailure _:
        return LocaleKeys.error_suggestion_certificate_verification.tr();
      // case ConnectionDetailsFailure _:
      //   return checkServerSettingsSuggestion;
      case ConnectionFailure _:
        return '';
      case DatabaseInitFailure _:
        return LocaleKeys.error_suggestion_generic.tr();
      case InvalidApiKeyFailure _:
        return LocaleKeys.error_suggestion_invalid_api_key.tr();
      case InvalidParamsFailure _:
        return '';
      // case JsonDecodeFailure _:
      //   return checkConnectionAddressSuggestion;
      case MissingServerFailure _:
        return LocaleKeys.error_suggestion_register_server.tr();
      case ServerFailure _:
        return LocaleKeys.error_suggestion_check_server_settings.tr();
      case ServerVersionFailure _:
        return LocaleKeys.error_suggestion_server_version.tr(
          args: [MinimumVersion.tautulliServer.toString()],
        );
      // case SettingsFailure _:
      //   return checkServerSettingsSuggestion;
      // case SocketFailure _:
      //   return checkConnectionAddressSuggestion;
      case TerminateStreamFailure _:
        return LocaleKeys.error_suggestion_terminate_stream_failed.tr();
      case TimeoutFailure _:
        return LocaleKeys.error_suggestion_plex_connection.tr();
      // case TlsFailure _:
      //   return checkConnectionAddressSuggestion;
      case GenericFailure _:
      default:
        return LocaleKeys.error_suggestion_generic.tr();
    }
  }
}
