import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required int serverTimeout,
  }) : super(
          serverTimeout: serverTimeout,
        );

  AppSettingsModel copyWith({
    int? serverTimeout,
  }) {
    return AppSettingsModel(
      serverTimeout: serverTimeout ?? this.serverTimeout,
    );
  }
}
