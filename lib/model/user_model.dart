import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

int? _intFromJson(dynamic json) {
  if (json == null) return null;
  if (json is num) return json.toInt();
  if (json is String) return int.tryParse(json);
  return null;
}

@JsonSerializable()
class UserModel {
  @JsonKey(fromJson: _intFromJson)
  final int? id;
  final String? name;
  final String? email;
  @JsonKey(name: 'jenis_kelamin')
  final String? jenisKelamin;
  @JsonKey(name: 'batch_id', fromJson: _intFromJson)
  final int? batchId;
  @JsonKey(name: 'training_id', fromJson: _intFromJson)
  final int? trainingId;
  @JsonKey(name: 'profile_photo')
  final String? profilePhoto;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.jenisKelamin,
    this.batchId,
    this.trainingId,
    this.profilePhoto,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
