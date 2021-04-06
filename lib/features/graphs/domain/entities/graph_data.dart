import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'series_data.dart';

enum GraphType {
  playsByDate,
}

class GraphData extends Equatable {
  final GraphType graphType;
  final List<String> categories;
  final List<SeriesData> seriesDataList;

  GraphData({
    @required this.graphType,
    @required this.categories,
    @required this.seriesDataList,
  });

  @override
  List<Object> get props => [graphType, categories, seriesDataList];
}
