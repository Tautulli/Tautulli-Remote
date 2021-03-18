part of 'geo_ip_bloc.dart';

abstract class GeoIpEvent extends Equatable {
  const GeoIpEvent();

  @override
  List<Object> get props => [];
}

class GeoIpLoad extends GeoIpEvent {
  final String tautulliId;
  final String ipAddress;
  final SettingsBloc settingsBloc;

  GeoIpLoad({
    @required this.tautulliId,
    @required this.ipAddress,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, ipAddress, settingsBloc];
}
