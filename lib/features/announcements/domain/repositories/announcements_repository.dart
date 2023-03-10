import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/announcement_model.dart';

abstract class AnnouncementsRepository {
  Future<Either<Failure, List<AnnouncementModel>>> getAnnouncements();
}
