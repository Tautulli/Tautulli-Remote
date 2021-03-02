import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/tautulli_api/tautulli_api.dart' as tautulliApi;
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
import 'features/libraries/data/repositories/libraries_repository_impl.dart';
import 'features/libraries/data/repositories/library_media_repository_impl.dart';
import 'features/libraries/domain/repositories/libraries_repository.dart';
import 'features/libraries/domain/repositories/library_media_repository.dart';
import 'features/libraries/domain/usecases/get_libraries_table.dart';
import 'features/libraries/domain/usecases/get_library_media_info.dart';
import 'features/libraries/presentation/bloc/libraries_bloc.dart';
import 'features/libraries/presentation/bloc/library_media_bloc.dart';
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
import 'features/users/data/datasources/users_data_source.dart';
import 'features/users/data/repositories/users_repository_impl.dart';
import 'features/users/domain/repositories/users_repository.dart';
import 'features/users/domain/usecases/get_user_names.dart';
import 'features/users/domain/usecases/get_users_table.dart';
import 'features/users/presentation/bloc/users_bloc.dart';
import 'features/users/presentation/bloc/users_list_bloc.dart';

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

  // Repository
  sl.registerLazySingleton<LibrariesRepository>(
    () => LibrariesRepositoryImpl(
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
      logging: sl(),
    ),
  );

  sl.registerFactory(
    () => RegisterDeviceBloc(
      registerDevice: sl(),
      settings: sl(),
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

  //! Features - Users
  // Bloc
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
    ),
  );

  // Data source
  sl.registerLazySingleton<UsersDataSource>(
    () => UsersDataSourceImpl(
      apiGetUserNames: sl(),
      apiGetUsersTable: sl(),
    ),
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

  // API
  sl.registerLazySingleton<tautulliApi.ConnectionHandler>(
    () => tautulliApi.ConnectionHandlerImpl(
      callTautulli: sl(),
      logging: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.CallTautulli>(
    () => tautulliApi.CallTautulliImpl(
      client: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.DeleteMobileDevice>(
    () => tautulliApi.DeleteMobileDeviceImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.DeleteSyncedItem>(
    () => tautulliApi.DeleteSyncedItemImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetActivity>(
    () => tautulliApi.GetActivityImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetChildrenMetadata>(
    () => tautulliApi.GetChildrenMetadataImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetGeoipLookup>(
    () => tautulliApi.GetGeoipLookupImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetHistory>(
    () => tautulliApi.GetHistoryImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetHomeStats>(
    () => tautulliApi.GetHomeStatsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetLibrariesTable>(
    () => tautulliApi.GetLibrariesTableImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetLibraryMediaInfo>(
    () => tautulliApi.GetLibraryMediaInfoImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetMetadata>(
    () => tautulliApi.GetMetadataImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetRecentlyAdded>(
    () => tautulliApi.GetRecentlyAddedImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetServerInfo>(
    () => tautulliApi.GetServerInfoImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetSettings>(
    () => tautulliApi.GetSettingsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetSyncedItems>(
    () => tautulliApi.GetSyncedItemsImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetUserNames>(
    () => tautulliApi.GetUserNamesImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.GetUsersTable>(
    () => tautulliApi.GetUsersTableImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.PmsImageProxy>(
    () => tautulliApi.PmsImageProxyImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.RegisterDevice>(
    () => tautulliApi.RegisterDeviceImpl(
      connectionHandler: sl(),
    ),
  );
  sl.registerLazySingleton<tautulliApi.TerminateSession>(
    () => tautulliApi.TerminateSessionImpl(
      connectionHandler: sl(),
    ),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => DeviceInfoPlugin());
}
