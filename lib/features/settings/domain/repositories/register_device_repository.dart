import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';

abstract class RegisterDeviceRepository {
  Future<Either<Failure, bool>> call({
    @required final String connectionProtocol,
    @required final String connectionDomain,
    @required final String connectionUser,
    @required final String connectionPassword,
    @required final String deviceToken,
    final bool clearOnesignalId,
  });
}