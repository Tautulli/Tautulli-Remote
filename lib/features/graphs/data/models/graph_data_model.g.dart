// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphDataModel _$GraphDataModelFromJson(Map<String, dynamic> json) =>
    GraphDataModel(
      categories: GraphDataModel.stringListfromList(json['categories'] as List),
      seriesDataList: GraphDataModel.graphSeriesDataModelFromJsonList(
          json['series'] as List),
    );

Map<String, dynamic> _$GraphDataModelToJson(GraphDataModel instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'series': instance.seriesDataList,
    };
