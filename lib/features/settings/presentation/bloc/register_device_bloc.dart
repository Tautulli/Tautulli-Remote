import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../logging/domain/usecases/logging.dart';
import '../../../onesignal/data/datasources/onesignal_data_source.dart';
import '../../data/models/connection_address_model.dart';
import '../../data/models/custom_header_model.dart';
import '../../domain/usecases/settings.dart';
import 'settings_bloc.dart';

part 'register_device_event.dart';
part 'register_device_state.dart';

String? primaryConnectionAddressCache;
String? secondaryConnectionAddressCache;
String? deviceTokenCache;
List<CustomHeaderModel> customHeadersCache = [];

class RegisterDeviceBloc extends Bloc<RegisterDeviceEvent, RegisterDeviceState> {
  final Logging logging;
  final Settings settings;

  RegisterDeviceBloc({
    required this.logging,
    required this.settings,
  }) : super(RegisterDeviceInitial()) {
    on<RegisterDeviceStarted>(
      (event, emit) => _onRegisterDeviceStarted(event, emit),
    );
    on<RegisterDeviceUnverifiedCert>(
      (event, emit) => _onRegisterDeviceUnverifiedCert(event, emit),
    );
  }

  void _onRegisterDeviceStarted(
    RegisterDeviceStarted event,
    Emitter<RegisterDeviceState> emit,
  ) async {
    primaryConnectionAddressCache = event.primaryConnectionAddress.trim();
    secondaryConnectionAddressCache = event.secondaryConnectionAddress.trim();
    deviceTokenCache = event.deviceToken.trim();
    customHeadersCache = event.headers;

    emit(
      RegisterDeviceInProgress(),
    );

    await _callRegisterDevice(
      emit: emit,
      trustCert: false,
      settingsBloc: event.settingsBloc,
    );
  }

  void _onRegisterDeviceUnverifiedCert(
    RegisterDeviceUnverifiedCert event,
    Emitter<RegisterDeviceState> emit,
  ) async {
    emit(
      RegisterDeviceInProgress(),
    );

    await _callRegisterDevice(
      emit: emit,
      trustCert: true,
      settingsBloc: event.settingsBloc,
    );
  }

  Future<void> _callRegisterDevice({
    required Emitter<RegisterDeviceState> emit,
    required bool trustCert,
    required SettingsBloc settingsBloc,
  }) async {
    final primaryConnectionAddress = ConnectionAddressModel.fromConnectionAddress(
      primary: true,
      connectionAddress: primaryConnectionAddressCache!,
    );

    final failureOrResult = await settings.registerDevice(
      connectionProtocol: primaryConnectionAddress.protocol!.toShortString(),
      connectionDomain: primaryConnectionAddress.domain!,
      connectionPath: primaryConnectionAddress.path ?? '',
      deviceToken: deviceTokenCache!,
      customHeaders: customHeadersCache,
      trustCert: trustCert,
    );

    await failureOrResult.fold(
      (failure) {
        logging.error(
          'RegisterDevice :: Failed to register device [$failure]',
        );

        emit(
          RegisterDeviceFailure(failure),
        );
      },
      (result) async {
        final registerResults = result.value1;
        final bool oneSignalRegistered = await di.sl<OneSignalDataSource>().userId != 'onesignal-disabled';

        try {
          if (registerResults.serverId != null) {
            final existingServer = await settings.getServerByTautulliId(
              registerResults.serverId!,
            );

            if (existingServer == null) {
              settingsBloc.add(
                SettingsAddServer(
                  primaryConnectionAddress: primaryConnectionAddressCache!,
                  secondaryConnectionAddress: secondaryConnectionAddressCache,
                  deviceToken: deviceTokenCache!,
                  tautulliId: registerResults.serverId!,
                  plexName: registerResults.pmsName!,
                  plexIdentifier: registerResults.pmsIdentifier!,
                  plexPass: registerResults.pmsPlexpass!,
                  oneSignalRegistered: oneSignalRegistered,
                  customHeaders: customHeadersCache,
                ),
              );

              emit(
                RegisterDeviceSuccess(
                  serverName: registerResults.pmsName!,
                  isUpdate: false,
                ),
              );
            } else {
              settingsBloc.add(
                SettingsUpdateServer(
                  id: existingServer.id!,
                  sortIndex: existingServer.sortIndex,
                  primaryConnectionAddress: primaryConnectionAddressCache!,
                  secondaryConnectionAddress: secondaryConnectionAddressCache ?? '',
                  deviceToken: deviceTokenCache!,
                  tautulliId: registerResults.serverId!,
                  plexName: registerResults.pmsName!,
                  plexIdentifier: registerResults.pmsIdentifier!,
                  plexPass: registerResults.pmsPlexpass!,
                  oneSignalRegistered: oneSignalRegistered,
                  customHeaders: customHeadersCache,
                  dateFormat: existingServer.dateFormat,
                  timeFormat: existingServer.timeFormat,
                ),
              );
            }
            emit(
              RegisterDeviceSuccess(
                serverName: registerResults.pmsName!,
                isUpdate: true,
              ),
            );
            settings.setRegistrationUpdateNeeded(false);
          } else {
            throw BadApiResponseException();
          }
        } catch (e) {
          final failure = FailureHelper.castToFailure(e);

          logging.error(
            'RegisterDevice :: Failed to properly save server [$failure]',
          );

          emit(
            RegisterDeviceFailure(failure),
          );
        }
      },
    );
  }
}
