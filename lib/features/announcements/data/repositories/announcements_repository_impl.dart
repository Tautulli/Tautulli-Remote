import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_mapper_helper.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcements_repository.dart';
import '../datasources/announcements_data_source.dart';

class AnnouncementsRepositoryImpl implements AnnouncementsRepository {
  final AnnouncementsDataSource dataSource;
  final NetworkInfo networkInfo;

  AnnouncementsRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Announcement>>> getAnnouncements() async {
    if (await networkInfo.isConnected) {
      try {
        final announcements = await dataSource.getAnnouncements();
        return Right(announcements);
      } catch (exception) {
        final Failure failure =
            FailureMapperHelper.mapExceptionToFailure(exception);
        return (Left(failure));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
