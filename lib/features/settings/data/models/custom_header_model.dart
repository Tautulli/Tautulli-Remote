import '../../domain/entities/custom_header.dart';

class CustomHeaderModel extends CustomHeader {
  const CustomHeaderModel({
    required String key,
    required String value,
  }) : super(
          key: key,
          value: value,
        );
}
