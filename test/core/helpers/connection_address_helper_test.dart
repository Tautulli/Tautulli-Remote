import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote_tdd/core/helpers/connection_address_helper.dart';

void main() {
  ConnectionAddressHelperImpl connectionAddressHelper;

  setUp(() {
    connectionAddressHelper = ConnectionAddressHelperImpl();
  });

  test(
    'should return a Map with keys [protocol, domain, user, password]',
    () async {
      // arrange
      final connectionAddress =
          'https://user:password@www.domain.com:80/example';
      // act
      final result = connectionAddressHelper.parse(connectionAddress);
      // assert
      expect(result.containsKey('protocol'), true);
      expect(result.containsKey('domain'), true);
      expect(result.containsKey('user'), true);
      expect(result.containsKey('password'), true);
    },
  );

  test(
    'should return a map with the correct value for the protocol key',
    () async {
      // arrange
      final connectionAddress =
          'https://user:password@www.domain.com:80/example';
      // act
      final result = connectionAddressHelper.parse(connectionAddress);
      // assert
      expect(result['protocol'], equals('https'));
    },
  );

  test(
    'should return a map with the correct value for the domain key',
    () async {
      // arrange
      final connectionAddress =
          'https://user:password@www.domain.com:80/example';
      // act
      final result = connectionAddressHelper.parse(connectionAddress);
      // assert
      expect(result['domain'], equals('www.domain.com:80/example'));
    },
  );

  test(
    'should return a map with the correct value for the user key',
    () async {
      // arrange
      final connectionAddress =
          'https://user:password@www.domain.com:80/example';
      // act
      final result = connectionAddressHelper.parse(connectionAddress);
      // assert
      expect(result['user'], equals('user'));
    },
  );

  test(
    'should return a map with the correct value for the password key',
    () async {
      // arrange
      final connectionAddress =
          'https://user:password@www.domain.com:80/example';
      // act
      final result = connectionAddressHelper.parse(connectionAddress);
      // assert
      expect(result['password'], equals('password'));
    },
  );
}
