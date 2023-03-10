import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custom_header_model.g.dart';

@JsonSerializable()
class CustomHeaderModel extends Equatable {
  final String key;
  final String value;

  const CustomHeaderModel({
    required this.key,
    required this.value,
  });

  @override
  List<Object> get props => [key, value];

  factory CustomHeaderModel.fromJson(Map<String, dynamic> json) =>
      _$CustomHeaderModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomHeaderModelToJson(this);
}
