import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/core/helpers/connection_address_helper.dart';

void main() {
  test(
    'should return a Map with keys [protocol, domain, path]',
    () async {
      // arrange
      const connectionAddress =
          'https://user:password@www.domain.com:80/example';
      // act
      final result = ConnectionAddressHelper.parse(connectionAddress);
      // assert
      expect(result.containsKey('protocol'), true);
      expect(result.containsKey('domain'), true);
      expect(result.containsKey('path'), true);
    },
  );

  test(
    'should return a map with the correct value for the protocol key',
    () async {
      // arrange
      const connectionAddress =
          'https://user:password@www.domain.com:80/example';
      // act
      final result = ConnectionAddressHelper.parse(connectionAddress);
      // assert
      expect(result['protocol'], equals('https'));
    },
  );

  test(
    'should return a map with the correct value for the domain key',
    () async {
      // arrange
      const connectionAddress =
          'https://user:password@www.domain.com:80/example';
      // act
      final result = ConnectionAddressHelper.parse(connectionAddress);
      // assert
      expect(result['domain'], equals('user:password@www.domain.com:80'));
    },
  );

  test(
    'should return a map with the correct value for the path key',
    () async {
      // arrange
      const connectionAddress =
          'https://user:password@www.domain.com:80/example';
      // act
      final result = ConnectionAddressHelper.parse(connectionAddress);
      // assert
      expect(result['path'], equals('/example'));
    },
  );
}
