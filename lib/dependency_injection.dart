import 'package:android_id/android_id.dart';
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
import 'core/open_in_plex/open_in_plex.dart';
import 'core/package_information/package_information.dart';
import 'core/qr_code_scanner/qr_code_scanner.dart';
import 'features/activity/data/datasources/activity_data_source.dart';
import 'features/activity/data/repositories/activity_repository_impl.dart';
import 'features/activity/domain/repositories/activity_repository.dart';
import 'features/activity/domain/usecases/activity.dart';
import 'features/activity/presentation/bloc/activity_bloc.dart';
import 'features/activity/presentation/bloc/terminate_stream_bloc.dart';
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
import 'features/graphs/data/datasources/graphs_data_source.dart';
import 'features/graphs/data/repositories/graphs_repository_impl.dart';
import 'features/graphs/domain/repositories/graphs_repository.dart';
import 'features/graphs/domain/usecases/graphs.dart';
import 'features/graphs/presentation/bloc/graphs_bloc.dart';
import 'features/history/data/datasources/history_data_source.dart';
import 'features/history/data/repositories/history_repository_impl.dart';
import 'features/history/domain/repositories/history_repository.dart';
import 'features/history/domain/usecases/history.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/history/presentation/bloc/individual_history_bloc.dart';
import 'features/history/presentation/bloc/library_history_bloc.dart';
import 'features/history/presentation/bloc/search_history_bloc.dart';
import 'features/history/presentation/bloc/user_history_bloc.dart';
import 'features/image_url/data/datasources/image_url_data_source.dart';
import 'features/image_url/data/repositories/image_url_repository_impl.dart';
import 'features/image_url/domain/repositories/image_url_repository.dart';
import 'features/image_url/domain/usecases/image_url.dart';
import 'features/libraries/data/datasources/libraries_data_source.dart';
import 'features/libraries/data/repositories/libraries_repository_impl.dart';
import 'features/libraries/domain/repositories/libraries_repository.dart';
import 'features/libraries/domain/usecases/libraries.dart';
import 'features/libraries/presentation/bloc/libraries_bloc.dart';
import 'features/libraries/presentation/bloc/library_media_bloc.dart';
import 'features/libraries/presentation/bloc/library_statistics_bloc.dart';
import 'features/logging/data/datasources/logging_data_source.dart';
import 'features/logging/data/repositories/logging_repository_impl.dart';
import 'features/logging/domain/repositories/logging_repository.dart';
import 'features/logging/domain/usecases/logging.dart';
import 'features/logging/presentation/bloc/logging_bloc.dart';
import 'features/logging/presentation/bloc/logging_export_bloc.dart';
import 'features/media/data/datasources/media_data_source.dart';
import 'features/media/data/repositories/media_repository_impl.dart';
import 'features/media/domain/repositories/media_repository.dart';
import 'features/media/domain/usecases/media.dart';
import 'features/media/presentation/bloc/children_metadata_bloc.dart';
import 'features/media/presentation/bloc/metadata_bloc.dart';
import 'features/onesignal/data/datasources/onesignal_data_source.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_status_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_sub_bloc.dart';
import 'features/recently_added/data/datasources/recently_added_data_source.dart';
import 'features/recently_added/data/repositories/recently_added_repository_impl.dart';
import 'features/recently_added/domain/repositories/recently_added_repository.dart';
import 'features/recently_added/domain/usecases/recently_added.dart';
import 'features/recently_added/presentation/bloc/library_recently_added_bloc.dart';
import 'features/recently_added/presentation/bloc/recently_added_bloc.dart';
import 'features/settings/data/datasources/settings_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/settings.dart';
import 'features/settings/presentation/bloc/clear_tautulli_image_cache_bloc.dart';
import 'features/settings/presentation/bloc/register_device_bloc.dart';
import 'features/settings/presentation/bloc/registration_headers_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/statistics/data/datasources/statistics_data_source.dart';
import 'features/statistics/data/repositories/statistics_repository_impl.dart';
import 'features/statistics/domain/repositories/statistics_repository.dart';
import 'features/statistics/domain/usecases/statistics.dart';
import 'features/statistics/presentation/bloc/statistics_bloc.dart';
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
  sl.registerLazySingleton<tautulli_api.DeleteImageCache>(
    () => tautulli_api.DeleteImageCacheImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetActivity>(
    () => tautulli_api.GetActivityImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetChildrenMetadata>(
    () => tautulli_api.GetChildrenMetadataImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetConcurrentStreamsByStreamType>(
    () => tautulli_api.GetConcurrentStreamsByStreamTypeImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetGeoIpLookup>(
    () => tautulli_api.GetGeoIpLookupImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetHistory>(
    () => tautulli_api.GetHistoryImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetHomeStats>(
    () => tautulli_api.GetHomeStatsImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetLibrariesTable>(
    () => tautulli_api.GetLibrariesTableImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetLibraryMediaInfo>(
    () => tautulli_api.GetLibraryMediaInfoImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetLibraryUserStats>(
    () => tautulli_api.GetLibraryUserStatsImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetLibraryWatchTimeStats>(
    () => tautulli_api.GetLibraryWatchTimeStatsImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetMetadata>(
    () => tautulli_api.GetMetadataImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByDate>(
    () => tautulli_api.GetPlaysByDateImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByDayOfWeek>(
    () => tautulli_api.GetPlaysByDayOfWeekImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByHourOfDay>(
    () => tautulli_api.GetPlaysByHourOfDayImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysBySourceResolution>(
    () => tautulli_api.GetPlaysBySourceResolutionImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByStreamResolution>(
    () => tautulli_api.GetPlaysByStreamResolutionImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByStreamType>(
    () => tautulli_api.GetPlaysByStreamTypeImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByTop10Platforms>(
    () => tautulli_api.GetPlaysByTop10PlatformsImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByTop10Users>(
    () => tautulli_api.GetPlaysByTop10UsersImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysPerMonth>(
    () => tautulli_api.GetPlaysPerMonthImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetRecentlyAdded>(
    () => tautulli_api.GetRecentlyAddedImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetServerInfo>(
    () => tautulli_api.GetServerInfoImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetSettings>(
    () => tautulli_api.GetSettingsImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetStreamTypeByTop10Platforms>(
    () => tautulli_api.GetStreamTypeByTop10PlatformsImpl(sl()),
  );
  sl.registerLazySingleton<tautulli_api.GetStreamTypeByTop10Users>(
    () => tautulli_api.GetStreamTypeByTop10UsersImpl(sl()),
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
  sl.registerLazySingleton<tautulli_api.TerminateSession>(
    () => tautulli_api.TerminateSessionImpl(sl()),
  );

  //! Core - Device Info
  sl.registerLazySingleton<DeviceInfo>(
    () => DeviceInfoImpl(
      androidId: sl(),
      deviceInfoPlugin: sl(),
    ),
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

  //! Core - Open In Plex
  sl.registerLazySingleton<OpenInPlex>(
    () => OpenInPlexImpl(),
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
  sl.registerLazySingleton(() => const AndroidId());

  //! Features - Activity
  // Bloc
  sl.registerFactory(
    () => ActivityBloc(
      activity: sl(),
      imageUrl: sl(),
      logging: sl(),
      settings: sl(),
    ),
  );
  sl.registerFactory(
    () => TerminateStreamBloc(
      activity: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => Activity(
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

  // Data sources
  sl.registerLazySingleton<ActivityDataSource>(
    () => ActivityDataSourceImpl(
      getActivityApi: sl(),
      terminateStreamApi: sl(),
    ),
  );

  //! Features - Announcements
  // Bloc
  sl.registerFactory(
    () => AnnouncementsBloc(
      announcements: sl(),
      deviceInfo: sl(),
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

  //! Features - Graphs
  // Bloc
  sl.registerFactory(
    () => GraphsBloc(
      graphs: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => Graphs(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<GraphsRepository>(
    () => GraphsRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<GraphsDataSource>(
    () => GraphsDataSourceImpl(
      getConcurrentStreamsByStreamTypeApi: sl(),
      getPlaysByDateApi: sl(),
      getPlaysByDayOfWeekApi: sl(),
      getPlaysByHourOfDayApi: sl(),
      getPlaysBySourceResolutionApi: sl(),
      getPlaysByStreamResolutionApi: sl(),
      getPlaysByStreamTypeApi: sl(),
      getPlaysByTop10PlatformsApi: sl(),
      getPlaysByTop10UsersApi: sl(),
      getPlaysPerMonthApi: sl(),
      getStreamTypeByTop10PlatformsApi: sl(),
      getStreamTypeByTop10UsersApi: sl(),
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
      logging: sl(),
    ),
  );
  sl.registerFactory(
    () => LibraryHistoryBloc(
      history: sl(),
      imageUrl: sl(),
      logging: sl(),
    ),
  );
  sl.registerFactory(
    () => UserHistoryBloc(
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

  //! Features - Libraries
  // Bloc
  sl.registerFactory(
    () => LibrariesBloc(
      libraries: sl(),
      imageUrl: sl(),
      logging: sl(),
    ),
  );
  sl.registerFactory(
    () => LibraryMediaBloc(
      libraries: sl(),
      imageUrl: sl(),
      logging: sl(),
    ),
  );
  sl.registerFactory(
    () => LibraryStatisticsBloc(
      libraries: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => Libraries(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<LibrariesRepository>(
    () => LibrariesRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<LibrariesDataSource>(
    () => LibrariesDataSourceImpl(
      getLibrariesTableApi: sl(),
      getLibraryMediaInfoApi: sl(),
      getLibraryUserStatsApi: sl(),
      getLibraryWatchTimeStatsApi: sl(),
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

  //! Features - Media
  // Bloc
  sl.registerFactory(
    () => ChildrenMetadataBloc(
      media: sl(),
      imageUrl: sl(),
      logging: sl(),
    ),
  );
  sl.registerFactory(
    () => MetadataBloc(
      media: sl(),
      imageUrl: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => Media(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<MediaRepository>(
    () => MediaRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<MediaDataSource>(
    () => MediaDataSourceImpl(
      getMetadataApi: sl(),
      getChildrenMetadataApi: sl(),
    ),
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

  //! Features - Recently Added
  // Bloc
  sl.registerFactory(
    () => LibraryRecentlyAddedBloc(
      recentlyAdded: sl(),
      imageUrl: sl(),
      logging: sl(),
    ),
  );
  sl.registerFactory(
    () => RecentlyAddedBloc(
      recentlyAdded: sl(),
      imageUrl: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => RecentlyAdded(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<RecentlyAddedRepository>(
    () => RecentlyAddedRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RecentlyAddedDataSource>(
    () => RecentlyAddedDataSourceImpl(
      getRecentlyAddedApi: sl(),
    ),
  );

  //! Features - Search
  // Bloc
  sl.registerFactory(
    () => SearchHistoryBloc(
      history: sl(),
      imageUrl: sl(),
      logging: sl(),
    ),
  );

  //! Features - Settings
  // Bloc
  sl.registerFactory(
    () => ClearTautulliImageCacheBloc(
      logging: sl(),
      settings: sl(),
    ),
  );
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
      deleteImageCacheApi: sl(),
      getServerInfoApi: sl(),
      getSettingsApi: sl(),
      registerDeviceApi: sl(),
    ),
  );

  //! Features - Statistics
  // Bloc
  sl.registerFactory(
    () => StatisticsBloc(
      statistics: sl(),
      imageUrl: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => Statistics(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<StatisticsDataSource>(
    () => StatisticsDataSourceImpl(
      getHomeStatsApi: sl(),
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
