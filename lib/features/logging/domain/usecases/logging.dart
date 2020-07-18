import 'package:f_logs/f_logs.dart';
import 'package:meta/meta.dart';

import '../repositories/logging_repository.dart';

class Logging {
  final LoggingRepository repository;

  Logging({@required this.repository});

  dynamic debug(String text) {
    repository.debug(text);
  }

  dynamic info(String text) {
    repository.info(text);
  }

  dynamic warning(String text) {
    repository.warning(text);
  }

  dynamic error(String text) {
    repository.error(text);
  }

  Future<List<Log>> getAllLogs() {
    return repository.getAllLogs();
  }

  dynamic clearLogs() {
    repository.clearLogs();
  }
}
