import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../../../dependency_injection.dart' as di;
import '../../../features/logging/domain/usecases/logging.dart';
import '../../../features/settings/domain/usecases/settings.dart';
import '../../error/exception.dart';
import '../../utilities/cast.dart';

abstract class CallTautulli {
  Future<Either<Uri, dynamic>> call({
    required String connectionProtocol,
    required String connectionDomain,
    required String? connectionPath,
    required String deviceToken,
    required String cmd,
    required Map<String, dynamic> params,
    required Map<String, String> headers,
    required bool trustCert,
    int? timeoutOverride,
  });
}

class CallTautulliImpl implements CallTautulli {
  @override
  Future<Either<Uri, dynamic>> call({
    required String connectionProtocol,
    required String connectionDomain,
    required String? connectionPath,
    required String deviceToken,
    required String cmd,
    required Map<String, dynamic> params,
    required Map<String, String> headers,
    required bool trustCert,
    int? timeoutOverride,
  }) async {
    // Add required parameter values into params
    params['cmd'] = cmd;
    params['apikey'] = deviceToken;
    params['app'] = 'true';

    // Make sure all values in params are cast to string
    for (String key in params.keys) {
      params[key] = Cast.castToString(params[key]);
    }

    // Construct URI using connection information and params
    Uri uri;
    switch (connectionProtocol.toLowerCase()) {
      case ('http'):
        uri = Uri.http(connectionDomain, '$connectionPath/api/v2', params);
        break;
      case ('https'):
        uri = Uri.https(connectionDomain, '$connectionPath/api/v2', params);
        break;
      default:
        throw IncorrectConnectionProtocolException();
    }

    //* Return URI for pmsImageProxy
    if (cmd == 'pms_image_proxy') {
      return Left(uri);
    }

    Dio dio = Dio();

    //* Handle Custom Certs
    // Get list of custom cert hashes
    List<int> customCertHashList = di.sl<Settings>().getCustomCertHashList();

    // If the certificate is valid check if it has been previously approved
    // by the user. If so, return true.
    //
    // If it has not been approved and trustCert is true the add hash to list.
    // Otherwise return false.
    //
    // Return CertificationExpiredException if the certificate is not valid.
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client = HttpClient();

        client.badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) {
          int certHashCode = cert.pem.hashCode;

          if (cert.endValidity.isAfter(DateTime.now())) {
            if (customCertHashList.contains(certHashCode)) {
              return true;
            } else {
              if (trustCert) {
                di.sl<Logging>().info(
                      'Settings :: New certificate added to trusted list',
                    );
                customCertHashList.add(certHashCode);
                return true;
              }
            }
          } else if (cert.endValidity.isBefore(DateTime.now())) {
            throw CertificateExpiredException;
          }

          return false;
        };
        return client;
      },
    );

    // Get timeout value from settings
    final timeout = di.sl<Settings>().getServerTimeout();

    Response response;
    try {
      response = await dio
          .getUri(
            uri,
            options: Options(
              headers: headers,
            ),
          )
          .timeout(Duration(seconds: timeoutOverride ?? timeout));

      // If new cert was trusted update the stored custom cert hash list.
      // Has to be after the dio call in order to trigger the
      // badCertificateCallback.
      if (trustCert) {
        await di.sl<Settings>().setCustomCertHashList(customCertHashList);
      }
    } catch (e) {
      if (e.toString().contains('CERTIFICATE_VERIFY_FAILED')) {
        throw CertificateVerificationException;
      }

      rethrow;
    }

    // If status code is not 200 either:
    // Throw ServerVersionException if the message indicates a version issue
    // Throw a ServerException for all other cases
    if (response.statusCode != 200) {
      RegExp badServerVersion = RegExp(
        r'^Device registration failed: Tautulli version v\d.\d.\d does not meet the minimum requirement of v\d.\d.\d.',
      );

      if (response.data['response']['message'] != null &&
          badServerVersion.hasMatch(response.data['response']['message'])) {
        throw ServerVersionException();
      }

      throw ServerException();
    }

    // If the response result is not success throw BadApiResponseException.
    if (response.data['response']['result'] != 'success') {
      throw BadApiResponseException();
    }

    // Return parsed JSON
    return Right(response.data);
  }
}
