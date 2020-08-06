import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../data/datasources/onesignal_data_source.dart';

part 'onesignal_health_event.dart';
part 'onesignal_health_state.dart';

class OneSignalHealthBloc
    extends Bloc<OneSignalHealthEvent, OneSignalHealthState> {
  final OneSignalDataSource oneSignal;
  final Logging logging;

  OneSignalHealthBloc({
    @required this.oneSignal,
    @required this.logging,
  }) : super(OneSignalHealthInitial());

  @override
  Stream<OneSignalHealthState> mapEventToState(
    OneSignalHealthEvent event,
  ) async* {
    if (event is OneSignalHealthCheck) {
      yield OneSignalHealthInProgress();
      if (await oneSignal.isReachable) {
        yield OneSignalHealthSuccess();
      } else {
        logging.warning('OneSignal: Failed to communicate with OneSignal');
        yield OneSignalHealthFailure();
      }
    }
  }
}
