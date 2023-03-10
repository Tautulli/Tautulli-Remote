import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/types/bloc_status.dart';
import 'activity_model.dart';

class ServerActivityModel extends Equatable {
  final int sortIndex;
  final String serverName;
  final String tautulliId;
  final BlocStatus status;
  final List<ActivityModel> activityList;
  final int copyCount;
  final int directPlayCount;
  final int transcodeCount;
  final int lanBandwidth;
  final int wanBandwidth;
  final Failure? failure;
  final String? failureMessage;
  final String? failureSuggestion;

  const ServerActivityModel({
    required this.sortIndex,
    required this.serverName,
    required this.tautulliId,
    required this.status,
    required this.activityList,
    required this.copyCount,
    required this.directPlayCount,
    required this.transcodeCount,
    required this.lanBandwidth,
    required this.wanBandwidth,
    this.failure,
    this.failureMessage,
    this.failureSuggestion,
  });

  ServerActivityModel copyWith({
    final int? sortIndex,
    final String? serverName,
    final String? tautulliId,
    final BlocStatus? status,
    final List<ActivityModel>? activityList,
    final int? copyCount,
    final int? directPlayCount,
    final int? transcodeCount,
    final int? lanBandwidth,
    final int? wanBandwidth,
    final Failure? failure,
    final String? failureMessage,
    final String? failureSuggestion,
  }) {
    return ServerActivityModel(
      sortIndex: sortIndex ?? this.sortIndex,
      serverName: serverName ?? this.serverName,
      tautulliId: tautulliId ?? this.tautulliId,
      status: status ?? this.status,
      activityList: activityList ?? this.activityList,
      copyCount: copyCount ?? this.copyCount,
      directPlayCount: directPlayCount ?? this.directPlayCount,
      transcodeCount: transcodeCount ?? this.transcodeCount,
      lanBandwidth: lanBandwidth ?? this.lanBandwidth,
      wanBandwidth: wanBandwidth ?? this.wanBandwidth,
      failure: failure ?? this.failure,
      failureMessage: failureMessage ?? this.failureMessage,
      failureSuggestion: failureSuggestion ?? this.failureSuggestion,
    );
  }

  @override
  List<Object?> get props => [
        sortIndex,
        serverName,
        tautulliId,
        status,
        activityList,
        copyCount,
        directPlayCount,
        transcodeCount,
        lanBandwidth,
        wanBandwidth,
        failure,
        failureMessage,
        failureSuggestion,
      ];
}
