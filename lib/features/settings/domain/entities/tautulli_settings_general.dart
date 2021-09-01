// @dart=2.9

import 'package:equatable/equatable.dart';

abstract class TautulliSettingsGeneral extends Equatable {
  final String dateFormat;
  final String timeFormat;

  TautulliSettingsGeneral({
    this.dateFormat,
    this.timeFormat,
  });

  @override
  List<Object> get props => [dateFormat, timeFormat];

  @override
  bool get stringify => true;
}
