import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum LibraryStatisticType {
  watchTime,
  user,
}

class LibraryStatistic extends Equatable {
  final LibraryStatisticType libraryStatisticType;
  final String friendlyName;
  final int queryDays;
  final int totalPlays;
  final int totalTime;
  final int userId;
  final String username;
  final String userThumb;

  LibraryStatistic({
    @required this.libraryStatisticType,
    this.friendlyName,
    this.queryDays,
    this.totalPlays,
    this.totalTime,
    this.userId,
    this.username,
    this.userThumb,
  });

  @override
  List<Object> get props => [
        libraryStatisticType,
        friendlyName,
        queryDays,
        totalPlays,
        totalTime,
        userId,
        username,
        userThumb,
      ];
}
