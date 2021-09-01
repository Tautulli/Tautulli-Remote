// @dart=2.9

import 'package:meta/meta.dart';

import '../../domain/entities/graph_data.dart';
import '../../domain/entities/series_data.dart';

class GraphDataModel extends GraphData {
  GraphDataModel({
    @required final List<String> categories,
    @required final List<SeriesData> seriesDataList,
  }) : super(
          categories: categories,
          seriesDataList: seriesDataList,
        );
}
