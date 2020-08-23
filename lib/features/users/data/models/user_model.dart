import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    String friendlyName,
    int userId,
  }) : super(
          friendlyName: friendlyName,
          userId: userId,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      friendlyName: json['friendly_name'],
      userId: json['user_id'],
    );
  }
}
