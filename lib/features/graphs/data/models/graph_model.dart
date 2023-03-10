import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/graph_type.dart';
import 'graph_data_model.dart';

class GraphModel extends Equatable {
  final GraphType graphType;
  final BlocStatus status;
  final GraphDataModel? graphDataModel;
  final Failure? failure;
  final String? failureMessage;
  final String? failureSuggestion;

  const GraphModel({
    required this.graphType,
    required this.status,
    this.graphDataModel,
    this.failure,
    this.failureMessage,
    this.failureSuggestion,
  });

  GraphModel copyWith({
    GraphType? graphType,
    BlocStatus? status,
    GraphDataModel? graphDataModel,
    Failure? failure,
    String? failureMessage,
    String? failureSuggestion,
  }) {
    return GraphModel(
      graphType: graphType ?? this.graphType,
      status: status ?? this.status,
      graphDataModel: graphDataModel ?? this.graphDataModel,
      failure: failure ?? this.failure,
      failureMessage: failureMessage ?? this.failureMessage,
      failureSuggestion: failureSuggestion ?? this.failureSuggestion,
    );
  }

  @override
  List<Object?> get props => [graphType, status];
}
