// @dart=2.9

import 'package:meta/meta.dart';

import '../../domain/entities/custom_header.dart';

class CustomHeaderModel extends CustomHeader {
  CustomHeaderModel({
    @required String key,
    @required String value,
  }) : super(
          key: key,
          value: value,
        );
}
