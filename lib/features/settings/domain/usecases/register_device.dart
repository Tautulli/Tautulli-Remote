import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../repositories/register_device_repository.dart';

class RegisterDevice {
  final RegisterDeviceRepository repository;

  RegisterDevice({@required this.repository});

  Future<Either<Failure, bool>> call({
    @required final String connectionProtocol,
    @required final String connectionDomain,
    @required final String connectionUser,
    @required final String connectionPassword,
    @required final String deviceToken,
    final bool clearOnesignalId,
  }) async {
    return await repository(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionUser: connectionUser,
      connectionPassword: connectionPassword,
      deviceToken: deviceToken,
      clearOnesignalId: clearOnesignalId,
    );
  }
}
