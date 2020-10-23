import '../../domain/entities/tautulli_settings_general.dart';

class TautulliSettingsGeneralModel extends TautulliSettingsGeneral {
  TautulliSettingsGeneralModel({
    final String dateFormat,
    final String timeFormat,
  }) : super(
          dateFormat: dateFormat,
          timeFormat: timeFormat,
        );

  factory TautulliSettingsGeneralModel.fromJson(Map<String, dynamic> json) {
    return TautulliSettingsGeneralModel(
      dateFormat: json['date_format'],
      timeFormat: json['time_format'],
    );
  }
}
