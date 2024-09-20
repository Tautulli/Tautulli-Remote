import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/tautulli/models/plex_info_model.dart';
import '../../../../core/api/tautulli/models/register_device_model.dart';
import '../../../../core/api/tautulli/models/tautulli_general_settings_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/types/play_metric_type.dart';
import '../../../../core/types/theme_enhancement_type.dart';
import '../../../../core/types/theme_type.dart';
import '../../data/models/connection_address_model.dart';
import '../../data/models/custom_header_model.dart';
import '../repositories/settings_repository.dart';

class Settings {
  final SettingsRepository repository;

  Settings({required this.repository});

  //* API Calls

  /// Returns a bool to indicate success of the API call as well as a bool to
  /// indicate the active connection address.
  Future<Either<Failure, Tuple2<bool, bool>>> deleteImageCache(
    String tautulliId,
  ) async {
    return await repository.deleteImageCache(tautulliId);
  }

  /// Returns `PlexInfoModel` as well as a bool to indicate the active
  /// connection address.
  Future<Either<Failure, Tuple2<PlexInfoModel, bool>>> getPlexInfo(
    String tautulliId,
  ) async {
    return await repository.getPlexInfo(tautulliId);
  }

  /// Returns `TautulliGeneralSettingsModel` as well as a bool to indicate the
  /// active connection address.
  Future<Either<Failure, Tuple2<TautulliGeneralSettingsModel, bool>>> getTautulliSettings(String tautulliId) async {
    return await repository.getTautulliSettings(tautulliId);
  }

  /// Used to register with a Tautulli server.
  ///
  /// When successful returns a `RegisterDeviceModel` containing response data
  /// as well as a bool to indicate the active connection address.
  ///
  /// Set `trustCert` to true to add the certificate's hash to a list of user
  /// trusted certificates that could not be authenticated by
  /// any of the built in trusted root certificates.
  Future<Either<Failure, Tuple2<RegisterDeviceModel, bool>>> registerDevice({
    required String connectionProtocol,
    required String connectionDomain,
    required String connectionPath,
    required String deviceToken,
    List<CustomHeaderModel>? customHeaders,
    bool trustCert = false,
  }) async {
    return await repository.registerDevice(
      connectionProtocol: connectionProtocol,
      connectionDomain: connectionDomain,
      connectionPath: connectionPath,
      deviceToken: deviceToken,
      customHeaders: customHeaders,
      trustCert: trustCert,
    );
  }

  //* Database Interactions

  /// Inserts the provided `ServerModel` into the database.
  ///
  /// Returns the ID of the last inserted row;
  Future<int> addServer(ServerModel server) async {
    return await repository.addServer(server);
  }

  /// Deletes the server with the provided `id` from the database.
  Future<void> deleteServer(int id) async {
    return await repository.deleteServer(id);
  }

  /// Returns a list of `ServerModel` with all servers in the database.
  ///
  /// List will be empty if there are no servers.
  Future<List<ServerModel>> getAllServers() async {
    return await repository.getAllServers();
  }

  /// Returns a `ServerModel` for the corresponding Tautulli ID.
  ///
  /// Returns null if no server is found.
  Future<ServerModel?> getServerByTautulliId(String tautulliId) async {
    return await repository.getServerByTautulliId(tautulliId);
  }

  Future<List<ServerModel>?> getAllServersWithoutOnesignalRegistered() async {
    return await repository.getAllServersWithoutOnesignalRegistered();
  }

  /// Updates the server with `id` using the information in
  /// `ConnectionAddressModel`.
  Future<int> updateConnectionInfo({
    required int id,
    required ConnectionAddressModel connectionAddress,
  }) async {
    return await repository.updateConnectionInfo(
      id: id,
      connectionAddress: connectionAddress,
    );
  }

  /// Updates the server with the provided `tautulliId` with the list of
  /// `CustomHeaderModel`.
  ///
  /// This list should contain all headers for the server.
  Future<int> updateCustomHeaders({
    required String tautulliId,
    required List<CustomHeaderModel> headers,
  }) async {
    return await repository.updateCustomHeaders(
      tautulliId: tautulliId,
      headers: headers,
    );
  }

  /// Updates the primary active state of the server with `tautulliId`
  ///
  /// Primary Active is used to determine if the primary connection address is
  /// active or not.
  Future<int> updatePrimaryActive({
    required String tautulliId,
    required bool primaryActive,
  }) async {
    return await repository.updatePrimaryActive(
      tautulliId: tautulliId,
      primaryActive: primaryActive,
    );
  }

  /// Updates the server with the provided `ServerModel` data.
  Future<int> updateServer(ServerModel server) async {
    return await repository.updateServer(server);
  }

  /// Updates the server sort by taking the server with provided `serverId` and
  ///moving it from `oldIndex` to `newIndex`.
  Future<void> updateServerSort({
    required int serverId,
    required int oldIndex,
    required int newIndex,
  }) async {
    return await repository.updateServerSort(
      serverId: serverId,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
  }

  //* Store & Retrive Values

  /// Returns the Server ID for the active server.
  ///
  /// If no value is stored returns an empty string.
  String getActiveServerId() {
    return repository.getActiveServerId();
  }

  /// Sets the active server ID.
  Future<bool> setActiveServerId(String value) async {
    return await repository.setActiveServerId(value);
  }

  /// Returns if there is an available app update on the App Store or Play Store.
  ///
  /// If no value is stored returns `false`.
  bool getAppUpdateAvailable() {
    return repository.getAppUpdateAvailable();
  }

  /// Sets if there is an available app update on the App Store or Play Store.
  Future<bool> setAppUpdateAvailable(bool value) async {
    return await repository.setAppUpdateAvailable(value);
  }

  /// Returns a list of user approved certificate hashes.
  ///
  /// Used for communicating with servers that could not be authenticated by
  /// any of the built in trusted root certificates.
  ///
  /// If no value is stored returns an empty list.
  List<int> getCustomCertHashList() {
    return repository.getCustomCertHashList();
  }

  /// Sets the list of approved custom cert hashes.
  Future<bool> setCustomCertHashList(List<int> certHashList) async {
    return await repository.setCustomCertHashList(certHashList);
  }

  /// Returns if background images should be disabled.
  ///
  /// If no value is stored returns `false`.
  bool getDisableImageBackgrounds() {
    return repository.getDisableImageBackgrounds();
  }

  /// Sets if background images should be disabled.
  Future<bool> setDisableImageBackgrounds(bool value) {
    return repository.setDisableImageBackgrounds(value);
  }

  /// Returns if exiting the app should require two sequential back actions.
  ///
  /// If no value is stored returns `false`.
  bool getDoubleBackToExit() {
    return repository.getDoubleBackToExit();
  }

  /// Sets if exiting the app should require two sequential back actions.
  Future<bool> setDoubleBackToExit(bool value) async {
    return await repository.setDoubleBackToExit(value);
  }

  /// Returns the number of days to display for graphs.
  ///
  /// If no value is stored returns `30`.
  int getGraphTimeRange() {
    return repository.getGraphTimeRange();
  }

  /// Sets the number of days to display for graphs.
  Future<bool> setGraphTimeRange(int value) async {
    return await repository.setGraphTimeRange(value);
  }

  /// Returns if the graph tips dialog has been shown.
  ///
  /// If no value is stored returns `false`.
  bool getGraphTipsShown() {
    return repository.getGraphTipsShown();
  }

  /// Sets if the graph tips dialog has been shown.
  Future<bool> setGraphTipsShown(bool value) async {
    return await repository.setGraphTipsShown(value);
  }

  /// Returns the initial type of graph y axis to use.
  ///
  /// If no value is stored returns `GraphYAxis.plays`.
  PlayMetricType getGraphYAxis() {
    return repository.getGraphYAxis();
  }

  /// Sets the initial y axis to be used by the graphs.
  Future<bool> setGraphYAxis(PlayMetricType value) async {
    return await repository.setGraphYAxis(value);
  }

  /// Returns a `Map` of the history filter.
  ///
  /// If no value is stored returns an empty map.
  Map<String, bool> getHistoryFilter() {
    return repository.getHistoryFilter();
  }

  /// Sets the history filter values.
  Future<bool> setHistoryFilter(Map<String, bool> map) {
    return repository.setHistoryFilter(map);
  }

  /// Returns the home page to use.
  ///
  /// If no value is stored returns 'activity'.
  String getHomePage() {
    return repository.getHomePage();
  }

  /// Sets the home page to be used.
  Future<bool> setHomePage(String value) {
    return repository.setHomePage(value);
  }

  /// Returns the app version from the last time the app was started.
  ///
  /// Used to determine if the changelog page should be displayed on start.
  ///
  /// If no value is stored returns ``.
  String getLastAppVersion() {
    return repository.getLastAppVersion();
  }

  /// Sets the last app version.
  Future<bool> setLastAppVersion(String value) async {
    return await repository.setLastAppVersion(value);
  }

  /// Returns the last read announcement ID.
  ///
  /// Used to determine if there are unread announcements and which ones are
  /// unread.
  ///
  /// If no value is stored returns `0`.
  int getLastReadAnnouncementId() {
    return repository.getLastReadAnnouncementId();
  }

  /// Sets the last read announcement ID.
  Future<bool> setLastReadAnnouncementId(int value) async {
    return await repository.setLastReadAnnouncementId(value);
  }

  /// Returns the order_column and order_dir for Libraries.
  ///
  /// Items are returned in a string connected by a `|`.
  ///
  /// If no value is stored returns `section_name|asc`.
  String getLibrariesSort() {
    return repository.getLibrariesSort();
  }

  /// Sets the libraries sort.
  Future<bool> setLibrariesSort(String value) async {
    return await repository.setLibrariesSort(value);
  }

  /// Returns if refreshing library media should do a full refresh.
  ///
  /// If no value is stored returns `true`.
  bool getLibraryMediaFullRefresh() {
    return repository.getLibraryMediaFullRefresh();
  }

  /// Sets if refreshing library media should do a full refresh.
  Future<bool> setLibraryMediaFullRefresh(bool value) async {
    return await repository.setLibraryMediaFullRefresh(value);
  }

  /// Returns if the app should mask sensitive info.
  ///
  /// If no value is stored returns `false`.
  bool getMaskSensitiveInfo() {
    return repository.getMaskSensitiveInfo();
  }

  /// Sets if the app should mask sensitive info.
  Future<bool> setMaskSensitiveInfo(bool value) async {
    return await repository.setMaskSensitiveInfo(value);
  }

  /// Returns if the activity page should display activity from all servers.
  ///
  /// If no value is stored returns `false`.
  bool getMultiserverActivity() {
    return repository.getMultiserverActivity();
  }

  /// Sets if the activity page should display activity from all servers.
  Future<bool> setMultiserverActivity(bool value) async {
    return await repository.setMultiserverActivity(value);
  }

  /// Returns if the OneSignal Banner has been dismissed when determining if
  /// it should be displayed.
  ///
  /// If no value is stored returns `false`.
  bool getOneSignalBannerDismissed() {
    return repository.getOneSignalBannerDismissed();
  }

  /// Sets if the OneSignal banner has been manually dismissed.
  Future<bool> setOneSignalBannerDismissed(bool value) async {
    return await repository.setOneSignalBannerDismissed(value);
  }

  /// Returns if the user has consented to OneSignal.
  ///
  /// Used to account for issues where updating OneSignal clears out the
  /// consent status.
  ///
  /// If no value is stored returns `false`.
  bool getOneSignalConsented() {
    return repository.getOneSignalConsented();
  }

  /// Sets if OneSignal data privacy has been consented to.
  Future<bool> setOneSignalConsented(bool value) async {
    return await repository.setOneSignalConsented(value);
  }

  /// Returns the Recently Added filter value.
  ///
  /// If no value is stored returns `all`.
  String getRecentlyAddedFilter() {
    return repository.getRecentlyAddedFilter();
  }

  /// Sets the Recently Added filter value.
  Future<bool> setRecentlyAddedFilter(String value) async {
    return await repository.setRecentlyAddedFilter(value);
  }

  /// Returns the refresh rate used for auto refreshing activity.
  ///
  /// If no value is stored returns `0`.
  int getRefreshRate() {
    return repository.getRefreshRate();
  }

  /// Set the refresh rate used when automatically updating the activity.
  Future<bool> setRefreshRate(int value) async {
    return await repository.setRefreshRate(value);
  }

  /// Returns if a registation update is needed.
  /// Typically the result of an app update where the server needs the new app version.
  ///
  /// If no value is stored returns `false`.
  bool getRegistrationUpdateNeeded() {
    return repository.getRegistrationUpdateNeeded();
  }

  /// Set if a registration update is needed.
  Future<bool> setRegistrationUpdateNeeded(bool value) async {
    return await repository.setRegistrationUpdateNeeded(value);
  }

  /// What is a man? A miserable little pile of secrets.
  bool getSecret() {
    return repository.getSecret();
  }

  /// It ain't no secret I didn't get these scars falling over in church.
  Future<bool> setSecret(bool value) async {
    return await repository.setSecret(value);
  }

  /// How long to wait in seconds before timing out the server connection.
  ///
  /// If no value is stored returns `15`.
  int getServerTimeout() {
    return repository.getServerTimeout();
  }

  /// Sets the time to wait in seconds before timing out the server connection.
  Future<bool> setServerTimeout(int value) async {
    return await repository.setServerTimeout(value);
  }

  /// Returns the number of days to use for statistics.
  ///
  /// If no value is stored returns `30`.
  int getStatisticsTimeRange() {
    return repository.getStatisticsTimeRange();
  }

  /// Sets the number of days to use for statistics.
  Future<bool> setStatisticsTimeRange(int value) async {
    return await repository.setStatisticsTimeRange(value);
  }

  /// Returns the `PlayMetricType` to use for statistics.
  ///
  /// If no value is stored returns `PlayMetricType.plays`.
  PlayMetricType getStatisticsStatType() {
    return repository.getStatisticsStatType();
  }

  /// Sets the `PlayMetricType` to use for statistics.
  Future<bool> setStatisticsStatType(PlayMetricType value) async {
    return await repository.setStatisticsStatType(value);
  }

  /// Returns the `ThemeType` to use in the app.
  ///
  /// If no value is stored returns `ThemeType.tautulli`.
  ThemeType getTheme() {
    return repository.getTheme();
  }

  /// Sets the `ThemeType` to use in the app.
  Future<bool> setTheme(ThemeType themeType) {
    return repository.setTheme(themeType);
  }

  /// Returns the custom color set for the dynamic theme.
  ///
  /// If no value is stored returns the int value for `PlexColorPalette.gamboge`.
  Color getThemeCustomColor() {
    return repository.getThemeCustomColor();
  }

  /// Sets the custom color for the dynamic theme.
  Future<bool> setThemeCustomColor(Color color) {
    return repository.setThemeCustomColor(color);
  }

  /// Returns the ThemeEnhancementType to use with the app theme.
  ///
  /// If no value is stored returns null.
  ThemeEnhancementType getThemeEnhancement() {
    return repository.getThemeEnhancement();
  }

  /// Sets the ThemeEnhancementType to use with the app theme.
  Future<bool> setThemeEnhancement(ThemeEnhancementType themeEnhancementType) {
    return repository.setThemeEnhancement(themeEnhancementType);
  }

  /// Returns if the dynamic theme should use the system color.
  ///
  /// If no value is stored and the device is iOS returns `false`, otherwise returns `true`.
  bool getThemeUseSystemColor() {
    return repository.getThemeUseSystemColor();
  }

  /// Sets if the dynamic theme should use the system color.
  Future<bool> setThemeUseSystemColor(bool value) {
    return repository.setThemeUseSystemColor(value);
  }

  /// Returns if the Atkinson Hyperlegible font should be used
  bool getUseAtkinsonHyperlegible() {
    return repository.getUseAtkinsonHyperlegible();
  }

  /// Sets if the Atkinson Hyperlegible font should be used
  Future<bool> setUseAtkinsonHyperlegible(bool value) async {
    return await repository.setUseAtkinsonHyperlegible(value);
  }

  /// Returns the order_column and order_dir for Users.
  ///
  /// Items are returned in a string connected by a `|`.
  ///
  /// If no value is stored returns `friendly_name|asc`.
  String getUsersSort() {
    return repository.getUsersSort();
  }

  /// Sets the users sort.
  Future<bool> setUsersSort(String value) async {
    return await repository.setUsersSort(value);
  }

  /// Whether the wizard was exited early or fully completed.
  ///
  /// If no value is stored returns `false`.
  bool getWizardComplete() {
    return repository.getWizardComplete();
  }

  /// Sets that the wizard has been exited or completed to prevent it from
  /// showing on app start.
  Future<bool> setWizardComplete(bool value) async {
    return await repository.setWizardComplete(value);
  }
}
