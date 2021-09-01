// @dart=2.9

import '../../../../core/helpers/value_helper.dart';
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
      friendlyName: ValueHelper.cast(
        value: json['friendly_name'],
        type: CastType.string,
      ),
      userId: ValueHelper.cast(
        value: json['user_id'],
        type: CastType.int,
      ),
    );
  }
}
