import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum SeriesType {
  tv,
  movies,
  music,
  live,
  direct_play,
  direct_stream,
  transcode,
}

class SeriesData extends Equatable {
  final SeriesType seriesType;
  final List seriesData;

  SeriesData({
    @required this.seriesType,
    @required this.seriesData,
  });

  @override
  List<Object> get props => [seriesType, seriesData];
}
