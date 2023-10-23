// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_series_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphSeriesDataModel _$GraphSeriesDataModelFromJson(
        Map<String, dynamic> json) =>
    GraphSeriesDataModel(
      seriesType: Cast.castStringToGraphSeriesType(json['name'] as String),
      seriesData: json['data'] as List<dynamic>,
    );

Map<String, dynamic> _$GraphSeriesDataModelToJson(
        GraphSeriesDataModel instance) =>
    <String, dynamic>{
      'name': _$GraphSeriesTypeEnumMap[instance.seriesType]!,
      'data': instance.seriesData,
    };

const _$GraphSeriesTypeEnumMap = {
  GraphSeriesType.tv: 'tv',
  GraphSeriesType.movies: 'movies',
  GraphSeriesType.music: 'music',
  GraphSeriesType.live: 'live',
  GraphSeriesType.directPlay: 'directPlay',
  GraphSeriesType.directStream: 'directStream',
  GraphSeriesType.transcode: 'transcode',
  GraphSeriesType.concurrent: 'concurrent',
  GraphSeriesType.unknown: 'unknown',
};
