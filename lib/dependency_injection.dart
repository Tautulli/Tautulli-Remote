import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/tautulli/tautulli_api.dart' as tautulli_api;
import 'core/device_info/device_info.dart';
import 'core/local_storage/local_storage.dart';
import 'core/manage_cache/manage_cache.dart';
import 'core/network_info/network_info.dart';
import 'core/package_information/package_information.dart';
import 'features/logging/data/datasources/logging_data_source.dart';
import 'features/logging/data/repositories/logging_repository_impl.dart';
import 'features/logging/domain/repositories/logging_repository.dart';
import 'features/logging/domain/usecases/logging.dart';
import 'features/logging/presentation/bloc/logging_bloc.dart';
import 'features/logging/presentation/bloc/logging_export_bloc.dart';
import 'features/onesignal/data/datasources/onesignal_data_source.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_status_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import 'features/settings/data/datasources/settings_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/register_device_bloc.dart';
import 'features/settings/presentation/bloc/registration_headers_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/translation/presentation/bloc/translation_bloc.dart';

// Service locator alias
final sl = GetIt.instance;

Future<void> init() async {
  //! Core - API
  sl.registerLazySingleton<tautulli_api.CallTautulli>(
    () => tautulli_api.CallTautulliImpl(),
  );
  sl.registerLazySingleton<tautulli_api.ConnectionHandler>(
    () => tautulli_api.ConnectionHandlerImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.RegisterDevice>(
    () => tautulli_api.RegisterDeviceImpl(sl()),
  );

  //! Core - Device Info
  sl.registerLazySingleton<DeviceInfo>(
    () => DeviceInfoImpl(sl()),
  );

  //! Core - Local Storage
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(sl()),
  );

  //! Core - Manage Cache
  sl.registerLazySingleton<ManageCache>(
    () => ManageCacheImpl(sl()),
  );

  //! Core - Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  //! Core - Package Information
  sl.registerLazySingleton<PackageInformation>(
    () => PackageInformationImpl(),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => DefaultCacheManager());
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => DeviceInfoPlugin());

  //! Features - Logging
  // Bloc
  sl.registerFactory(
    () => LoggingBloc(
      logging: sl(),
    ),
  );
  sl.registerFactory(
    () => LoggingExportBloc(
      logging: sl(),
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

  //! Features - OneSignal
  // Bloc
  sl.registerFactory(
    () => OneSignalHealthBloc(
      logging: sl(),
      oneSignal: sl(),
    ),
  );
  sl.registerFactory(
    () => OneSignalPrivacyBloc(
      logging: sl(),
      oneSignal: sl(),
      settings: sl(),
    ),
  );
  sl.registerFactory(
    () => OneSignalStatusBloc(
      oneSignal: sl(),
    ),
  );
  sl.registerFactory(
    () => OneSignalSubBloc(
      oneSignal: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<OneSignalDataSource>(
    () => OneSignalDataSourceImpl(
      client: sl(),
      networkInfo: sl(),
      settings: sl(),
    ),
  );

  //! Features - Settings
  // Bloc
  sl.registerFactory(
    () => RegisterDeviceBloc(
      logging: sl(),
      settings: sl(),
    ),
  );
  sl.registerFactory(
    () => RegistrationHeadersBloc(),
  );
  sl.registerFactory(
    () => SettingsBloc(
      logging: sl(),
      manageCache: sl(),
      settings: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => Settings(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SettingsDataSource>(
    () => SettingsDataSourceImpl(
      deviceInfo: sl(),
      localStorage: sl(),
      packageInfo: sl(),
      registerDeviceApi: sl(),
    ),
  );

  //! Features - Translation
  // Bloc
  sl.registerFactory(
    () => TranslationBloc(
      logging: sl(),
    ),
  );
}
