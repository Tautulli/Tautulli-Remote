import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/device_info/device_info.dart';
import 'core/helpers/connection_address_helper.dart';
import 'core/helpers/log_format_helper.dart';
import 'core/helpers/tautulli_api_url_helper.dart';
import 'core/network/network_info.dart';
import 'features/activity/data/datasources/activity_data_source.dart';
import 'features/activity/data/datasources/geo_ip_data_source.dart';
import 'features/activity/data/repositories/activity_repository_impl.dart';
import 'features/activity/data/repositories/geo_ip_repository_impl.dart';
import 'features/activity/domain/repositories/activity_repository.dart';
import 'features/activity/domain/repositories/geo_ip_repository.dart';
import 'features/activity/domain/usecases/get_activity.dart';
import 'features/activity/domain/usecases/get_geo_ip.dart';
import 'features/activity/presentation/bloc/activity_bloc.dart';
import 'features/logging/data/datasources/logging_data_source.dart';
import 'features/logging/data/repositories/logging_repository_impl.dart';
import 'features/logging/domain/repositories/logging_repository.dart';
import 'features/logging/domain/usecases/logging.dart';
import 'features/logging/presentation/bloc/load_logs_bloc.dart';
import 'features/onesignal/data/datasources/onesignal_data_source.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import 'features/settings/data/datasources/register_device_data_source.dart';
import 'features/settings/data/repositories/register_device_repository_impl.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/register_device_repository.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/register_device.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/register_device_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';

// Service locator alias
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Settings
  // Bloc
  sl.registerFactory(
    () => SettingsBloc(
      settings: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => RegisterDeviceBloc(
      registerDevice: sl(),
      settings: sl(),
      connectionAddressHelper: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => Settings(repository: sl()),
  );

  sl.registerLazySingleton(
    () => RegisterDevice(repository: sl()),
  );

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      // dataSource: sl(),
      connectionAddressHelper: sl(),
    ),
  );

  sl.registerLazySingleton<RegisterDeviceRepository>(
    () => RegisterDeviceRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  // sl.registerLazySingleton<SettingsDataSource>(
  //   () => SettingsDataSourceImpl(
  //     sharedPreferences: sl(),
  //     connectionAddressHelper: sl(),
  //   ),
  // );

  sl.registerLazySingleton<RegisterDeviceDataSource>(
    () => RegisterDeviceDataSourceImpl(
      client: sl(),
      settings: sl(),
      tautulliApiUrls: sl(),
      deviceInfo: sl(),
      oneSignal: sl(),
    ),
  );

  //! Features - OneSignal
  // Bloc
  sl.registerFactory(
    () => OneSignalHealthBloc(
      oneSignal: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => OneSignalPrivacyBloc(
      oneSignal: sl(),
      settings: sl(),
      registerDevice: sl(),
      // updateDeviceRegistration: sl()
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => OneSignalSubscriptionBloc(
      oneSignal: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<OneSignalDataSource>(
    () => OneSignalDataSourceImpl(
      client: sl(),
      networkInfo: sl(),
    ),
  );

  //! Features - Logging
  // Bloc
  sl.registerFactory(
    () => LogsBloc(
      logging: sl(),
      logFormatHelper: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => Logging(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<LoggingRepository>(
    () => LoggingRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<LoggingDataSource>(
    () => LoggingDataSourceImpl(),
  );

  //! Features - Activity
  // Bloc
  sl.registerFactory(
    () => ActivityBloc(
      activity: sl(),
      geoIp: sl(),
      tautulliApiUrls: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => GetActivity(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetGeoIp(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<GeoIpRepository>(
    () => GeoIpRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ActivityDataSource>(
    () => ActivityDataSourceImpl(
      client: sl(),
      settings: sl(),
      tautulliApiUrls: sl(),
    ),
  );

  sl.registerLazySingleton<GeoIpDataSource>(
    () => GeoIpDataSourceImpl(
      client: sl(),
      settings: sl(),
      tautulliApiUrls: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivityChecker: sl(),
    ),
  );

  sl.registerLazySingleton<TautulliApiUrls>(
    () => TautulliApiUrlsImpl(
      settings: sl(),
    ),
  );

  sl.registerLazySingleton<LogFormatHelper>(
    () => LogFormatHelperImpl(),
  );

  sl.registerLazySingleton<ConnectionAddressHelper>(
    () => ConnectionAddressHelperImpl(),
  );

  sl.registerLazySingleton<DeviceInfo>(
    () => DeviceInfoImpl(
      sl(),
    ),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => DeviceInfoPlugin());
}
