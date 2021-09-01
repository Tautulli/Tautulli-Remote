// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/announcement.dart';
import '../repositories/announcements_repository.dart';

class GetAnnouncements {
  final AnnouncementsRepository repository;

  GetAnnouncements({@required this.repository});

  Future<Either<Failure, List<Announcement>>> call() async {
    return await repository.getAnnouncements();
  }
}
