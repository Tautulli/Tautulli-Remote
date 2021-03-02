import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/announcement.dart';

abstract class AnnouncementsRepository {
  Future<Either<Failure, List<Announcement>>> getAnnouncements();
}
