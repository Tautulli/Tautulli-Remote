import '../../../../core/types/types.dart';
import '../../domain/entities/connection_address.dart';

class ConnectionAddressModel extends ConnectionAddress {
  const ConnectionAddressModel({
    required bool primary,
    String? address,
    Protocol? protocol,
    String? domain,
    String? path,
  }) : super(
          primary: primary,
          address: address,
          protocol: protocol,
          domain: domain,
          path: path,
        );

  factory ConnectionAddressModel.fromConnectionAddress({
    required bool primary,
    required String connectionAddress,
  }) {
    Protocol? protocol;
    String? domain;
    String? path;

    RegExp exp = RegExp(r"(http[s]?):\/\/([\S][^\/]+)([\S]*)");
    Iterable<Match> matches = exp.allMatches(connectionAddress);

    for (var m in matches) {
      if (m.group(1)! == 'http') {
        protocol = Protocol.http;
      } else if (m.group(1)! == 'https') {
        protocol = Protocol.https;
      }

      domain = m.group(2)!;
      path = m.group(3);
    }

    return ConnectionAddressModel(
      primary: primary,
      address: connectionAddress,
      protocol: protocol,
      domain: domain,
      path: path,
    );
  }
}
