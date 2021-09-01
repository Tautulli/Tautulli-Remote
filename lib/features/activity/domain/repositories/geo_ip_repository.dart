// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/geo_ip.dart';

abstract class GeoIpRepository {
  Future<Either<Failure, GeoIpItem>> getGeoIp({
    @required String tautulliId,
    @required String ipAddress,
    @required SettingsBloc settingsBloc,
  });
}
