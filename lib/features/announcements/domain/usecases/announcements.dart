import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/announcement_model.dart';
import '../repositories/announcements_repository.dart';

class Announcements {
  final AnnouncementsRepository repository;

  Announcements({required this.repository});

  Future<Either<Failure, List<AnnouncementModel>>> get() async {
    return await repository.getAnnouncements();
  }
}
