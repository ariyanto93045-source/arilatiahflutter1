import 'package:json_annotation/json_annotation.dart';

part 'batch_model.g.dart';

@JsonSerializable()
class BatchModel {
  final int? id;
  final String? title;
  final String? name; // Fallback in case API uses 'name'

  BatchModel({
    this.id,
    this.title,
    this.name,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) =>
      _$BatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BatchModelToJson(this);
}
