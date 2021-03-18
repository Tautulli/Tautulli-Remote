import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/geo_ip.dart';
import '../repositories/geo_ip_repository.dart';

class GetGeoIp {
  final GeoIpRepository repository;

  GetGeoIp({@required this.repository});

  Future<Either<Failure, GeoIpItem>> call({
    @required String tautulliId,
    @required String ipAddress,
    @required SettingsBloc settingsBloc,
  }) async {
    return await repository.getGeoIp(
      tautulliId: tautulliId,
      ipAddress: ipAddress,
      settingsBloc: settingsBloc,
    );
  }
}
