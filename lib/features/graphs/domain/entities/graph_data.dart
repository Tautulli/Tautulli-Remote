// @dart=2.9

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'series_data.dart';

class GraphData extends Equatable {
  final List<String> categories;
  final List<SeriesData> seriesDataList;

  GraphData({
    @required this.categories,
    @required this.seriesDataList,
  });

  @override
  List<Object> get props => [categories, seriesDataList];
}
