import 'package:equatable/equatable.dart';

class ChartDataModel extends Equatable {
  final double horizontalLineStep;
  final double verticalLineStep;
  final double maxYLines;

  const ChartDataModel({
    required this.horizontalLineStep,
    required this.verticalLineStep,
    required this.maxYLines,
  });

  @override
  List<Object?> get props => [horizontalLineStep, verticalLineStep, maxYLines];
}
