// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/error/failure.dart';
import '../repositories/register_device_repository.dart';

class RegisterDevice {
  final RegisterDeviceRepository repository;

  RegisterDevice({@required this.repository});

  Future<Either<Failure, Map>> call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    bool clearOnesignalId,
    List<CustomHeaderModel> headers,
    bool trustCert,
  }) async {
    return await repository(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
      headers: headers,
      trustCert: trustCert,
    );
  }
}
