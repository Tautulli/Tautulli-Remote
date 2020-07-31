import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

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
  }) async {
    return await repository(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
      clearOnesignalId: clearOnesignalId,
    );
  }
}
