import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote_tdd/core/helpers/tautulli_api_url_helper.dart';
import 'package:tautulli_remote_tdd/core/error/exception.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/settings.dart';

class MockSettings extends Mock implements Settings {}

void main() {
  TautulliApiUrlsImpl tautulliApiUrls;
  MockSettings mockSettings;

  setUp(() {
    mockSettings = MockSettings();
    tautulliApiUrls = TautulliApiUrlsImpl(settings: mockSettings);
  });

  test(
    'getActivityUrl should throw a SettingsException when the Protocol, Domain, or Device Token is null',
    () async {
      // act
      final call = tautulliApiUrls.getActivityUrl;
      // assert
      expect(() => call(protocol: null, domain: null, deviceToken: null),
          throwsA(TypeMatcher<SettingsException>()));
    },
  );

  test(
    'getActivityUrl should return a URL string when the Protocol, Domain, and Device Token are set',
    () async {
      // act
      final result = tautulliApiUrls.getActivityUrl(
        protocol: 'http',
        domain: 'tautulli.com',
        deviceToken: 'abc',
      );
      // assert
      expect(result, isA<String>());
    },
  );

  test(
    'pmsImageProxyUrl should throw a SettingsException when the Protocol, Domain, or Device Token is null',
    () async {
      // act
      final call = tautulliApiUrls.pmsImageProxyUrl;
      // assert
      expect(() => call(protocol: null, domain: null, deviceToken: null),
          throwsA(TypeMatcher<SettingsException>()));
    },
  );

  test(
    'pmsImageProxyUrl should return a URL string when the Protocol, Domain, and Device Token are set',
    () async {
      // act
      final result = tautulliApiUrls.pmsImageProxyUrl(
        protocol: 'http',
        domain: 'tautulli.com',
        deviceToken: 'abc',
      );
      // assert
      expect(result, isA<String>());
    },
  );

  test(
    'getGeoIpLookupUrl should throw a SettingsException when the Protocol, Domain, or Device Token is null',
    () async {
      // act
      final call = tautulliApiUrls.getGeoIpLookupUrl;
      // assert
      expect(
          () => call(
                protocol: null,
                domain: null,
                deviceToken: null,
                ipAddress: "10.0.0.1",
              ),
          throwsA(TypeMatcher<SettingsException>()));
    },
  );

  test(
    'getGeoIpLookupUrl should return a URL string when the Protocol, Domain, and Device Token are set',
    () async {
      // act
      final result = tautulliApiUrls.getGeoIpLookupUrl(
        protocol: 'http',
        domain: 'tautulli.com',
        deviceToken: 'abc',
        ipAddress: '10.0.0.1',
      );
      // assert
      expect(result, isA<String>());
    },
  );

  test(
    'terminateSessionUrl should throw a SettingsException when the Protocol, Domain, or Device Token is null',
    () async {
      // act
      final call = tautulliApiUrls.terminateSessionUrl;
      // assert
      expect(
          () => call(
                protocol: null,
                domain: null,
                deviceToken: null,
                sessionKey: 1,
              ),
          throwsA(TypeMatcher<SettingsException>()));
    },
  );

  test(
    'terminateSessionUrl should return a URL string when the Protocol, Domain, and Device Token are set',
    () async {
      // act
      final result = tautulliApiUrls.terminateSessionUrl(
        protocol: 'http',
        domain: 'tautulli.com',
        deviceToken: 'abc',
        sessionKey: 1,
      );
      // assert
      expect(result, isA<String>());
    },
  );

  test(
    'terminateSessionUrl should return a URL string containing the message when the message parameter is set',
    () async {
      // act
      final result = tautulliApiUrls.terminateSessionUrl(
          protocol: 'http',
          domain: 'tautulli.com',
          deviceToken: 'abc',
          sessionKey: 1,
          message: 'test message');
      // assert
      expect(result, contains('message=test message'));
    },
  );
}
