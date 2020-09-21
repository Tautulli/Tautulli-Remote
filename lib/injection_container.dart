import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/tautulli_api.dart';
import 'core/device_info/device_info.dart';
import 'core/helpers/connection_address_helper.dart';
import 'core/helpers/failure_mapper_helper.dart';
import 'core/helpers/log_format_helper.dart';
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
import 'features/history/data/datasources/history_data_source.dart';
import 'features/history/data/repositories/history_repository_impl.dart';
import 'features/history/domain/repositories/history_repository.dart';
import 'features/history/domain/usecases/get_history.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/image_url/data/datasources/image_url_data_source.dart';
import 'features/image_url/data/respositories/image_url_repository_impl.dart';
import 'features/image_url/domain/repositories/image_url_repository.dart';
import 'features/image_url/domain/usecases/get_image_url.dart';
import 'features/libraries/data/datasources/libraries_data_source.dart';
import 'features/libraries/data/repositories/libraries_repository_impl.dart';
import 'features/libraries/domain/repositories/libraries_repository.dart';
import 'features/libraries/domain/usercases/get_libraries.dart';
import 'features/libraries/presentation/bloc/libraries_bloc.dart';
import 'features/logging/data/datasources/logging_data_source.dart';
import 'features/logging/data/repositories/logging_repository_impl.dart';
import 'features/logging/domain/repositories/logging_repository.dart';
import 'features/logging/domain/usecases/logging.dart';
import 'features/logging/presentation/bloc/load_logs_bloc.dart';
import 'features/onesignal/data/datasources/onesignal_data_source.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import 'features/recent/data/datasources/recently_added_data_source.dart';
import 'features/recent/data/repositories/recently_added_repository_impl.dart';
import 'features/recent/domain/repositories/recently_added_repository.dart';
import 'features/recent/domain/usecases/get_recently_added.dart';
import 'features/recent/presentation/bloc/recently_added_bloc.dart';
import 'features/settings/data/datasources/register_device_data_source.dart';
import 'features/settings/data/datasources/settings_data_source.dart';
import 'features/settings/data/repositories/register_device_repository_impl.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/register_device_repository.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/register_device.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/register_device_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/statistics/data/datasources/statistics_data_source.dart';
import 'features/statistics/data/repositories/statistics_repository_impl.dart';
import 'features/statistics/domain/repositories/statistics_repository.dart';
import 'features/statistics/domain/usecases/get_statistics.dart';
import 'features/statistics/presentation/bloc/statistics_bloc.dart';
import 'features/terminate_session/data/datasources/terminate_session_data_source.dart';
import 'features/terminate_session/data/repositories/terminate_session_repository_impl.dart';
import 'features/terminate_session/domain/repositories/terminate_session_repository.dart';
import 'features/terminate_session/domain/usecases/terminate_session.dart';
import 'features/terminate_session/presentation/bloc/terminate_session_bloc.dart';
import 'features/users/data/datasources/users_data_source.dart';
import 'features/users/data/repositories/users_repository_impl.dart';
import 'features/users/domain/repositories/users_repository.dart';
import 'features/users/domain/usercases/get_user_names.dart';
import 'features/users/domain/usercases/get_users_table.dart';
import 'features/users/presentation/bloc/users_bloc.dart';

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
      dataSource: sl(),
      connectionAddressHelper: sl(),
    ),
  );

  sl.registerLazySingleton<RegisterDeviceRepository>(
    () => RegisterDeviceRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
      failureMapperHelper: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SettingsDataSource>(
    () => SettingsDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<RegisterDeviceDataSource>(
    () => RegisterDeviceDataSourceImpl(
      tautulliApi: sl(),
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

  //! Features - TerminateSession
  // Bloc
  sl.registerFactory(
    () => TerminateSessionBloc(
      terminateSession: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => TerminateSession(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<TerminateSessionRepository>(
    () => TerminateSessionRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
      failureMapperHelper: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TerminateSessionDataSource>(
    () => TerminateSessionDataSourceImpl(
      tautulliApi: sl(),
    ),
  );

  //! Features - ImageUrl
  // Use case
  sl.registerLazySingleton(
    () => GetImageUrl(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<ImageUrlRepository>(
    () => ImageUrlRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
      failureMapperHelper: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ImageUrlDataSource>(
    () => ImageUrlDataSourceImpl(
      tautulliApi: sl(),
    ),
  );

  //! Features - Activity
  // Bloc
  sl.registerFactory(
    () => ActivityBloc(
      activity: sl(),
      geoIp: sl(),
      imageUrl: sl(),
      settings: sl(),
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
      failureMapperHelper: sl(),
    ),
  );

  sl.registerLazySingleton<GeoIpRepository>(
    () => GeoIpRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
      failureMapperHelper: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ActivityDataSource>(
    () => ActivityDataSourceImpl(
      settings: sl(),
      tautulliApi: sl(),
      logging: sl(),
    ),
  );

  sl.registerLazySingleton<GeoIpDataSource>(
    () => GeoIpDataSourceImpl(
      tautulliApi: sl(),
      logging: sl(),
    ),
  );

  //! Features - Recent
  // Bloc
  sl.registerFactory(
    () => RecentlyAddedBloc(
      recentlyAdded: sl(),
      getImageUrl: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => GetRecentlyAdded(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<RecentlyAddedRepository>(
    () => RecentlyAddedRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
      failureMapperHelper: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<RecentlyAddedDataSource>(
    () => RecentlyAddedDataSourceImpl(
      tautulliApi: sl(),
      logging: sl(),
    ),
  );

  //! Features - Users
  // Bloc
  sl.registerFactory(
    () => UsersBloc(
      getUsersTable: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => GetUserNames(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetUsersTable(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<UsersRepository>(
    () => UsersTableRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
      failureMapperHelper: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<UsersDataSource>(
    () => UsersDataSourceImpl(
      tautulliApi: sl(),
    ),
  );

  //! Features - History
  // Bloc
  sl.registerFactory(
    () => HistoryBloc(
      getHistory: sl(),
      getUserNames: sl(),
      getImageUrl: sl(),
      logging: sl(),
    ),
  );

  // User case
  sl.registerLazySingleton(
    () => GetHistory(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
      failureMapperHelper: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<HistoryDataSource>(
    () => HistoryDataSourceImpl(
      tautulliApi: sl(),
      logging: sl(),
    ),
  );

  //! Features - Libraries
  // Bloc
  sl.registerFactory(
    () => LibrariesBloc(
      getLibraries: sl(),
      getImageUrl: sl(),
    ),
  );

  // User case
  sl.registerLazySingleton(
    () => GetLibraries(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<LibrariesRepository>(
    () => LibrariesRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
      failureMapperHelper: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<LibrariesDataSource>(
    () => LibrariesDataSourceImpl(
      tautulliApi: sl(),
    ),
  );

  //! Features - Statistics
  // Bloc
  sl.registerFactory(
    () => StatisticsBloc(
      getStatistics: sl(),
      getImageUrl: sl(),
    ),
  );

  // User case
  sl.registerLazySingleton(
    () => GetStatistics(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
      failureMapperHelper: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<StatisticsDataSource>(
    () => StatisticsDataSourceImpl(
      tautulliApi: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivityChecker: sl(),
    ),
  );

  sl.registerLazySingleton<TautulliApi>(
    () => TautulliApiImpl(
      client: sl(),
      settings: sl(),
      logging: sl(),
    ),
  );

  sl.registerLazySingleton<LogFormatHelper>(
    () => LogFormatHelperImpl(),
  );

  sl.registerLazySingleton(
    () => FailureMapperHelper(),
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
