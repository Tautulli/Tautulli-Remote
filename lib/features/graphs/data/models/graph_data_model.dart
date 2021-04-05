import 'package:meta/meta.dart';

import '../../domain/entities/graph_data.dart';
import '../../domain/entities/series_data.dart';

class GraphDataModel extends GraphData {
  GraphDataModel({
    @required final GraphType graphType,
    @required final List<String> categories,
    @required final List<SeriesData> graphData,
  }) : super(
          graphType: graphType,
          categories: categories,
          graphData: graphData,
        );
}
