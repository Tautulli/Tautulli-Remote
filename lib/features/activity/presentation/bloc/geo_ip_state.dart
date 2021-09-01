// @dart=2.9

part of 'geo_ip_bloc.dart';

abstract class GeoIpState extends Equatable {
  const GeoIpState();

  @override
  List<Object> get props => [];
}

class GeoIpInitial extends GeoIpState {}

class GeoIpInProgress extends GeoIpState {}

class GeoIpSuccess extends GeoIpState {
  final Map<String, GeoIpItem> geoIpMap;

  GeoIpSuccess({
    @required this.geoIpMap,
  });

  @override
  List<Object> get props => [geoIpMap];
}

class GeoIpFailure extends GeoIpState {
  final Map<String, GeoIpItem> geoIpMap;

  GeoIpFailure({
    @required this.geoIpMap,
  });

  @override
  List<Object> get props => [geoIpMap];
}
