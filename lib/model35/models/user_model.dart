import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "email_verified_at")
  dynamic emailVerifiedAt;

  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;
  @JsonKey(name: "profile_photo")
  String? profilePhoto;
  @JsonKey(name: "profile_photo_url")
  String? profilePhotoUrl;
  @JsonKey(name: "photo")
  String? photo;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.profilePhoto,
    this.profilePhotoUrl,
    this.photo,
  });

  String? get photoUrl => profilePhotoUrl ?? profilePhoto ?? photo;

  bool get hasPhoto => photoUrl?.isNotEmpty ?? false;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
