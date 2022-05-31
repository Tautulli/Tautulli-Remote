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
import 'core/qr_code_scanner/qr_code_scanner.dart';
import 'features/announcements/data/datasources/announcements_data_source.dart';
import 'features/announcements/data/repositories/announcements_repository_impl.dart';
import 'features/announcements/domain/repositories/announcements_repository.dart';
import 'features/announcements/domain/usecases/announcements.dart';
import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/geo_ip/data/datasources/geo_ip_data_source.dart';
import 'features/geo_ip/data/repositories/geo_ip_repository_impl.dart';
import 'features/geo_ip/domain/repositories/geo_ip_repository.dart';
import 'features/geo_ip/domain/usecases/geo_ip.dart';
import 'features/geo_ip/presentation/bloc/geo_ip_bloc.dart';
import 'features/history/data/datasources/history_data_source.dart';
import 'features/history/data/repositories/history_repository_impl.dart';
import 'features/history/domain/repositories/history_repository.dart';
import 'features/history/domain/usecases/history.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/history/presentation/bloc/individual_history_bloc.dart';
import 'features/image_url/data/datasources/image_url_data_source.dart';
import 'features/image_url/data/repositories/image_url_repository_impl.dart';
import 'features/image_url/domain/repositories/image_url_repository.dart';
import 'features/image_url/domain/usecases/image_url.dart';
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
import 'features/users/data/datasources/users_data_source.dart';
import 'features/users/data/repositories/users_repository_impl.dart';
import 'features/users/domain/repositories/users_repository.dart';
import 'features/users/domain/usecases/users.dart';
import 'features/users/presentation/bloc/user_individual_bloc.dart';
import 'features/users/presentation/bloc/user_statistics_bloc.dart';
import 'features/users/presentation/bloc/users_bloc.dart';
import 'features/users/presentation/bloc/users_table_bloc.dart';

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
  sl.registerLazySingleton<tautulli_api.GetGeoIpLookup>(
    () => tautulli_api.GetGeoIpLookupImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetHistory>(
    () => tautulli_api.GetHistoryImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetServerInfo>(
    () => tautulli_api.GetServerInfoImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetSettings>(
    () => tautulli_api.GetSettingsImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetUserPlayerStats>(
    () => tautulli_api.GetUserPlayerStatsImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetUserWatchTimeStats>(
    () => tautulli_api.GetUserWatchTimeStatsImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetUser>(
    () => tautulli_api.GetUserImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetUserNames>(
    () => tautulli_api.GetUserNamesImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetUsersTable>(
    () => tautulli_api.GetUsersTableImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.PmsImageProxy>(
    () => tautulli_api.PmsImageProxyImpl(sl()),
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

  //! Core - QR Code Scanner
  sl.registerLazySingleton<QrCodeScanner>(
    () => QrCodeScannerImpl(),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => DefaultCacheManager());
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => DeviceInfoPlugin());

  //! Features - Announcements
  // Bloc
  sl.registerFactory(
    () => AnnouncementsBloc(
      announcements: sl(),
      logging: sl(),
      settings: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => Announcements(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AnnouncementsRepository>(
    () => AnnouncementsRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AnnouncementsDataSource>(
    () => AnnouncementsDataSourceImpl(),
  );

  //! Features - GeoIp
  // Bloc
  sl.registerFactory(
    () => GeoIpBloc(
      geoIp: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => GeoIp(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<GeoIpRepository>(
    () => GeoIpRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<GeoIpDataSource>(
    () => GeoIpDataSourceImpl(
      getGeoIpLookup: sl(),
    ),
  );

  //! Features - History
  // Bloc
  sl.registerFactory(
    () => HistoryBloc(
      history: sl(),
      imageUrl: sl(),
      logging: sl(),
    ),
  );
  sl.registerFactory(
    () => IndividualHistoryBloc(
      history: sl(),
      imageUrl: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => History(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<HistoryDataSource>(
    () => HistoryDataSourceImpl(
      getHistoryApi: sl(),
    ),
  );

  //! Features - Image URL
  // Use case
  sl.registerLazySingleton(
    () => ImageUrl(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<ImageUrlRepository>(
    () => ImageUrlRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ImageUrlDataSource>(
    () => ImageUrlDataSourceImpl(
      pmsImageProxy: sl(),
    ),
  );

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
    () => RegistrationHeadersBloc(
      logging: sl(),
    ),
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
      getServerInfoApi: sl(),
      getSettingsApi: sl(),
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

  //! Features - Users
  // Bloc
  sl.registerFactory(
    () => UserIndividualBloc(
      users: sl(),
      logging: sl(),
    ),
  );
  sl.registerFactory(
    () => UsersBloc(
      users: sl(),
      logging: sl(),
    ),
  );
  sl.registerFactory(
    () => UsersTableBloc(
      users: sl(),
      logging: sl(),
    ),
  );
  sl.registerFactory(
    () => UserStatisticsBloc(
      users: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => Users(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<UsersRepository>(
    () => UsersRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UsersDataSource>(
    () => UsersDataSourceImpl(
      getUserApi: sl(),
      getUserPlayerStats: sl(),
      getUserWatchTimeStats: sl(),
      getUserNamesApi: sl(),
      getUsersTableApi: sl(),
    ),
  );
}
