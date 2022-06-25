import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/types/tautulli_types.dart';
import '../../../../core/utilities/cast.dart';

part 'graph_series_data_model.g.dart';

@JsonSerializable()
class GraphSeriesDataModel extends Equatable {
  @JsonKey(name: 'name', fromJson: Cast.castStringToGraphSeriesType)
  final GraphSeriesType seriesType;
  @JsonKey(name: 'data')
  final List seriesData;

  const GraphSeriesDataModel({
    required this.seriesType,
    required this.seriesData,
  });

  factory GraphSeriesDataModel.fromJson(Map<String, dynamic> json) =>
      _$GraphSeriesDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$GraphSeriesDataModelToJson(this);

  @override
  List<Object?> get props => [seriesType, seriesData];
}
