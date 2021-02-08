import '../../../../core/helpers/value_helper.dart';
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
      dateFormat: ValueHelper.cast(
        value: json['date_format'],
        type: CastType.string,
      ),
      timeFormat: ValueHelper.cast(
        value: json['time_format'],
        type: CastType.string,
      ),
    );
  }
}
