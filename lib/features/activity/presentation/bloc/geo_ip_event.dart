part of 'geo_ip_bloc.dart';

abstract class GeoIpEvent extends Equatable {
  const GeoIpEvent();

  @override
  List<Object> get props => [];
}

class GeoIpLoad extends GeoIpEvent {
  final String tautulliId;
  final String ipAddress;

  GeoIpLoad({
    @required this.tautulliId,
    @required this.ipAddress
  });

  @override
  List<Object> get props => [tautulliId, ipAddress];
}
