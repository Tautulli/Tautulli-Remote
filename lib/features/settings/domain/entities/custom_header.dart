import 'package:equatable/equatable.dart';

class CustomHeader extends Equatable {
  final String key;
  final String value;

  const CustomHeader({
    required this.key,
    required this.value,
  });

  @override
  List<Object> get props => [key, value];
}
