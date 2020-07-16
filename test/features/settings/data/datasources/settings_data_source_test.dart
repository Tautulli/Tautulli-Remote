import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautulli_remote_tdd/core/helpers/connection_address_helper.dart';
import 'package:tautulli_remote_tdd/features/settings/data/datasources/settings_data_source.dart';
import 'package:matcher/matcher.dart';
import 'package:tautulli_remote_tdd/features/settings/data/models/settings_model.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/entities/settings.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockConnectionAddressHelper extends Mock
    implements ConnectionAddressHelper {}

void main() {
  SettingsDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  MockConnectionAddressHelper mockConnectionAddressHelper;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockConnectionAddressHelper = MockConnectionAddressHelper();
    dataSource = SettingsDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
      connectionAddressHelper: mockConnectionAddressHelper,
    );
  });

  final String tConnectionAddress = 'http://tautulli.com';
  final String tConnectionAddressWithBasicAuth =
      'http://user:pass@tautulli.com';
  final String tConnectionProtocol = 'http';
  final String tConnectionDomain = 'tautulli.com';
  final String tConnectionUser = 'user';
  final String tConnectionPassword = 'pass';
  final String tDeviceToken = 'abc';

  final Settings tSettingsModel = SettingsModel(
    connectionAddress: tConnectionAddress,
    connectionProtocol: tConnectionProtocol,
    connectionDomain: tConnectionDomain,
    connectionUser: null,
    connectionPassword: null,
    deviceToken: tDeviceToken,
  );

  final Settings tSettingsModelWithBasicAuth = SettingsModel(
    connectionAddress: tConnectionAddressWithBasicAuth,
    connectionProtocol: tConnectionProtocol,
    connectionDomain: tConnectionDomain,
    connectionUser: tConnectionUser,
    connectionPassword: tConnectionPassword,
    deviceToken: tDeviceToken,
  );

  final Map<String, String> parsedConnectionAddressWithBasicAuth = {
    'protocol': tConnectionProtocol,
    'domain': tConnectionDomain,
    'user': tConnectionUser,
    'password': tConnectionPassword,
  };

  group('Get settings', () {
    group('getConnectionAddress', () {
      test(
        'should return connectionAddress from settings when one is stored',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn('tautulli.com');
          // act
          final connectionAddress = await dataSource.getConnectionAddress();
          // assert
          verify(mockSharedPreferences.getString(SETTINGS_CONNECTION_ADDRESS));
          expect(connectionAddress, equals('tautulli.com'));
        },
      );

      test(
        'should return null when there is no stored value',
        () async {
          // arrange
          when(mockSharedPreferences.getString(SETTINGS_CONNECTION_ADDRESS))
              .thenReturn(null);
          // act
          final result = await dataSource.getConnectionAddress();
          // assert
          expect(result, equals(null));
        },
      );
    });

    group('getConnectionProtocol', () {
      test(
        'should return connectionProtocol from settings when one is stored',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn('http');
          // act
          final connectionAddress = await dataSource.getConnectionProtocol();
          // assert
          verify(mockSharedPreferences.getString(SETTINGS_CONNECTION_PROTOCOL));
          expect(connectionAddress, equals('http'));
        },
      );

      test(
        'should return null when there is no stored value',
        () async {
          // arrange
          when(mockSharedPreferences.getString(SETTINGS_CONNECTION_ADDRESS))
              .thenReturn(null);
          // act
          final result = await dataSource.getConnectionProtocol();
          // assert
          expect(result, equals(null));
        },
      );
    });

    group('getConnectionDomain', () {
      test(
        'should return domain from settings when one is stored',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn('tautulli.com');
          // act
          final connectionAddress = await dataSource.getConnectionDomain();
          // assert
          verify(mockSharedPreferences.getString(SETTINGS_CONNECTION_DOMAIN));
          expect(connectionAddress, equals('tautulli.com'));
        },
      );

      test(
        'should return null when there is no stored value',
        () async {
          // arrange
          when(mockSharedPreferences.getString(SETTINGS_CONNECTION_DOMAIN))
              .thenReturn(null);
          // act
          final result = await dataSource.getConnectionDomain();
          // assert
          expect(result, equals(null));
        },
      );
    });

    group('getConnectionUser', () {
      test(
        'should return user from settings when one is stored',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn('user');
          // act
          final connectionAddress = await dataSource.getConnectionUser();
          // assert
          verify(mockSharedPreferences.getString(SETTINGS_CONNECTION_USER));
          expect(connectionAddress, equals('user'));
        },
      );

      test(
        'should return null when there is no stored value',
        () async {
          // arrange
          when(mockSharedPreferences.getString(SETTINGS_CONNECTION_USER))
              .thenReturn(null);
          // act
          final result = await dataSource.getConnectionUser();
          // assert
          expect(result, equals(null));
        },
      );
    });

    group('getConnectionPassword', () {
      test(
        'should return domain from settings when one is stored',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn('pass');
          // act
          final connectionAddress = await dataSource.getConnectionPassword();
          // assert
          verify(mockSharedPreferences.getString(SETTINGS_CONNECTION_PASSWORD));
          expect(connectionAddress, equals('pass'));
        },
      );

      test(
        'should return null when there is no stored value',
        () async {
          // arrange
          when(mockSharedPreferences.getString(SETTINGS_CONNECTION_PASSWORD))
              .thenReturn(null);
          // act
          final result = await dataSource.getConnectionPassword();
          // assert
          expect(result, equals(null));
        },
      );
    });

    group('getApiKey', () {
      test(
        'should return Device Token from settings when one is stored',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn('abc');
          // act
          final deviceToken = await dataSource.getDeviceToken();
          // assert
          verify(mockSharedPreferences.getString(SETTINGS_DEVICE_TOKEN));
          expect(deviceToken, equals('abc'));
        },
      );

      test(
        'should return null when there is no stored value',
        () async {
          // arrange
          when(mockSharedPreferences.getString(SETTINGS_DEVICE_TOKEN))
              .thenReturn(null);
          // act
          final result = await dataSource.getConnectionAddress();
          // assert
          expect(result, equals(null));
        },
      );
    });

    group('load', () {
      group('without Basic Auth', () {
        test(
          'should return a SettingsModel with all saved settings',
          () async {
            // arrange
            when(mockSharedPreferences.getString(SETTINGS_CONNECTION_ADDRESS))
                .thenReturn('http://tautulli.com');
            when(mockSharedPreferences.getString(SETTINGS_CONNECTION_PROTOCOL))
                .thenReturn('http');
            when(mockSharedPreferences.getString(SETTINGS_CONNECTION_DOMAIN))
                .thenReturn('tautulli.com');
            when(mockSharedPreferences.getString(SETTINGS_CONNECTION_USER))
                .thenReturn(null);
            when(mockSharedPreferences.getString(SETTINGS_CONNECTION_PASSWORD))
                .thenReturn(null);
            when(mockSharedPreferences.getString(SETTINGS_DEVICE_TOKEN))
                .thenReturn('abc');
            // act
            final settings = await dataSource.load();
            // assert
            verify(dataSource.getConnectionAddress());
            verify(dataSource.getDeviceToken());
            expect(settings, equals(tSettingsModel));
          },
        );
      });

      group('with Basic Auth', () {
        test(
          'should return a SettingsModel with all saved settings',
          () async {
            // arrange
            when(mockSharedPreferences.getString(SETTINGS_CONNECTION_ADDRESS))
                .thenReturn('http://user:pass@tautulli.com');
            when(mockSharedPreferences.getString(SETTINGS_CONNECTION_PROTOCOL))
                .thenReturn('http');
            when(mockSharedPreferences.getString(SETTINGS_CONNECTION_DOMAIN))
                .thenReturn('tautulli.com');
            when(mockSharedPreferences.getString(SETTINGS_CONNECTION_USER))
                .thenReturn('user');
            when(mockSharedPreferences.getString(SETTINGS_CONNECTION_PASSWORD))
                .thenReturn('pass');
            when(mockSharedPreferences.getString(SETTINGS_DEVICE_TOKEN))
                .thenReturn('abc');
            // act
            final settings = await dataSource.load();
            // assert
            verify(dataSource.getConnectionAddress());
            verify(dataSource.getDeviceToken());
            expect(settings, equals(tSettingsModelWithBasicAuth));
          },
        );
      });
    });
  });

  group('Set settings', () {
    group('connectionAddress', () {
      test(
        'should call SharedPreferences to save the connectionAddress',
        () async {
          // act
          await dataSource.setConnectionAddress(tConnectionAddress);
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_ADDRESS, tConnectionAddress));
        },
      );

      test(
        'should remove leading and trailing whitespace from the connectionAddress value when saving',
        () async {
          // act
          await dataSource.setConnectionAddress(' tautulli.com ');
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_ADDRESS, 'tautulli.com'));
        },
      );
    });

    group('connectionProtocol', () {
      test(
        'should call SharedPreferences to save the connectionProtocol',
        () async {
          // act
          await dataSource.setConnectionProtocol(tConnectionProtocol);
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_PROTOCOL, tConnectionProtocol));
        },
      );

      test(
        'should remove leading and trailing whitespace from the connectionProtocol value when saving',
        () async {
          // act
          await dataSource.setConnectionProtocol(' http ');
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_PROTOCOL, 'http'));
        },
      );
    });

    group('connectionDomain', () {
      test(
        'should call SharedPreferences to save the connectionDomain',
        () async {
          // act
          await dataSource.setConnectionDomain(tConnectionDomain);
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_DOMAIN, tConnectionDomain));
        },
      );

      test(
        'should remove leading and trailing whitespace from the connectionDomain value when saving',
        () async {
          // act
          await dataSource.setConnectionDomain(' tautulli.com ');
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_DOMAIN, 'tautulli.com'));
        },
      );
    });

    group('connectionUser', () {
      test(
        'should call SharedPreferences to save the connectionUser',
        () async {
          // act
          await dataSource.setConnectionUser(tConnectionUser);
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_USER, tConnectionUser));
        },
      );

      test(
        'should remove leading and trailing whitespace from the connectionUser value when saving',
        () async {
          // act
          await dataSource.setConnectionUser(' user ');
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_USER, 'user'));
        },
      );
    });

    group('connectionPassword', () {
      test(
        'should call SharedPreferences to save the connectionPassword',
        () async {
          // act
          await dataSource.setConnectionPassword(tConnectionPassword);
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_PASSWORD, tConnectionPassword));
        },
      );

      test(
        'should remove leading and trailing whitespace from the connectionPassword value when saving',
        () async {
          // act
          await dataSource.setConnectionPassword(' pass ');
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_PASSWORD, 'pass'));
        },
      );
    });

    group('deviceToken', () {
      test(
        'should call SharedPreferences to save the deviceToken',
        () async {
          // act
          await dataSource.setDeviceToken(tDeviceToken);
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_DEVICE_TOKEN, tDeviceToken));
        },
      );

      test(
        'should remove leading and trailing whitespace from the deviceToken value when saving',
        () async {
          // act
          await dataSource.setDeviceToken(' abc ');
          // assert
          verify(mockSharedPreferences.setString(SETTINGS_DEVICE_TOKEN, 'abc'));
        },
      );
    });

    group('setConnection', () {
      test(
        'should split apart the connectionAddress',
        () async {
          // arrange
          when(mockConnectionAddressHelper
                  .parse(tConnectionAddressWithBasicAuth))
              .thenAnswer((_) => parsedConnectionAddressWithBasicAuth);
          // act
          await dataSource.setConnection(tConnectionAddressWithBasicAuth);
          // assert
          verify(mockConnectionAddressHelper
              .parse(tConnectionAddressWithBasicAuth));
        },
      );

      test(
        'should save all the connection settings',
        () async {
          // arrange
          when(mockConnectionAddressHelper
                  .parse(tConnectionAddressWithBasicAuth))
              .thenAnswer((_) => parsedConnectionAddressWithBasicAuth);
          // act
          await dataSource.setConnection(tConnectionAddressWithBasicAuth);
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_ADDRESS, tConnectionAddressWithBasicAuth));
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_PROTOCOL, tConnectionProtocol));
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_DOMAIN, tConnectionDomain));
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_USER, tConnectionUser));
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_PASSWORD, tConnectionPassword));
        },
      );
    });

    group('save', () {
      test(
        'should take in a SettingsModel and call SharedPreferences to save all the settings',
        () async {
          // arrange
          when(mockConnectionAddressHelper
                  .parse(tConnectionAddressWithBasicAuth))
              .thenAnswer((_) => parsedConnectionAddressWithBasicAuth);
          // act
          await dataSource.save(tSettingsModelWithBasicAuth);
          // assert
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_ADDRESS, tConnectionAddressWithBasicAuth));
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_PROTOCOL, tConnectionProtocol));
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_DOMAIN, tConnectionDomain));
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_USER, tConnectionUser));
          verify(mockSharedPreferences.setString(
              SETTINGS_CONNECTION_PASSWORD, tConnectionPassword));
          verify(mockSharedPreferences.setString(
              SETTINGS_DEVICE_TOKEN, tDeviceToken));
        },
      );
    });
  });
}
