import 'package:equatable/equatable.dart';

import 'activity_model.dart';

class ServerActivityModel extends Equatable {
  final int sortIndex;
  final String serverName;
  final String tautulliId;
  final List<ActivityModel> activityList;
  final int copyCount;
  final int directPlayCount;
  final int transcodeCount;
  final int lanBandwidth;
  final int wanBandwidth;

  const ServerActivityModel({
    required this.sortIndex,
    required this.serverName,
    required this.tautulliId,
    required this.activityList,
    required this.copyCount,
    required this.directPlayCount,
    required this.transcodeCount,
    required this.lanBandwidth,
    required this.wanBandwidth,
  });

  ServerActivityModel copyWith({
    final int? sortIndex,
    final String? serverName,
    final String? tautulliId,
    final List<ActivityModel>? activityList,
    final int? copyCount,
    final int? directPlayCount,
    final int? transcodeCount,
    final int? lanBandwidth,
    final int? wanBandwidth,
  }) {
    return ServerActivityModel(
      sortIndex: sortIndex ?? this.sortIndex,
      serverName: serverName ?? this.serverName,
      tautulliId: tautulliId ?? this.tautulliId,
      activityList: activityList ?? this.activityList,
      copyCount: copyCount ?? this.copyCount,
      directPlayCount: directPlayCount ?? this.directPlayCount,
      transcodeCount: transcodeCount ?? this.transcodeCount,
      lanBandwidth: lanBandwidth ?? this.lanBandwidth,
      wanBandwidth: wanBandwidth ?? this.wanBandwidth,
    );
  }

  @override
  List<Object?> get props => [
        sortIndex,
        serverName,
        tautulliId,
        activityList,
        copyCount,
        directPlayCount,
        transcodeCount,
        lanBandwidth,
        wanBandwidth,
      ];
}
