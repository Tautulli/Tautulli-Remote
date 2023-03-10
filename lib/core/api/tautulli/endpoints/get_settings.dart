import 'package:dartz/dartz.dart';

import '../connection_handler.dart';

abstract class GetSettings {
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
  });
}

class GetSettingsImpl implements GetSettings {
  final ConnectionHandler connectionHandler;

  GetSettingsImpl(this.connectionHandler);

  @override
  Future<Tuple2<dynamic, bool>> call({
    required String tautulliId,
  }) {
    final response = connectionHandler(
      tautulliId: tautulliId,
      cmd: 'get_settings',
      params: {},
    );

    return response;
  }
}
