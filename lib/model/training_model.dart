import 'package:json_annotation/json_annotation.dart';

part 'training_model.g.dart';

int? _intFromJson(dynamic json) {
  if (json == null) return null;
  if (json is num) return json.toInt();
  if (json is String) return int.tryParse(json);
  return null;
}

@JsonSerializable()
class TrainingModel {
  @JsonKey(fromJson: _intFromJson)
  final int? id;
  final String? title;
  final String? name; // Fallback in case API uses 'name'

  TrainingModel({
    this.id,
    this.title,
    this.name,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) =>
      _$TrainingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingModelToJson(this);
}
