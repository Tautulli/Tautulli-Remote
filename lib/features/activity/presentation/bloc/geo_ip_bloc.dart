// @dart=2.9

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../domain/entities/geo_ip.dart';
import '../../domain/usecases/get_geo_ip.dart';

part 'geo_ip_event.dart';
part 'geo_ip_state.dart';

Map<String, GeoIpItem> _geoIpMapCache = {};

class GeoIpBloc extends Bloc<GeoIpEvent, GeoIpState> {
  final GetGeoIp getGeoIp;
  final Logging logging;

  GeoIpBloc({
    @required this.getGeoIp,
    @required this.logging,
  }) : super(GeoIpInitial());

  @override
  Stream<GeoIpState> mapEventToState(
    GeoIpEvent event,
  ) async* {
    if (event is GeoIpLoad) {
      yield* _mapGeoIpLoadToState(
        tautulliId: event.tautulliId,
        ipAddress: event.ipAddress,
        geoIpMap: _geoIpMapCache,
        settingsBloc: event.settingsBloc,
      );
    }
  }

  Stream<GeoIpState> _mapGeoIpLoadToState({
    @required String tautulliId,
    @required String ipAddress,
    @required Map<String, GeoIpItem> geoIpMap,
    @required SettingsBloc settingsBloc,
  }) async* {
    // If the IP Address has already been looked up don't look it up again
    if (geoIpMap.containsKey(ipAddress)) {
      yield GeoIpSuccess(geoIpMap: geoIpMap);
    } else {
      yield GeoIpInProgress();

      final failureOrGeoIp = await getGeoIp(
        tautulliId: tautulliId,
        ipAddress: ipAddress,
        settingsBloc: settingsBloc,
      );

      yield* failureOrGeoIp.fold(
        (failure) async* {
          logging.error('GeoIP: Failed to load GeoIP data for $ipAddress');

          yield GeoIpFailure(geoIpMap: geoIpMap);
        },
        (geoIpItem) async* {
          geoIpMap[ipAddress] = geoIpItem;

          yield GeoIpSuccess(geoIpMap: geoIpMap);
        },
      );
    }
  }
}

void clearCache() {
  _geoIpMapCache = {};
}
