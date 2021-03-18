import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

class GetActivity {
  final ActivityRepository repository;

  GetActivity({@required this.repository});

  Future<Either<Failure, List<ActivityItem>>> call({
    @required String tautulliId,
    @required SettingsBloc settingsBloc,
  }) async {
    return await repository.getActivity(
      tautulliId: tautulliId,
      settingsBloc: settingsBloc,
    );
  }
}
