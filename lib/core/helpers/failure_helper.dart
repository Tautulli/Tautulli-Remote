import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;
import 'package:tautulli/tautulli.dart' as pkg;

import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';
import '../../translations/locale_keys.g.dart';
import '../error/exception.dart';
import '../error/failure.dart';
import '../requirements/tautulli_version.dart';
import 'redaction_helper.dart';

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
      case DeviceIdUnavailableException _:
        return DeviceIdUnavailableFailure();
      case InvalidApiKeyException _:
        return InvalidApiKeyFailure();
      case InvalidHeaderException _:
        return InvalidHeaderFailure();
      // case HandshakeException _:
      //   return TlsFailure();
      // case JsonDecodeException _:
      //   return JsonDecodeFailure();
      case ServerException _:
        return ServerFailure();
      case ServerNotFoundException _:
        // No server matched the tautulliId (row deleted / active id went stale
        // while a fetch was in flight). Expected + handled — map it so it no
        // longer falls through to the default Crashlytics recorder.
        return MissingServerFailure();
      case ServerVersionException _:
        return ServerVersionFailure();
      case PushTokenUnavailableException _:
        return PushTokenUnavailableFailure();
      // case SettingsException _:
      //   return SettingsFailure();
      // Network I/O failures from datasources still using package:http / dart:io
      // directly (e.g. Announcements). Expected + handled — map to a connection
      // failure instead of recording them as Crashlytics noise.
      case http.ClientException _:
        return ConnectionFailure();
      case SocketException _:
        return ConnectionFailure();
      case TerminateStreamException _:
        return TerminateStreamFailure();
      case TimeoutException _:
        return TimeoutFailure();
      // case TlsException _:
      //   return TlsFailure();
      default:
        // Redacted because an unmapped exception often embeds the request URI,
        // which carries the user's API key into Crashlytics and the exportable log.
        final safeException = redactApiKey(exception.toString());
        di.sl<Logging>().error(
          'FailureMapper :: Unable to map [$safeException] to a specific failure',
        );
        FirebaseCrashlytics.instance.recordError(safeException, StackTrace.current, fatal: false);
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
      case DeviceIdUnavailableFailure _:
        return LocaleKeys.error_message_device_id_unavailable.tr();
      case InvalidApiKeyFailure _:
        return LocaleKeys.error_message_invalid_api_key.tr();
      case InvalidHeaderFailure _:
        return LocaleKeys.error_message_invalid_header.tr();
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
      case PushTokenUnavailableFailure _:
        return LocaleKeys.error_message_push_token_unavailable.tr();
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
      case DeviceIdUnavailableFailure _:
        return LocaleKeys.error_suggestion_device_id_unavailable.tr();
      case InvalidApiKeyFailure _:
        return LocaleKeys.error_suggestion_invalid_api_key.tr();
      case InvalidHeaderFailure _:
        return LocaleKeys.error_suggestion_invalid_header.tr();
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
      case PushTokenUnavailableFailure _:
        return LocaleKeys.error_suggestion_push_token_unavailable.tr();
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
