import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/network_info/network_info.dart';
import '../../domain/repositories/announcements_repository.dart';
import '../datasources/announcements_data_source.dart';
import '../models/announcement_model.dart';

class AnnouncementsRepositoryImpl implements AnnouncementsRepository {
  final AnnouncementsDataSource dataSource;
  final NetworkInfo networkInfo;

  AnnouncementsRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AnnouncementModel>>> getAnnouncements() async {
    if (await networkInfo.isConnected) {
      try {
        final announcements = await dataSource.getAnnouncements();
        return Right(announcements);
      } catch (exception) {
        final Failure failure = FailureHelper.castToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
