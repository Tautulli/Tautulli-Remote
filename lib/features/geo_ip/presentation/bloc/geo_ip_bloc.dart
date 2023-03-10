import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/geo_ip_model.dart';
import '../../domain/usecases/geo_ip.dart';

part 'geo_ip_event.dart';
part 'geo_ip_state.dart';

Map<String, GeoIpModel> geoIpMapCache = {};

class GeoIpBloc extends Bloc<GeoIpEvent, GeoIpState> {
  final GeoIp geoIp;
  final Logging logging;

  GeoIpBloc({
    required this.geoIp,
    required this.logging,
  }) : super(
          GeoIpState(geoIpMap: geoIpMapCache),
        ) {
    on<GeoIpFetched>(_onGeoIpFetched);
  }

  void _onGeoIpFetched(
    GeoIpFetched event,
    Emitter<GeoIpState> emit,
  ) async {
    if (geoIpMapCache.keys.contains(event.ipAddress)) return;

    emit(
      state.copyWith(status: BlocStatus.initial),
    );

    final failureOrGeoIp = await geoIp.lookup(
      tautulliId: event.server.tautulliId,
      ipAddress: event.ipAddress,
    );

    failureOrGeoIp.fold(
      (failure) {
        logging.error('GeoIP :: Failed to lookup ${event.ipAddress} [$failure]');

        return emit(
          state.copyWith(status: BlocStatus.failure),
        );
      },
      (geoIp) {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: geoIp.value2,
          ),
        );

        geoIpMapCache[event.ipAddress] = geoIp.value1;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            geoIpMap: geoIpMapCache,
          ),
        );
      },
    );
  }
}
