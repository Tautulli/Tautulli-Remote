part of 'geo_ip_bloc.dart';

abstract class GeoIpEvent extends Equatable {
  const GeoIpEvent();

  @override
  List<Object> get props => [];
}

class GeoIpFetched extends GeoIpEvent {
  final ServerModel server;
  final String ipAddress;
  final SettingsBloc settingsBloc;

  const GeoIpFetched({
    required this.server,
    required this.ipAddress,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [server, ipAddress, settingsBloc];
}
