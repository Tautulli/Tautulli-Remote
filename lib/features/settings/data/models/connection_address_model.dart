import 'package:equatable/equatable.dart';
import 'package:quiver/strings.dart';

import '../../../../core/types/tautulli_types.dart';

class ConnectionAddressModel extends Equatable {
  final bool primary;
  final String? address;
  final Protocol? protocol;
  final String? domain;
  final String? path;

  const ConnectionAddressModel({
    required this.primary,
    this.address,
    this.protocol,
    this.domain,
    this.path,
  });

  factory ConnectionAddressModel.fromConnectionAddress({
    required bool primary,
    required String connectionAddress,
  }) {
    Protocol? protocol;
    String domain = '';
    String path = '';

    if (isNotEmpty(connectionAddress)) {
      RegExp exp = RegExp(r"(http[s]?):\/\/([\S][^\/]+)([\S]*)");
      Iterable<Match> matches = exp.allMatches(connectionAddress);

      for (var m in matches) {
        if (m.group(1)! == 'http') {
          protocol = Protocol.http;
        } else if (m.group(1)! == 'https') {
          protocol = Protocol.https;
        }

        domain = m.group(2) ?? '';
        path = m.group(3) ?? '';
      }
    }

    return ConnectionAddressModel(
      primary: primary,
      address: connectionAddress,
      protocol: protocol,
      domain: domain,
      path: path,
    );
  }

  @override
  List<Object> get props => [];
}
