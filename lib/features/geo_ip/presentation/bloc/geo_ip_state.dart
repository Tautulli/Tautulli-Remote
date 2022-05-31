part of 'geo_ip_bloc.dart';

class GeoIpState extends Equatable {
  final BlocStatus status;
  final Map<String, GeoIpModel> geoIpMap;

  const GeoIpState({
    this.status = BlocStatus.initial,
    required this.geoIpMap,
  });

  GeoIpState copyWith({
    BlocStatus? status,
    Map<String, GeoIpModel>? geoIpMap,
  }) {
    return GeoIpState(
      status: status ?? this.status,
      geoIpMap: geoIpMap ?? this.geoIpMap,
    );
  }

  @override
  List<Object> get props => [status, geoIpMap];
}
