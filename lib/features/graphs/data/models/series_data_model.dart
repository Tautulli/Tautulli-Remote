// @dart=2.9

import 'package:meta/meta.dart';

import '../../domain/entities/series_data.dart';

class SeriesDataModel extends SeriesData {
  SeriesDataModel({
    @required final SeriesType seriesType,
    @required final List seriesData,
  }) : super(
          seriesType: seriesType,
          seriesData: seriesData,
        );

  factory SeriesDataModel.fromJson(Map<String, dynamic> json) {
    SeriesType type;
    switch (json['name'].toLowerCase()) {
      case ('tv'):
        type = SeriesType.tv;
        break;
      case ('movies'):
        type = SeriesType.movies;
        break;
      case ('music'):
        type = SeriesType.music;
        break;
      case ('live tv'):
        type = SeriesType.live;
        break;
      case ('direct play'):
        type = SeriesType.direct_play;
        break;
      case ('direct stream'):
        type = SeriesType.direct_stream;
        break;
      case ('transcode'):
        type = SeriesType.transcode;
        break;
    }

    return SeriesDataModel(
      seriesType: type,
      seriesData: json['data'],
    );
  }
}
