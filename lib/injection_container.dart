// @dart=2.9

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/tautulli_api/tautulli_api.dart' as tautulli_api;
import 'core/device_info/device_info.dart';
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
import 'features/activity/presentation/bloc/geo_ip_bloc.dart';
import 'features/announcements/data/datasources/announcements_data_source.dart';
import 'features/announcements/data/repositories/announcements_repository_impl.dart';
import 'features/announcements/domain/repositories/announcements_repository.dart';
import 'features/announcements/domain/usecases/get_announcements.dart';
import 'features/announcements/presentation/bloc/announcements_bloc.dart';
import 'features/cache/data/datasources/cache_data_source.dart';
import 'features/cache/data/repositories/cache_repository_impl.dart';
import 'features/cache/domain/repositories/cache_repository.dart';
import 'features/cache/domain/usecases/clear_cache.dart';
import 'features/cache/presentation/bloc/cache_bloc.dart';
import 'features/graphs/data/datasources/graphs_data_source.dart';
import 'features/graphs/data/repositories/graphs_repository_impl.dart';
import 'features/graphs/domain/repositories/graphs_repository.dart';
import 'features/graphs/domain/usecases/get_plays_by_date.dart';
import 'features/graphs/domain/usecases/get_plays_by_day_of_week.dart';
import 'features/graphs/domain/usecases/get_plays_by_hour_of_day.dart';
import 'features/graphs/domain/usecases/get_plays_by_source_resolution.dart';
import 'features/graphs/domain/usecases/get_plays_by_stream_resolution.dart';
import 'features/graphs/domain/usecases/get_plays_by_stream_type.dart';
import 'features/graphs/domain/usecases/get_plays_by_top_10_platforms.dart';
import 'features/graphs/domain/usecases/get_plays_by_top_10_users.dart';
import 'features/graphs/domain/usecases/get_plays_per_month.dart';
import 'features/graphs/domain/usecases/get_stream_type_by_top_10_platforms.dart';
import 'features/graphs/domain/usecases/get_stream_type_by_top_10_users.dart';
import 'features/graphs/presentation/bloc/media_type_graphs_bloc.dart';
import 'features/graphs/presentation/bloc/play_totals_graphs_bloc.dart';
import 'features/graphs/presentation/bloc/stream_type_graphs_bloc.dart';
import 'features/history/data/datasources/history_data_source.dart';
import 'features/history/data/repositories/history_repository_impl.dart';
import 'features/history/domain/repositories/history_repository.dart';
import 'features/history/domain/usecases/get_history.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/history/presentation/bloc/history_individual_bloc.dart';
import 'features/history/presentation/bloc/history_libraries_bloc.dart';
import 'features/image_url/data/datasources/image_url_data_source.dart';
import 'features/image_url/data/respositories/image_url_repository_impl.dart';
import 'features/image_url/domain/repositories/image_url_repository.dart';
import 'features/image_url/domain/usecases/get_image_url.dart';
import 'features/libraries/data/datasources/libraries_data_source.dart';
import 'features/libraries/data/datasources/library_media_data_source.dart';
import 'features/libraries/data/datasources/library_statistics_data_source.dart';
import 'features/libraries/data/repositories/libraries_repository_impl.dart';
import 'features/libraries/data/repositories/library_media_repository_impl.dart';
import 'features/libraries/data/repositories/library_statistics_repository_impl.dart';
import 'features/libraries/domain/repositories/libraries_repository.dart';
import 'features/libraries/domain/repositories/library_media_repository.dart';
import 'features/libraries/domain/repositories/library_statistics_repository.dart';
import 'features/libraries/domain/usecases/get_libraries_table.dart';
import 'features/libraries/domain/usecases/get_library_media_info.dart';
import 'features/libraries/domain/usecases/get_library_user_stats.dart';
import 'features/libraries/domain/usecases/get_library_watch_time_stats.dart';
import 'features/libraries/presentation/bloc/libraries_bloc.dart';
import 'features/libraries/presentation/bloc/library_media_bloc.dart';
import 'features/libraries/presentation/bloc/library_statistics_bloc.dart';
import 'features/logging/data/datasources/logging_data_source.dart';
import 'features/logging/data/repositories/logging_repository_impl.dart';
import 'features/logging/domain/repositories/logging_repository.dart';
import 'features/logging/domain/usecases/logging.dart';
import 'features/logging/presentation/bloc/load_logs_bloc.dart';
import 'features/media/data/datasources/children_metadata_data_source.dart';
import 'features/media/data/datasources/metadata_data_source.dart';
import 'features/media/data/repositories/children_metadata_repository_impl.dart';
import 'features/media/data/repositories/metadata_repository_impl.dart';
import 'features/media/domain/repositories/children_metadata_repository.dart';
import 'features/media/domain/repositories/metadata_repository.dart';
import 'features/media/domain/usecases/get_children_metadata.dart';
import 'features/media/domain/usecases/get_metadata.dart';
import 'features/media/presentation/bloc/children_metadata_bloc.dart';
import 'features/media/presentation/bloc/metadata_bloc.dart';
import 'features/onesignal/data/datasources/onesignal_data_source.dart';
import 'features/onesignal/presentation/bloc/onesignal_health_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import 'features/onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import 'features/recent/data/datasources/recently_added_data_source.dart';
import 'features/recent/data/repositories/recently_added_repository_impl.dart';
import 'features/recent/domain/repositories/recently_added_repository.dart';
import 'features/recent/domain/usecases/get_recently_added.dart';
import 'features/recent/presentation/bloc/libraries_recently_added_bloc.dart';
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
import 'features/settings/presentation/bloc/register_device_headers_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/statistics/data/datasources/statistics_data_source.dart';
import 'features/statistics/data/repositories/statistics_repository_impl.dart';
import 'features/statistics/domain/repositories/statistics_repository.dart';
import 'features/statistics/domain/usecases/get_statistics.dart';
import 'features/statistics/presentation/bloc/statistics_bloc.dart';
import 'features/synced_items/data/datasources/delete_synced_item_data_source.dart';
import 'features/synced_items/data/datasources/synced_items_data_source.dart';
import 'features/synced_items/data/repositories/delete_synced_item_respository_impl.dart';
import 'features/synced_items/data/repositories/synced_items_repository_impl.dart';
import 'features/synced_items/domain/repositories/delete_synced_item_repository.dart';
import 'features/synced_items/domain/repositories/synced_items_repository.dart';
import 'features/synced_items/domain/usecases/delete_synced_item.dart';
import 'features/synced_items/domain/usecases/get_synced_items.dart';
import 'features/synced_items/presentation/bloc/delete_synced_item_bloc.dart';
import 'features/synced_items/presentation/bloc/synced_items_bloc.dart';
import 'features/terminate_session/data/datasources/terminate_session_data_source.dart';
import 'features/terminate_session/data/repositories/terminate_session_repository_impl.dart';
import 'features/terminate_session/domain/repositories/terminate_session_repository.dart';
import 'features/terminate_session/domain/usecases/terminate_session.dart';
import 'features/terminate_session/presentation/bloc/terminate_session_bloc.dart';
import 'features/translate/presentation/bloc/translate_bloc.dart';
import 'features/users/data/datasources/user_statistics_data_source.dart';
import 'features/users/data/datasources/users_data_source.dart';
import 'features/users/data/repositories/user_statistics_repository_impl.dart';
import 'features/users/data/repositories/users_repository_impl.dart';
import 'features/users/domain/repositories/user_statistics_repository.dart';
import 'features/users/domain/repositories/users_repository.dart';
import 'features/users/domain/usecases/get_user.dart';
import 'features/users/domain/usecases/get_user_names.dart';
import 'features/users/domain/usecases/get_user_player_stats.dart';
import 'features/users/domain/usecases/get_user_watch_time_stats.dart';
import 'features/users/domain/usecases/get_users_table.dart';
import 'features/users/presentation/bloc/user_bloc.dart';
import 'features/users/presentation/bloc/user_statistics_bloc.dart';
import 'features/users/presentation/bloc/users_bloc.dart';
import 'features/users/presentation/bloc/users_list_bloc.dart';
import 'features/wizard/presentation/bloc/wizard_bloc.dart';

// Service locator alias
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Activity
  // Bloc
  sl.registerFactory(
    () => ActivityBloc(
      activity: sl(),
      imageUrl: sl(),
      settings: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => GeoIpBloc(
      getGeoIp: sl(),
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
      settings: sl(),
      apiGetActivity: sl(),
    ),
  );

  sl.registerLazySingleton<GeoIpDataSource>(
    () => GeoIpDataSourceImpl(
      apiGetGeoipLookup: sl(),
    ),
  );

  //! Features - Announcements
  // Bloc
  sl.registerFactory(
    () => AnnouncementsBloc(
      getAnnouncements: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => GetAnnouncements(
      repository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AnnouncementsRepository>(
    () => AnnouncementsRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AnnouncementsDataSource>(
    () => AnnouncementsDataSourceImpl(
      client: sl(),
    ),
  );

  //! Features - Cache
  // Bloc
  sl.registerFactory(
    () => CacheBloc(
      clearCache: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => ClearCache(
      repository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<CacheRepository>(
    () => CacheRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CacheDataSource>(
    () => CacheDataSourceImpl(
      cacheManager: sl(),
    ),
  );

  //! Features - Graphs
  // Bloc
  sl.registerFactory(
    () => MediaTypeGraphsBloc(
      getPlaysByDate: sl(),
      getPlaysByDayOfWeek: sl(),
      getPlaysByHourOfDay: sl(),
      getPlaysByTop10Platforms: sl(),
      getPlaysByTop10Users: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => StreamTypeGraphsBloc(
      getPlaysByStreamType: sl(),
      getPlaysBySourceResolution: sl(),
      getPlaysByStreamResolution: sl(),
      getStreamTypeByTop10Platforms: sl(),
      getStreamTypeByTop10Users: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => PlayTotalsGraphsBloc(
      getPlaysPerMonth: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => GetPlaysByDate(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetPlaysByDayOfWeek(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetPlaysByHourOfDay(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetPlaysBySourceResolution(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetPlaysByStreamResolution(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetPlaysByStreamType(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetPlaysByTop10Platforms(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetPlaysByTop10Users(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetStreamTypeByTop10Platforms(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetStreamTypeByTop10Users(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetPlaysPerMonth(
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

  // Data source
  sl.registerLazySingleton<GraphsDataSource>(
    () => GraphsDataSourceImpl(
        apiGetPlaysByDate: sl(),
        apiGetPlaysByDayOfWeek: sl(),
        apiGetPlaysByHourOfDay: sl(),
        apiGetPlaysBySourceResolution: sl(),
        apiGetPlaysByStreamResolution: sl(),
        apiGetPlaysByStreamType: sl(),
        apiGetPlaysByTop10Platforms: sl(),
        apiGetPlaysByTop10Users: sl(),
        apiGetStreamTypeByTop10Platforms: sl(),
        apiGetStreamTypeByTop10Users: sl(),
        apiGetPlaysPerMonth: sl()),
  );

  //! Features - History
  // Bloc
  sl.registerFactory(
    () => HistoryBloc(
      getHistory: sl(),
      getImageUrl: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => HistoryIndividualBloc(
      getHistory: sl(),
      getUsersTable: sl(),
      getImageUrl: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => HistoryLibrariesBloc(
      getHistory: sl(),
      getImageUrl: sl(),
      logging: sl(),
    ),
  );

  // Use case
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
    ),
  );

  // Data source
  sl.registerLazySingleton<HistoryDataSource>(
    () => HistoryDataSourceImpl(
      apiGetHistory: sl(),
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
    ),
  );

  // Data sources
  sl.registerLazySingleton<ImageUrlDataSource>(
    () => ImageUrlDataSourceImpl(
      apiPmsImageProxy: sl(),
    ),
  );

  //! Features - Libraries
  // Bloc
  sl.registerFactory(
    () => LibrariesBloc(
      getLibrariesTable: sl(),
      getImageUrl: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => LibraryMediaBloc(
      getLibraryMediaInfo: sl(),
      getImageUrl: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => LibraryStatisticsBloc(
      getLibraryUserStats: sl(),
      getLibraryWatchTimeStats: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => GetLibrariesTable(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetLibraryMediaInfo(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetLibraryWatchTimeStats(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetLibraryUserStats(
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

  sl.registerLazySingleton<LibraryStatisticsRepository>(
    () => LibraryStatisticsRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<LibrariesDataSource>(
    () => LibrariesDataSourceImpl(
      apiGetLibrariesTable: sl(),
    ),
  );

  sl.registerLazySingleton<LibraryMediaDataSource>(
    () => LibraryMediaDataSourceImpl(
      apiGetLibraryMediaInfo: sl(),
    ),
  );

  sl.registerLazySingleton<LibraryStatisticsDataSource>(
    () => LibraryStatisticsDataSourceImpl(
      apiGetLibraryUserStats: sl(),
      apiGetLibraryWatchTimeStats: sl(),
    ),
  );

  //! Features - Logging
  // Bloc
  sl.registerFactory(
    () => LogsBloc(
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

  sl.registerLazySingleton<LibraryMediaRepository>(
    () => LibraryMediaRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<LoggingDataSource>(
    () => LoggingDataSourceImpl(),
  );

  //! Features - Metadata
  // Bloc
  sl.registerFactory(
    () => MetadataBloc(
      getMetadata: sl(),
      getImageUrl: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => ChildrenMetadataBloc(
      getChildrenMetadata: sl(),
      getImageUrl: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => GetMetadata(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetChildrenMetadata(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<MetadataRepository>(
    () => MetadataRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<ChildrenMetadataRepository>(
    () => ChildrenMetadataRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<MetadataDataSource>(
    () => MetadataDataSourceImpl(
      apiGetMetadata: sl(),
    ),
  );

  sl.registerLazySingleton<ChildrenMetadataDataSource>(
    () => ChildrenMetadataDataSourceImpl(
      apiGetChildrenMetadata: sl(),
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
      settings: sl(),
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

  sl.registerFactory(
    () => LibrariesRecentlyAddedBloc(
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
    ),
  );

  // Data source
  sl.registerLazySingleton<RecentlyAddedDataSource>(
    () => RecentlyAddedDataSourceImpl(
      apiGetRecentlyAdded: sl(),
    ),
  );

  //! Features - Settings
  // Bloc
  sl.registerFactory(
    () => SettingsBloc(
      settings: sl(),
      registerDevice: sl(),
      onesignal: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => RegisterDeviceBloc(
      registerDevice: sl(),
      onesignal: sl(),
      settings: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => RegisterDeviceHeadersBloc(),
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
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<RegisterDeviceRepository>(
    () => RegisterDeviceRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SettingsDataSource>(
    () => SettingsDataSourceImpl(
      sharedPreferences: sl(),
      apiGetServerInfo: sl(),
      apiGetSettings: sl(),
    ),
  );

  sl.registerLazySingleton<RegisterDeviceDataSource>(
    () => RegisterDeviceDataSourceImpl(
      apiRegisterDevice: sl(),
      deviceInfo: sl(),
      oneSignal: sl(),
    ),
  );

  //! Features - Statistics
  // Bloc
  sl.registerFactory(
    () => StatisticsBloc(
      getStatistics: sl(),
      getImageUrl: sl(),
      logging: sl(),
    ),
  );

  // Use case
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
    ),
  );

  // Data source
  sl.registerLazySingleton<StatisticsDataSource>(
    () => StatisticsDataSourceImpl(
      apiGetHomeStats: sl(),
    ),
  );

  //! Features - Synced
  // Bloc
  sl.registerFactory(
    () => SyncedItemsBloc(
      getSyncedItems: sl(),
      getMetadata: sl(),
      getImageUrl: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => DeleteSyncedItemBloc(
      deleteSyncedItem: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => GetSyncedItems(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => DeleteSyncedItem(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<SyncedItemsRepository>(
    () => SyncedItemsRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<DeleteSyncedItemRepository>(
    () => DeleteSyncedItemRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<SyncedItemsDataSource>(
    () => SyncedItemsDataSourceImpl(
      apiGetSyncedItems: sl(),
    ),
  );

  sl.registerLazySingleton<DeleteSyncedItemDataSource>(
    () => DeleteSyncedItemDataSourceImpl(
      apiDeleteSyncedItem: sl(),
    ),
  );

  //! Features - TerminateSession
  // Bloc
  sl.registerFactory(
    () => TerminateSessionBloc(
      terminateSession: sl(),
      logging: sl(),
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
    ),
  );

  // Data sources
  sl.registerLazySingleton<TerminateSessionDataSource>(
    () => TerminateSessionDataSourceImpl(
      apiTerminateSession: sl(),
    ),
  );

  //! Features - Translate
  sl.registerFactory(
    () => TranslateBloc(
      logging: sl(),
    ),
  );

  //! Features - Users
  // Bloc
  sl.registerFactory(
    () => UserBloc(
      getUser: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => UsersBloc(
      getUsersTable: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => UsersListBloc(
      getUserNames: sl(),
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => UserStatisticsBloc(
      getUserPlayerStats: sl(),
      getUserWatchTimeStats: sl(),
      logging: sl(),
    ),
  );

  // Use case
  sl.registerLazySingleton(
    () => GetUser(
      repository: sl(),
    ),
  );
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

  sl.registerLazySingleton(
    () => GetUserWatchTimeStats(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetUserPlayerStats(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<UsersRepository>(
    () => UsersTableRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<UserStatisticsRepository>(
    () => UserStatisticsRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data source
  sl.registerLazySingleton<UsersDataSource>(
    () => UsersDataSourceImpl(
      apiGetUser: sl(),
      apiGetUserNames: sl(),
      apiGetUsersTable: sl(),
    ),
  );

  sl.registerLazySingleton<UserStatisticsDataSource>(
    () => UserStatisticsDataSourceImpl(
      apiGetUserPlayerStats: sl(),
      apiGetUserWatchTimeStats: sl(),
    ),
  );

  //! Features - Wizard
  // Bloc
  sl.registerFactory(
    () => WizardBloc(),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivityChecker: sl(),
    ),
  );

  sl.registerLazySingleton<DeviceInfo>(
    () => DeviceInfoImpl(
      sl(),
    ),
  );

  //! API
  sl.registerLazySingleton<tautulli_api.ConnectionHandler>(
    () => tautulli_api.ConnectionHandlerImpl(
      callTautulli: sl(),
      logging: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.CallTautulli>(
    () => tautulli_api.CallTautulliImpl(
      logging: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.DeleteMobileDevice>(
    () => tautulli_api.DeleteMobileDeviceImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.DeleteSyncedItem>(
    () => tautulli_api.DeleteSyncedItemImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetActivity>(
    () => tautulli_api.GetActivityImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetChildrenMetadata>(
    () => tautulli_api.GetChildrenMetadataImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetGeoipLookup>(
    () => tautulli_api.GetGeoipLookupImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetHistory>(
    () => tautulli_api.GetHistoryImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetHomeStats>(
    () => tautulli_api.GetHomeStatsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetLibrariesTable>(
    () => tautulli_api.GetLibrariesTableImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetLibraryMediaInfo>(
    () => tautulli_api.GetLibraryMediaInfoImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetLibraryUserStats>(
    () => tautulli_api.GetLibraryUserStatsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetLibraryWatchTimeStats>(
    () => tautulli_api.GetLibraryWatchTimeStatsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetMetadata>(
    () => tautulli_api.GetMetadataImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByDate>(
    () => tautulli_api.GetPlaysByDateImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByDayOfWeek>(
    () => tautulli_api.GetPlaysByDayOfWeekImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByHourOfDay>(
    () => tautulli_api.GetPlaysByHourOfDayImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysBySourceResolution>(
    () => tautulli_api.GetPlaysBySourceResolutionImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByStreamResolution>(
    () => tautulli_api.GetPlaysByStreamResolutionImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByStreamType>(
    () => tautulli_api.GetPlaysByStreamTypeImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByTop10Platforms>(
    () => tautulli_api.GetPlaysByTop10PlatformsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysByTop10Users>(
    () => tautulli_api.GetPlaysByTop10UsersImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetPlaysPerMonth>(
    () => tautulli_api.GetPlaysPerMonthImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetRecentlyAdded>(
    () => tautulli_api.GetRecentlyAddedImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetServerInfo>(
    () => tautulli_api.GetServerInfoImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetSettings>(
    () => tautulli_api.GetSettingsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetStreamTypeByTop10Platforms>(
    () => tautulli_api.GetStreamTypeByTop10PlatformsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetStreamTypeByTop10Users>(
    () => tautulli_api.GetStreamTypeByTop10UsersImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetSyncedItems>(
    () => tautulli_api.GetSyncedItemsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetUser>(
    () => tautulli_api.GetUserImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetUserNames>(
    () => tautulli_api.GetUserNamesImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetUserPlayerStats>(
    () => tautulli_api.GetUserPlayerStatsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetUserWatchTimeStats>(
    () => tautulli_api.GetUserWatchTimeStatsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.GetUsersTable>(
    () => tautulli_api.GetUsersTableImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.PmsImageProxy>(
    () => tautulli_api.PmsImageProxyImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.RegisterDevice>(
    () => tautulli_api.RegisterDeviceImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulli_api.TerminateSession>(
    () => tautulli_api.TerminateSessionImpl(
      connectionHandler: sl(),
    ),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => DeviceInfoPlugin());
  sl.registerLazySingleton(() => DefaultCacheManager());
}
