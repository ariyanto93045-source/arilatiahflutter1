import 'package:json_annotation/json_annotation.dart';

part 'batch_model.g.dart';

int? _intFromJson(dynamic json) {
  if (json == null) return null;
  if (json is num) return json.toInt();
  if (json is String) return int.tryParse(json);
  return null;
}

@JsonSerializable()
class BatchModel {
  @JsonKey(fromJson: _intFromJson)
  final int? id;
  final String? title;
  final String? name; // Fallback in case API uses 'name'
  @JsonKey(name: 'batch_ke')
  final String? batchKe;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;

  BatchModel({
    this.id,
    this.title,
    this.name,
    this.batchKe,
    this.startDate,
    this.endDate,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) =>
      _$BatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BatchModelToJson(this);
}
