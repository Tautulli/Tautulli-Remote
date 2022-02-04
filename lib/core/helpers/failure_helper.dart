import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../dependency_injection.dart' as di;
import '../../features/logging/domain/usecases/logging.dart';
import '../error/exception.dart';
import '../error/failure.dart';

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
}
