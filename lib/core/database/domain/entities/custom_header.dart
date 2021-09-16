// @dart=2.9

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CustomHeader extends Equatable {
  final String key;
  final String value;

  CustomHeader({
    @required this.key,
    @required this.value,
  });

  @override
  List<Object> get props => [key, value];
}
