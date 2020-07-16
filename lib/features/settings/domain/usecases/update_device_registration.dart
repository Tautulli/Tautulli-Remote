import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../repositories/register_device_repository.dart';
import 'get_settings.dart';

class UpdateDeviceRegistration {
  final RegisterDeviceRepository repository;
  final GetSettings getSettings;

  UpdateDeviceRegistration({
    @required this.repository,
    @required this.getSettings,
  });

  Future<Either<Failure, bool>> call({
    final bool clearOnesignalId,
  }) async {
    final settings = await getSettings.load();

    return await repository(
      connectionProtocol: settings.connectionProtocol,
      connectionDomain: settings.connectionDomain,
      connectionUser: settings.connectionUser,
      connectionPassword: settings.connectionPassword,
      deviceToken: settings.deviceToken,
      clearOnesignalId: clearOnesignalId,
    );
  }
}
