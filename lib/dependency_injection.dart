import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/local_storage/local_storage.dart';
import 'core/manage_cache/manage_cache.dart';
import 'core/network_info/network_info.dart';
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
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/translation/presentation/bloc/translation_bloc.dart';

// Service locator alias
final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(sl()),
  );
  sl.registerLazySingleton<ManageCache>(
    () => ManageCacheImpl(sl()),
  );
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DefaultCacheManager());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());

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
    ),
  );

  // Data sources
  sl.registerLazySingleton<SettingsDataSource>(
    () => SettingsDataSourceImpl(
      localStorage: sl(),
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
