import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String friendlyName;
  final int userId;

  User({
    this.friendlyName,
    this.userId,
  });

  @override
  List<Object> get props => [friendlyName, userId];

  @override
  bool get stringify => true;
}
