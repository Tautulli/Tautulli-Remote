import 'package:equatable/equatable.dart';

import '../../../../core/types/tautulli_types.dart';
import 'statistic_data_model.dart';

class StatisticModel extends Equatable {
  final StatIdType statIdType;
  final List<StatisticDataModel> stats;

  const StatisticModel({
    required this.statIdType,
    this.stats = const [],
  });

  StatisticModel copyWith({
    StatIdType? statIdType,
    List<StatisticDataModel>? stats,
  }) {
    return StatisticModel(
      statIdType: statIdType ?? this.statIdType,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [statIdType, stats];
}
