import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'graph_series_data_model.dart';

part 'graph_data_model.g.dart';

@JsonSerializable()
class GraphDataModel extends Equatable {
  @JsonKey(name: 'categories', fromJson: stringListfromList)
  final List<String> categories;
  @JsonKey(name: 'series', fromJson: graphSeriesDataModelFromJsonList)
  final List<GraphSeriesDataModel> seriesDataList;

  const GraphDataModel({
    required this.categories,
    required this.seriesDataList,
  });

  GraphDataModel copyWith({
    List<String>? categories,
    List<GraphSeriesDataModel>? seriesDataList,
  }) {
    return GraphDataModel(
      categories: categories ?? this.categories,
      seriesDataList: seriesDataList ?? this.seriesDataList,
    );
  }

  factory GraphDataModel.fromJson(Map<String, dynamic> json) =>
      _$GraphDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$GraphDataModelToJson(this);

  static List<String> stringListfromList(List list) {
    return list.map((item) => item.toString()).toList();
  }

  static List<GraphSeriesDataModel> graphSeriesDataModelFromJsonList(
    List list,
  ) {
    return list.map((series) => GraphSeriesDataModel.fromJson(series)).toList();
  }

  @override
  List<Object?> get props => [categories, seriesDataList];
}
